<?php

namespace App\Controller\Admin;

use App\Entity\Issue;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;

class IssueCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Issue::class;
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            AssociationField::new('project')->hideOnForm(),
            AssociationField::new('owner')->hideOnForm(),
            // ChoiceField::new('status')->setChoices(FeedbackStatus::toArray()),
            TextEditorField::new('body'),
            DateField::new('createdAt')->hideOnForm(),
        ];
    }
}
