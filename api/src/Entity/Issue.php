<?php

namespace App\Entity;

use ApiPlatform\Doctrine\Orm\Filter\SearchFilter;
use ApiPlatform\Metadata\ApiFilter;
use ApiPlatform\Metadata\ApiProperty;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Patch;
use ApiPlatform\Metadata\Post;
use ApiPlatform\Metadata\QueryParameter;
use App\Repository\IssueRepository;
use App\State\IssuePersistProcessor;
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
            parameters: [
                'url' => new QueryParameter(required: true, description: 'The URL of the canvas'),
            ],
            paginationClientItemsPerPage: true,
        ),
        new Get(
            normalizationContext: [
                AbstractNormalizer::GROUPS => ['read', 'issue:read'],
            ],
        ),
        new Post(
            inputFormats: ['multipart' => ['multipart/form-data']],
            processor: IssuePersistProcessor::class,
        ),
        new Patch(
            inputFormats: ['json' => ['application/json']],
            security: "is_granted('ROLE_ADMIN') or object.getOwner() == user",
        ),
        new Delete(
            security: "is_granted('ROLE_ADMIN') or object.getOwner() == user",
        ),
    ],
    normalizationContext: [
        AbstractNormalizer::GROUPS => ['read'],
    ],
    denormalizationContext: [
        AbstractNormalizer::GROUPS => ['issue:write'],
    ],
)]
#[ApiFilter(SearchFilter::class, properties: ['url' => 'exact'])]
#[ORM\Entity(repositoryClass: IssueRepository::class)]
#[Vich\Uploadable]
class Issue
{
    #[ApiProperty(identifier: true, types: ['https://schema.org/identifier'])]
    #[Groups(['read'])]
    #[ORM\Column(type: UuidType::NAME, unique: true)]
    #[ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\GeneratedValue(strategy: 'CUSTOM')]
    #[ORM\Id]
    private ?Uuid $id = null;

    #[Groups(['read', 'issue:write'])]
    #[Assert\Url(protocols: ['http', 'https'])]
    #[ORM\Column(type: Types::STRING, length: 255, nullable: true)]
    private ?string $url = null;

    #[Groups(['read', 'issue:write'])]
    #[ORM\Column(type: Types::STRING, enumType: Status::class)]
    private Status $status = Status::PENDING;

    #[Groups(['read', 'issue:write'])]
    #[Assert\NotBlank(allowNull: false)]
    #[ORM\Column(type: Types::STRING, length: 255)]
    private ?string $body = null;

    #[Groups(['read'])]
    #[ORM\Column(type: Types::DATE_IMMUTABLE)]
    private ?\DateTimeImmutable $createdAt = null;

    #[ApiProperty(types: ['https://schema.org/image'])]
    #[Groups(['read'])]
    #[ORM\OneToOne(inversedBy: 'issue', cascade: ['persist', 'remove'])]
    private ?MediaObject $image = null;

    #[Groups(['read'])]
    #[ORM\ManyToOne(inversedBy: 'issues')]
    #[ORM\JoinColumn(nullable: false)]
    private ?User $owner = null;

    #[Groups(['issue:write'])]
    #[ORM\ManyToOne(inversedBy: 'issues')]
    #[ORM\JoinColumn(nullable: false)]
    private ?Project $project = null;

    /**
     * @var Collection<int, Comment>
     */
    #[Groups(['issue:read'])]
    #[ORM\OneToMany(targetEntity: Comment::class, mappedBy: 'issue', orphanRemoval: true)]
    private Collection $comments;

    public function __construct()
    {
        $this->comments = new ArrayCollection();
    }

    public function getId(): ?Uuid
    {
        return $this->id;
    }

    public function getUrl(): ?string
    {
        return $this->url;
    }

    public function setUrl(?string $url): static
    {
        $this->url = $url;

        return $this;
    }

    public function getStatus(): ?Status
    {
        return $this->status;
    }

    public function setStatus(Status $status): static
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

    public function getProject(): ?Project
    {
        return $this->project;
    }

    public function setProject(?Project $project): static
    {
        $this->project = $project;

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
            $comment->setIssue($this);
        }

        return $this;
    }

    public function removeComment(Comment $comment): static
    {
        if ($this->comments->removeElement($comment)) {
            // set the owning side to null (unless already changed)
            if ($comment->getIssue() === $this) {
                $comment->setIssue(null);
            }
        }

        return $this;
    }

    public function __toString(): string
    {
        return sprintf('%s: %s', $this->owner->getEmail(), $this->createdAt->format('Y-m-d H:i:s'));
    }
}
