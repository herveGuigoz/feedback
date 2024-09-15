<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiProperty;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Link;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Post;
use App\Repository\FeedbackRepository;
use App\State\FeedbackPersistProcessor;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\IdGenerator\UuidGenerator;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Serializer\Annotation\Groups;
use Symfony\Component\Serializer\Normalizer\AbstractNormalizer;
use Symfony\Component\Uid\Uuid;
use Symfony\Component\Validator\Constraints as Assert;
use Vich\UploaderBundle\Mapping\Annotation as Vich;

#[ApiResource(
    outputFormats: ['json' => ['application/json']],
    security: "is_granted('ROLE_USER')",
    operations: [
        new GetCollection(
            uriTemplate: '/canvases/{canvasId}/feedbacks',
            uriVariables : [
                'canvasId' => new Link(toProperty: 'canvas', fromClass: Canvas::class),
            ],
            paginationClientItemsPerPage: true,
        ),
        new Get(
            uriTemplate: '/feedbacks/{id}',
            normalizationContext: [
                AbstractNormalizer::GROUPS => ['read', 'feedback:read'],
            ],
        ),
        new Post(
            uriTemplate: '/feedbacks',
            inputFormats: ['multipart' => ['multipart/form-data']],
            processor: FeedbackPersistProcessor::class,
        ),
        new Patch(
            uriTemplate: '/feedbacks/{id}',
            inputFormats: ['json' => ['application/json']],
            processor: FeedbackPersistProcessor::class,
        ),
    ],
    normalizationContext: [
        AbstractNormalizer::GROUPS => ['read'],
    ],
    denormalizationContext: [
        AbstractNormalizer::GROUPS => ['feedback:write'],
    ],
)]
#[ORM\Entity(repositoryClass: FeedbackRepository::class)]
#[Vich\Uploadable]
class Feedback
{
    #[ApiProperty(identifier: true, types: ['https://schema.org/identifier'])]
    #[Groups(['read'])]
    #[ORM\Column(type: UuidType::NAME, unique: true)]
    #[ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\GeneratedValue(strategy: 'CUSTOM')]
    #[ORM\Id]
    private ?Uuid $id = null;

    #[Groups(['read', 'feedback:write'])]
    #[ORM\Column(type: Types::STRING, enumType: FeedbackStatus::class)]
    private FeedbackStatus $status = FeedbackStatus::PENDING;

    #[Groups(['read', 'feedback:write'])]
    #[Assert\NotBlank(allowNull: false)]
    #[ORM\Column(type: Types::STRING, length: 255)]
    private ?string $body = null;

    #[Groups(['read'])]
    #[ORM\Column(type: Types::DATE_IMMUTABLE)]
    private ?\DateTimeImmutable $createdAt = null;

    #[ApiProperty(types: ['https://schema.org/image'])]
    #[Groups(['read'])]
    #[ORM\OneToOne(inversedBy: 'feedback', cascade: ['persist', 'remove'])]
    private ?MediaObject $image = null;

    #[Groups(['read'])]
    #[ORM\ManyToOne(inversedBy: 'feedback')]
    #[ORM\JoinColumn(nullable: false)]
    private ?User $owner = null;

    #[Groups(['feedback:write'])]
    #[ORM\ManyToOne(inversedBy: 'feedbacks')]
    #[ORM\JoinColumn(nullable: false)]
    private ?Canvas $canvas = null;

    /**
     * @var Collection<int, Comment>
     */
    #[Groups(['feedback:read'])]
    #[ORM\OneToMany(targetEntity: Comment::class, mappedBy: 'feedback', orphanRemoval: true)]
    private Collection $comments;

    public function __construct()
    {
        $this->comments = new ArrayCollection();
    }

    public function getId(): ?Uuid
    {
        return $this->id;
    }

    public function getStatus(): ?FeedbackStatus
    {
        return $this->status;
    }

    public function setStatus(FeedbackStatus $status): static
    {
        $this->status = $status;

        return $this;
    }

    public function getBody(): ?string
    {
        return $this->body;
    }

    public function setBody(string $body): static
    {
        $this->body = $body;

        return $this;
    }

    public function getCreatedAt(): ?\DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function setCreatedAt(\DateTimeImmutable $createdAt): static
    {
        $this->createdAt = $createdAt;

        return $this;
    }

    public function getImage(): ?MediaObject
    {
        return $this->image;
    }

    public function setImage(?MediaObject $image): static
    {
        $this->image = $image;

        return $this;
    }

    public function getOwner(): ?User
    {
        return $this->owner;
    }

    public function setOwner(?User $owner): static
    {
        $this->owner = $owner;

        return $this;
    }

    public function getCanvas(): ?Canvas
    {
        return $this->canvas;
    }

    public function setCanvas(?Canvas $canvas): static
    {
        $this->canvas = $canvas;

        return $this;
    }

    /**
     * @return Collection<int, Comment>
     */
    public function getComments(): Collection
    {
        return $this->comments;
    }

    public function addComment(Comment $comment): static
    {
        if (!$this->comments->contains($comment)) {
            $this->comments->add($comment);
            $comment->setFeedback($this);
        }

        return $this;
    }

    public function removeComment(Comment $comment): static
    {
        if ($this->comments->removeElement($comment)) {
            // set the owning side to null (unless already changed)
            if ($comment->getFeedback() === $this) {
                $comment->setFeedback(null);
            }
        }

        return $this;
    }

    public function __toString(): string
    {
        return sprintf('%s: %s', $this->owner->getEmail(), $this->createdAt->format('Y-m-d H:i:s'));
    }
}
