<?php

namespace App\Entity;

enum FeedbackStatus: string {
    case PENDING = 'pending';
    case IN_PROGRESS = 'inProgress';
    case RESOLVED = 'resolved';
    case CLOSED = 'closed';

    public static function getValues(): array
    {
        return array_column(FeedbackStatus::cases(), 'value');
    }

    public static function toArray(): array
    {
        return array_combine(FeedbackStatus::getValues(), array_column(FeedbackStatus::cases(), 'name'));
    }
}