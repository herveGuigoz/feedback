<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240917231954 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE canvas (id UUID NOT NULL, project_id UUID NOT NULL, name VARCHAR(255) NOT NULL, url VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_A59F6C18166D1F9C ON canvas (project_id)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_A59F6C185E237E06166D1F9C ON canvas (name, project_id)');
        $this->addSql('COMMENT ON COLUMN canvas.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN canvas.project_id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE comment (id UUID NOT NULL, author_id UUID DEFAULT NULL, feedback_id UUID NOT NULL, body TEXT NOT NULL, published_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_9474526CF675F31B ON comment (author_id)');
        $this->addSql('CREATE INDEX IDX_9474526CD249A887 ON comment (feedback_id)');
        $this->addSql('COMMENT ON COLUMN comment.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN comment.author_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN comment.feedback_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN comment.published_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('CREATE TABLE feedback (id UUID NOT NULL, image_id UUID DEFAULT NULL, owner_id UUID NOT NULL, canvas_id UUID NOT NULL, status VARCHAR(255) NOT NULL, body VARCHAR(255) NOT NULL, created_at DATE NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_D22944583DA5256D ON feedback (image_id)');
        $this->addSql('CREATE INDEX IDX_D22944587E3C61F9 ON feedback (owner_id)');
        $this->addSql('CREATE INDEX IDX_D2294458DD8C9D23 ON feedback (canvas_id)');
        $this->addSql('COMMENT ON COLUMN feedback.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN feedback.image_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN feedback.owner_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN feedback.canvas_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN feedback.created_at IS \'(DC2Type:date_immutable)\'');
        $this->addSql('CREATE TABLE media_object (id UUID NOT NULL, size INT DEFAULT NULL, mime_type VARCHAR(255) DEFAULT NULL, file_path VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('COMMENT ON COLUMN media_object.id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE project (id UUID NOT NULL, owner_id UUID NOT NULL, name VARCHAR(255) NOT NULL, url VARCHAR(255) NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_2FB3D0EE7E3C61F9 ON project (owner_id)');
        $this->addSql('COMMENT ON COLUMN project.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN project.owner_id IS \'(DC2Type:uuid)\'');
        $this->addSql('CREATE TABLE review (id UUID NOT NULL, author_id UUID NOT NULL, url VARCHAR(255) NOT NULL, status VARCHAR(255) NOT NULL, body TEXT NOT NULL, published_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE INDEX IDX_794381C6F675F31B ON review (author_id)');
        $this->addSql('COMMENT ON COLUMN review.id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN review.author_id IS \'(DC2Type:uuid)\'');
        $this->addSql('COMMENT ON COLUMN review.published_at IS \'(DC2Type:datetime_immutable)\'');
        $this->addSql('CREATE TABLE "user" (id UUID NOT NULL, email VARCHAR(180) NOT NULL, roles JSON NOT NULL, password VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id))');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_IDENTIFIER_EMAIL ON "user" (email)');
        $this->addSql('COMMENT ON COLUMN "user".id IS \'(DC2Type:uuid)\'');
        $this->addSql('ALTER TABLE canvas ADD CONSTRAINT FK_A59F6C18166D1F9C FOREIGN KEY (project_id) REFERENCES project (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE comment ADD CONSTRAINT FK_9474526CF675F31B FOREIGN KEY (author_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE comment ADD CONSTRAINT FK_9474526CD249A887 FOREIGN KEY (feedback_id) REFERENCES feedback (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE feedback ADD CONSTRAINT FK_D22944583DA5256D FOREIGN KEY (image_id) REFERENCES media_object (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE feedback ADD CONSTRAINT FK_D22944587E3C61F9 FOREIGN KEY (owner_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE feedback ADD CONSTRAINT FK_D2294458DD8C9D23 FOREIGN KEY (canvas_id) REFERENCES canvas (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE project ADD CONSTRAINT FK_2FB3D0EE7E3C61F9 FOREIGN KEY (owner_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('ALTER TABLE review ADD CONSTRAINT FK_794381C6F675F31B FOREIGN KEY (author_id) REFERENCES "user" (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE canvas DROP CONSTRAINT FK_A59F6C18166D1F9C');
        $this->addSql('ALTER TABLE comment DROP CONSTRAINT FK_9474526CF675F31B');
        $this->addSql('ALTER TABLE comment DROP CONSTRAINT FK_9474526CD249A887');
        $this->addSql('ALTER TABLE feedback DROP CONSTRAINT FK_D22944583DA5256D');
        $this->addSql('ALTER TABLE feedback DROP CONSTRAINT FK_D22944587E3C61F9');
        $this->addSql('ALTER TABLE feedback DROP CONSTRAINT FK_D2294458DD8C9D23');
        $this->addSql('ALTER TABLE project DROP CONSTRAINT FK_2FB3D0EE7E3C61F9');
        $this->addSql('ALTER TABLE review DROP CONSTRAINT FK_794381C6F675F31B');
        $this->addSql('DROP TABLE canvas');
        $this->addSql('DROP TABLE comment');
        $this->addSql('DROP TABLE feedback');
        $this->addSql('DROP TABLE media_object');
        $this->addSql('DROP TABLE project');
        $this->addSql('DROP TABLE review');
        $this->addSql('DROP TABLE "user"');
    }
}
