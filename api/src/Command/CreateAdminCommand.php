<?php

namespace App\Command;

use App\Service\CreateAdminService;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:create-admin',
    description: 'Create a new admin user',
)]
class CreateAdminCommand extends Command
{
    public function __construct(
        private readonly CreateAdminService $createAdminService,
    ) {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $email = $io->ask('email', null, function ($email) {
            if (false === filter_var($email, FILTER_VALIDATE_EMAIL)) {
                throw new \RuntimeException('The email is invalid');
            }

            return $email;
        });

        $username = $io->ask('username', null, function ($username) {
            if (null === $username) {
                throw new \RuntimeException('The username is invalid');
            }

            return $username;
        });

        $password = $io->askHidden('password', function ($password) {
            if (null === $password) {
                throw new \RuntimeException('The password is invalid');
            }

            return $password;
        });

        $this->createAdminService->create($email, $username, $password);

        $io->success('Successfully created admin user.');

        return Command::SUCCESS;
    }
}
