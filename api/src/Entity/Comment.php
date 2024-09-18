<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiProperty;
use ApiPlatform\Metadata\ApiResource;
use ApiPlatform\Metadata\Delete;
use ApiPlatform\Metadata\GetCollection;
use ApiPlatform\Metadata\Post;
use App\Repository\CommentRepository;
use App\State\CommentPersistProcessor;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\IdGenerator\UuidGenerator;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Serializer\Annotation\Groups;
use Symfony\Component\Serializer\Normalizer\AbstractNormalizer;
use Symfony\Component\Uid\Uuid;
use Symfony\Component\Validator\Constraints as Assert;


#[ApiResource(
    outputFormats: ['json' => ['application/json']],
    operations: [
        new GetCollection(
            security: "is_granted('ROLE_ADMIN')",
        ),
        new Post(
            security: "is_granted('ROLE_USER')",
            processor: CommentPersistProcessor::class,
        ),
        new Delete(
            security: "is_granted('ROLE_ADMIN') or object.getAuthor() == user",
        ),
    ],
    normalizationContext: [
        AbstractNormalizer::GROUPS => ['read', 'comment:read'],
    ],
    denormalizationContext: [
        AbstractNormalizer::GROUPS => ['comment:write'],
    ],
)]
#[ORM\Entity(repositoryClass: CommentRepository::class)]
class Comment
{
    #[ApiProperty(identifier: true, types: ['https://schema.org/identifier'])]
    #[Groups(groups: ['read', 'comment:read'])]
    #[ORM\Column(type: UuidType::NAME, unique: true)]
    #[ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\GeneratedValue(strategy: 'CUSTOM')]
    #[ORM\Id]
    private ?Uuid $id = null;
    
    #[Groups(groups: ['read', 'comment:read', 'comment:write'])]
    #[Assert\NotBlank(allowNull: false)]
    #[ORM\Column(type: Types::TEXT)]
    private ?string $body = null;
    
    #[Groups(groups: ['read', 'comment:read'])]
    #[ORM\ManyToOne]
    private ?User $author = null;

    #[Groups(groups: ['comment:write'])]
    #[Assert\NotNull]
    #[ORM\ManyToOne(inversedBy: 'comments')]
    #[ORM\JoinColumn(nullable: false)]
    private ?Issue $issue = null;
    
    #[Groups(groups: ['read', 'comment:read'])]
    #[ORM\Column]
    private ?\DateTimeImmutable $publishedAt = null;

    public function __construct()
    {
        $this->publishedAt = new \DateTimeImmutable();
    }

    public function getId(): ?Uuid
    {
        return $this->id;
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

    public function getAuthor(): ?User
    {
        return $this->author;
    }

    public function setAuthor(?User $author): static
    {
        $this->author = $author;

        return $this;
    }

    public function getIssue(): ?Issue
    {
        return $this->issue;
    }

    public function setIssue(?Issue $issue): static
    {
        $this->issue = $issue;

        return $this;
    }

    public function getPublishedAt(): ?\DateTimeImmutable
    {
        return $this->publishedAt;
    }

    public function setPublishedAt(\DateTimeImmutable $publishedAt): static
    {
        $this->publishedAt = $publishedAt;

        return $this;
    }
}
