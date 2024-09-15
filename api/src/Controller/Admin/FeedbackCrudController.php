<?php

namespace App\Controller\Admin;

use App\Entity\Feedback;
use App\Entity\FeedbackStatus;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;

class FeedbackCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Feedback::class;
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            AssociationField::new('canvas')->hideOnForm(),
            AssociationField::new('owner')->hideOnForm(),
            // ChoiceField::new('status')->setChoices(FeedbackStatus::toArray()),
            TextEditorField::new('body'),
            DateField::new('createdAt')->hideOnForm(),
        ];
    }
}
