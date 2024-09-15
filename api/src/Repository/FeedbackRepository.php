<?php

namespace App\Repository;

use App\Entity\Feedback;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Feedback>
 */
class FeedbackRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Feedback::class);
    }

    public function findByProjectId(int $projectId): array
    {
        return $this->createQueryBuilder('f')
            ->andWhere('f.project = :projectId')
            ->setParameter('projectId', $projectId)
            ->getQuery()
            ->getResult()
        ;
    }

    public function findByProjectIdAndPath(int $projectId, string $path): array
    {
        return $this->createQueryBuilder('f')
            ->andWhere('f.project = :projectId')
            ->andWhere('f.path = :path')
            ->setParameter('projectId', $projectId)
            ->setParameter('path', $path)
            ->getQuery()
            ->getResult()
        ;
    }

    //    /**
    //     * @return Feedback[] Returns an array of Feedback objects
    //     */
    //    public function findByExampleField($value): array
    //    {
    //        return $this->createQueryBuilder('f')
    //            ->andWhere('f.exampleField = :val')
    //            ->setParameter('val', $value)
    //            ->orderBy('f.id', 'ASC')
    //            ->setMaxResults(10)
    //            ->getQuery()
    //            ->getResult()
    //        ;
    //    }

    //    public function findOneBySomeField($value): ?Feedback
    //    {
    //        return $this->createQueryBuilder('f')
    //            ->andWhere('f.exampleField = :val')
    //            ->setParameter('val', $value)
    //            ->getQuery()
    //            ->getOneOrNullResult()
    //        ;
    //    }
}
