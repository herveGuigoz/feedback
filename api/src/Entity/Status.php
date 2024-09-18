<?php

namespace App\Entity;

enum Status: string {
    case PENDING = 'pending';
    case IN_PROGRESS = 'inProgress';
    case RESOLVED = 'resolved';
    case CLOSED = 'closed';

    public static function getValues(): array
    {
        return array_column(Status::cases(), 'value');
    }

    public static function toArray(): array
    {
        return array_combine(Status::getValues(), array_column(Status::cases(), 'name'));
    }
}