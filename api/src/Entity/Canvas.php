<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiProperty;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Link;
use ApiPlatform\Metadata\NotExposed;
use App\Repository\CanvasRepository;
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

#[ApiResource(
    security: "is_granted('ROLE_USER')",
    outputFormats: ['json' => ['application/json']],
    operations: [
        new GetCollection(
            uriTemplate: '/projects/{projectId}/canvases',
            uriVariables: [
                'projectId' => new Link(toProperty: 'project', fromClass: Project::class),
            ],
            normalizationContext: [
                AbstractNormalizer::GROUPS => ['read'],
            ],
            paginationClientItemsPerPage: true,
        ),
        new Get(
            uriTemplate: '/projects/{projectId}/canvases/{id}',
            uriVariables: [
                'projectId' => new Link(toProperty: 'project', fromClass: Project::class),
                'id' => new Link(fromClass: Canvas::class),
            ],
            normalizationContext: [
                AbstractNormalizer::GROUPS => ['read', 'canvas:read'],
            ],
        ),
        new NotExposed(
            uriTemplate: '/canvases/{id}',
        )
    ],
)]
#[ORM\Entity(repositoryClass: CanvasRepository::class)]
#[ORM\UniqueConstraint(fields: ['name', 'project'])]
class Canvas
{
    #[ApiProperty(identifier: true, types: ['https://schema.org/identifier'])]
    #[Groups(['read'])]
    #[ORM\Column(type: UuidType::NAME, unique: true)]
    #[ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\GeneratedValue(strategy: 'CUSTOM')]
    #[ORM\Id]
    private ?Uuid $id = null;

    #[Groups(['read'])]
    #[Assert\NotBlank(allowNull: false)]
    #[ORM\Column(type: Types::STRING, length: 255)]
    private ?string $name = null;

    #[Groups(['read'])]
    #[Assert\Url(protocols: ['http', 'https'])]
    #[ORM\Column(type: Types::STRING, length: 255, nullable: true)]
    private ?string $url = null;

    #[ORM\ManyToOne(inversedBy: 'canvases')]
    #[ORM\JoinColumn(nullable: false)]
    private ?Project $project = null;

    /**
     * @var Collection<int, Feedback>
     */
    #[Groups(['canvas:read'])]
    #[ORM\OneToMany(targetEntity: Feedback::class, mappedBy: 'canvas', orphanRemoval: true)]
    private Collection $feedbacks;

    public function __construct()
    {
        $this->feedbacks = new ArrayCollection();
    }

    public function getId(): ?Uuid
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): static
    {
        $this->name = $name;

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
     * @return Collection<int, Feedback>
     */
    public function getFeedbacks(): Collection
    {
        return $this->feedbacks;
    }

    public function addFeedback(Feedback $feedback): static
    {
        if (!$this->feedbacks->contains($feedback)) {
            $this->feedbacks->add($feedback);
            $feedback->setCanvas($this);
        }

        return $this;
    }

    public function removeFeedback(Feedback $feedback): static
    {
        if ($this->feedbacks->removeElement($feedback)) {
            // set the owning side to null (unless already changed)
            if ($feedback->getCanvas() === $this) {
                $feedback->setCanvas(null);
            }
        }

        return $this;
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
}
