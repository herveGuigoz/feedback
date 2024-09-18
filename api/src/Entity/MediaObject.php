<?php

namespace App\Entity;

use ApiPlatform\Metadata\ApiProperty;
use App\Repository\MediaObjectRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\IdGenerator\UuidGenerator;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\HttpFoundation\File\File;
use Symfony\Component\Serializer\Annotation\Groups;
use Symfony\Component\Uid\Uuid;
use Symfony\Component\Validator\Constraints as Assert;
use Vich\UploaderBundle\Mapping\Annotation as Vich;

#[Vich\Uploadable]
#[ORM\Entity(repositoryClass: MediaObjectRepository::class)]
class MediaObject
{
    #[ORM\Column(type: UuidType::NAME, unique: true)]
    #[ORM\CustomIdGenerator(class: UuidGenerator::class)]
    #[ORM\GeneratedValue(strategy: 'CUSTOM')]
    #[ORM\Id]
    private ?Uuid $id = null;

    /**
     * The Uploaded file associated with this media object
     */
    #[Vich\UploadableField(
        mapping: 'media_object',
        fileNameProperty: 'filePath',
        size: 'size',
        mimeType: 'mimeType'
    )]
    #[Assert\File(
        maxSize: '10M',
        extensions: ['svg', 'png', 'jpeg', 'jpg'],
        extensionsMessage: 'Please upload a valid File'
    )]
    public ?File $file = null;

    /**
     * The size in bytes of the uploaded file
     */
    #[ORM\Column(nullable: true)]
    private ?int $size = null;

    /**
     * The mime type of the uploaded file
     */
    #[ORM\Column(type: Types::STRING, nullable: true)]
    private ?string $mimeType = null;

    /**
     * The name saved in the database to identify the file
     */
    #[ApiProperty(writable: false)]
    #[ORM\Column(type: Types::STRING, nullable: true)] 
    public ?string $filePath = null;

    /**
     * The URL to access the file hydrated by the MediaObjectNormalizer
     */
    #[ApiProperty(types: ['https://schema.org/contentUrl'], writable: false)]
    #[Groups(['read'])]
    public ?string $contentUrl = null;

    #[ORM\OneToOne(mappedBy: 'image', cascade: ['persist', 'remove'])]
    private ?Issue $issue = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getSize(): ?int
    {
        return $this->size;
    }

    public function setSize(?int $size): void
    {
        $this->size = $size;
    }

    public function getMimeType(): ?string
    {
        return $this->mimeType;
    }

    public function setMimeType(?string $mimeType): void
    {
        $this->mimeType = $mimeType;
    }

    public function getFilePath(): ?string
    {
        return $this->filePath;
    }

    public function setFilePath(string $filePath): static
    {
        $this->filePath = $filePath;

        return $this;
    }

    public function getIssue(): ?Issue
    {
        return $this->issue;
    }

    public function setIssue(?Issue $issue): static
    {
        // unset the owning side of the relation if necessary
        if ($issue === null && $this->issue !== null) {
            $this->issue->setImage(null);
        }

        // set the owning side of the relation if necessary
        if ($issue !== null && $issue->getImage() !== $this) {
            $issue->setImage($this);
        }

        $this->issue = $issue;

        return $this;
    }
}
