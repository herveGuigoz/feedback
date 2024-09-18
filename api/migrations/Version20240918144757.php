<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240918144757 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE comment (id UUID NOT NULL, author_id UUID DEFAULT NULL, issue_id UUID NOT NULL, body TEXT NOT NULL, published_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_9474526CF675F31B ON comment (author_id)');
        $this->addSql('CREATE INDEX IDX_9474526C5E7AA58C ON comment (issue_id)');
        $this->addSql('COMMENT ON COLUMN comment.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN comment.author_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN comment.issue_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN comment.published_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('CREATE TABLE issue (id UUID NOT NULL, image_id UUID DEFAULT NULL, owner_id UUID NOT NULL, project_id UUID NOT NULL, url VARCHAR(255) DEFAULT NULL, status VARCHAR(255) NOT NULL, body VARCHAR(255) NOT NULL, created_at DATE NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_12AD233E3DA5256D ON issue (image_id)');
        $this->addSql('CREATE INDEX IDX_12AD233E7E3C61F9 ON issue (owner_id)');
        $this->addSql('CREATE INDEX IDX_12AD233E166D1F9C ON issue (project_id)');
        $this->addSql('COMMENT ON COLUMN issue.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN issue.image_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN issue.owner_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN issue.project_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN issue.created_at IS \'(DC2Type:date_immutable)\'');
        $this->addSql('CREATE TABLE media_object (id UUID NOT NULL, size INT DEFAULT NULL, mime_type VARCHAR(255) DEFAULT NULL, file_path VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('COMMENT ON COLUMN media_object.id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE project (id UUID NOT NULL, owner_id UUID NOT NULL, name VARCHAR(255) NOT NULL, url VARCHAR(255) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_2FB3D0EE7E3C61F9 ON project (owner_id)');
        $this->addSql('COMMENT ON COLUMN project.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN project.owner_id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE "user" (id UUID NOT NULL, email VARCHAR(180) NOT NULL, username VARCHAR(255) NOT NULL, roles JSON NOT NULL, password VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_IDENTIFIER_EMAIL ON "user" (email)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_IDENTIFIER_USERNAME ON "user" (username)');
        $this->addSql('COMMENT ON COLUMN "user".id IS \'(DC2Type:uuid)\'');
        $this->addSql('ALTER TABLE comment ADD CONSTRAINT FK_9474526CF675F31B FOREIGN KEY (author_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE comment ADD CONSTRAINT FK_9474526C5E7AA58C FOREIGN KEY (issue_id) REFERENCES issue (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE issue ADD CONSTRAINT FK_12AD233E3DA5256D FOREIGN KEY (image_id) REFERENCES media_object (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE issue ADD CONSTRAINT FK_12AD233E7E3C61F9 FOREIGN KEY (owner_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE issue ADD CONSTRAINT FK_12AD233E166D1F9C FOREIGN KEY (project_id) REFERENCES project (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE project ADD CONSTRAINT FK_2FB3D0EE7E3C61F9 FOREIGN KEY (owner_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE comment DROP CONSTRAINT FK_9474526CF675F31B');
        $this->addSql('ALTER TABLE comment DROP CONSTRAINT FK_9474526C5E7AA58C');
        $this->addSql('ALTER TABLE issue DROP CONSTRAINT FK_12AD233E3DA5256D');
        $this->addSql('ALTER TABLE issue DROP CONSTRAINT FK_12AD233E7E3C61F9');
        $this->addSql('ALTER TABLE issue DROP CONSTRAINT FK_12AD233E166D1F9C');
        $this->addSql('ALTER TABLE project DROP CONSTRAINT FK_2FB3D0EE7E3C61F9');
        $this->addSql('DROP TABLE comment');
        $this->addSql('DROP TABLE issue');
        $this->addSql('DROP TABLE media_object');
        $this->addSql('DROP TABLE project');
        $this->addSql('DROP TABLE "user"');
    }
}
