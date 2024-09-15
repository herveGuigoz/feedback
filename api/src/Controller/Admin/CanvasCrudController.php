<?php

namespace App\Controller\Admin;

use App\Entity\Canvas;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\UrlField;

class CanvasCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Canvas::class;
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('name');
        yield AssociationField::new('project');
        yield UrlField::new('url');
    }
}
