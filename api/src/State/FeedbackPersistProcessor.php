<?php

namespace App\State;

use ApiPlatform\Doctrine\Common\State\PersistProcessor;
use ApiPlatform\Metadata\Operation;
use ApiPlatform\Metadata\Post;
use ApiPlatform\State\ProcessorInterface;
use App\Entity\FeedbackStatus;
use App\Entity\MediaObject;
use App\Repository\CanvasRepository;
use App\Repository\MediaObjectRepository;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\Request;
use Vich\UploaderBundle\Storage\StorageInterface;

class FeedbackPersistProcessor implements ProcessorInterface
{
    public function __construct(
        #[Autowire(service: PersistProcessor::class)]
        private ProcessorInterface $persistProcessor,
        private Security $security,
        private readonly StorageInterface $storage,
        private readonly CanvasRepository $canvasRepository,
        private readonly MediaObjectRepository $mediaObjectRepository,
        // #[Autowire(service: 'api_platform.doctrine.orm.state.persist_processor')]
        // private ProcessorInterface $persistProcessor,
    ) {}
    
    public function process(mixed $data, Operation $operation, array $uriVariables = [], array $context = []): mixed
    {
        if ($operation instanceof Post) {
            $request = $context['request'];
            $data->setOwner($this->security->getUser());
            $data->setImage($this->handleFileUpload($request));
            $data->setStatus(FeedbackStatus::PENDING);
            $data->setCreatedAt(new \DateTimeImmutable());
        }

        return $this->persistProcessor->process($data, $operation, $uriVariables, $context);
    }

    private function handleFileUpload(Request $request): ?MediaObject
    {
        $file = $request->files->get('file');
        if (!$file instanceof UploadedFile) {
            return null;
        }
        $mediaObject = new MediaObject();
        $mediaObject->file = $file;

        return $mediaObject;
    }
}
