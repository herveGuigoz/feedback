<?php

namespace App\Entity;

enum ReviewStatus: string {
    case APPROUVED = 'approved';
    case REQUEST_CHANGES = 'request_changes';

    public static function toArray(): array
    {
        return [
            'Approved' => self::APPROUVED,
            'Request Changes' => self::REQUEST_CHANGES,
        ];
    }
}