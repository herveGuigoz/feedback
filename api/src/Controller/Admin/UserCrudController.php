<?php

namespace App\Controller\Admin;

use App\Entity\User;
use Doctrine\ORM\QueryBuilder;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FieldCollection;
use EasyCorp\Bundle\EasyAdminBundle\Collection\FilterCollection;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Dto\EntityDto;
use EasyCorp\Bundle\EasyAdminBundle\Dto\SearchDto;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\EmailField;

class UserCrudController extends AbstractCrudController
{
    /**
     * @var array<string, string>
     */
    private array $roles;

    public function __construct()
    {
        $this->roles = [
            'User' => 'ROLE_USER',
            'Admin' => 'ROLE_ADMIN',
        ];
    }

    public static function getEntityFqcn(): string
    {
        return User::class;
    }

    public function createIndexQueryBuilder(SearchDto $searchDto, EntityDto $entityDto, FieldCollection $fields, FilterCollection $filters): QueryBuilder
    {
        /** @var User $user */
        $user = $this->getUser();

        $query = parent::createIndexQueryBuilder($searchDto, $entityDto, $fields, $filters);

        if ($this->isGranted('ROLE_ADMIN')) {
            return $query;
        }

        return $query->andWhere('entity.id != :id')->setParameter('id', $user->getId());
    }

    public function configureCrud(Crud $crud): Crud
    {
        return parent::configureCrud($crud)
            ->setEntityLabelInSingular('User')
            ->setEntityLabelInPlural('Users')
            ->setEntityPermission('ROLE_ADMIN')
            ->setSearchFields(['email', 'roles'])
            ->setDefaultSort(['email' => 'ASC']);
    }

    public function configureFilters(Filters $filters): Filters
    {
        return parent::configureFilters($filters)
            ->add('email');
    }

    public function configureFields(string $pageName): iterable
    {
        yield EmailField::new('email', 'email')
            ->setRequired(true)
            ->setColumns(7)
        ;
        yield ChoiceField::new('roles', 'roles')
            ->allowMultipleChoices()
            ->setChoices($this->roles)
            ->renderExpanded()
            ->renderAsBadges()
        ;
    }
}
