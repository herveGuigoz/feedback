# Symfony Docker

A [Docker](https://www.docker.com/)-based installer and runtime for the [Symfony](https://symfony.com) web framework,
with [FrankenPHP](https://frankenphp.dev) and [Caddy](https://caddyserver.com/) inside!

## Getting Started

1. If not already done, [install Docker Compose](https://docs.docker.com/compose/install/) (v2.10+)
2. Run `docker compose build --no-cache` to build fresh images
3. Run `docker compose up --pull always -d --wait` to set up and start a fresh Symfony project
4. Open `https://localhost` in your favorite web browser and [accept the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334)
5. Run `docker compose down --remove-orphans` to stop the Docker containers.

## Docker Build Options

You can customize the docker build process using these environment variables.

### Using custom HTTP ports

Use the environment variables `HTTP_PORT`, `HTTPS_PORT` and/or `HTTP3_PORT` to adjust the ports to your needs, e.g.

    HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443 docker compose up -d --wait

to access your application on [https://localhost:4443](https://localhost:4443).
 
> Let's Encrypt only supports the standard HTTP and HTTPS ports. Creating a Let's Encrypt certificate for another port will not work, you have to use the standard ports or to configure Caddy to use another provider.


### Caddyfile Options

You can also customize the `Caddyfile` by using the following environment variables to inject options block, directive or configuration.

> All the following environment variables can be defined in your `.env` file at the root of the project to keep them persistent at each startup

| Environment variable            | Description                                                                                                                                                                             | Default value             |
|---------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|
| `CADDY_GLOBAL_OPTIONS`          | the [global options block](https://caddyserver.com/docs/caddyfile/options#global-options), one per line                                                                                 |                           |
| `CADDY_EXTRA_CONFIG`            | the [snippet](https://caddyserver.com/docs/caddyfile/concepts#snippets) or the [named-routes](https://caddyserver.com/docs/caddyfile/concepts#named-routes) options block, one per line |                           |
| `CADDY_SERVER_EXTRA_DIRECTIVES` | the [`Caddyfile` directives](https://caddyserver.com/docs/caddyfile/concepts#directives)                                                                                                |                           |
| `SERVER_NAME`                   | the server name or address                                                                                                                                                              | `localhost`               |
| `FRANKENPHP_CONFIG`             | a list of extra [FrankenPHP directives](https://frankenphp.dev/docs/config/#caddyfile-config), one per line                                                                             | `import worker.Caddyfile` | 
| `MERCURE_TRANSPORT_URL`         | the value passed to the `transport_url` directive                                                                                                                                       | `bolt://mercure.db`       |
| `MERCURE_PUBLISHER_JWT_KEY`     | the JWT key to use for publishers                                                                                                                                                       |                           |
| `MERCURE_PUBLISHER_JWT_ALG`     | the JWT algorithm to use for publishers                                                                                                                                                 | `HS256`                   |
| `MERCURE_SUBSCRIBER_JWT_KEY`    | the JWT key to use for subscribers                                                                                                                                                      |                           |
| `MERCURE_SUBSCRIBER_JWT_ALG`    | the JWT algorithm to use for subscribers                                                                                                                                                | `HS256`                   |
| `MERCURE_EXTRA_DIRECTIVES`      | a list of extra [Mercure directives](https://mercure.rocks/docs/hub/config), one per line                                                                                               |                           |

#### Example of server name customize:

    SERVER_NAME="app.localhost" docker compose up -d --wait

## Credits

Created by [Kévin Dunglas](https://dunglas.dev), co-maintained by [Maxime Helias](https://twitter.com/maxhelias) and sponsored by [Les-Tilleuls.coop](https://les-tilleuls.coop).
