<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiProperty;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Get;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Post;
use App\Repository\ProjectRepository;
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
            security: "is_granted('ROLE_ADMIN')",
            normalizationContext: [
                AbstractNormalizer::GROUPS => ['read'],
            ],
        ),
        new Get(
            security: "is_granted('ROLE_ADMIN') or object.getOwner() == user",
            normalizationContext: [
                AbstractNormalizer::GROUPS => ['read', 'project:read'],
            ],
        ),
        new Post(
            security: "is_granted('ROLE_ADMIN')",
            denormalizationContext: [
                AbstractNormalizer::GROUPS => ['project:write'],
            ],
        ),
    ],
)]
#[ORM\Entity(repositoryClass: ProjectRepository::class)]
class Project
{
    #[ApiProperty(identifier: true, types: ['https://schema.org/identifier'])]
    #[Groups(['read'])]
    #[ORM\Column(type: UuidType::NAME, unique: true)]
    #[ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\GeneratedValue(strategy: 'CUSTOM')]
    #[ORM\Id]
    private ?Uuid $id = null;

    #[Groups(['read', 'project:write'])]
    #[Assert\NotBlank(allowNull: false)]
    #[ORM\Column(type: Types::STRING, length: 255)]
    private ?string $name = null;

    #[Groups(['read', 'project:write'])]
    #[Assert\Url(protocols: ['http', 'https'])]
    #[ORM\Column(type: Types::STRING, length: 255)]
    private ?string $url = null;

    #[Groups(['project:write'])]
    #[ORM\ManyToOne(inversedBy: 'projects')]
    #[ORM\JoinColumn(nullable: false)]
    private ?User $owner = null;

    /**
     * @var Collection<int, Issue>
     */
    #[ORM\OneToMany(targetEntity: Issue::class, mappedBy: 'project', orphanRemoval: true)]
    private Collection $issues;

    public function __construct()
    {
        $this->issues = new ArrayCollection();
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

    public function getUrl(): ?string
    {
        return $this->url;
    }

    public function setUrl(string $url): static
    {
        $this->url = $url;

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

    /**
     * @return Collection<int, Issue>
     */
    public function getIssues(): Collection
    {
        return $this->issues;
    }

    public function addIssue(Issue $issue): static
    {
        if (!$this->issues->contains($issue)) {
            $this->issues->add($issue);
            $issue->setProject($this);
        }

        return $this;
    }

    public function removeIssue(Issue $issue): static
    {
        if ($this->issues->removeElement($issue)) {
            // set the owning side to null (unless already changed)
            if ($issue->getProject() === $this) {
                $issue->setProject(null);
            }
        }

        return $this;
    }

    public function __toString(): string
    {
        return $this->name;
    }
}
