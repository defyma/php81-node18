# Docker PHP 8.1 Node 18

- Ubuntu 22.04 / Alpine 3.17
- PHP 8.1.x
- Node 18.x
- NPM 9.x
- Yarn 3.x

## Ubuntu
``
docker run --name <name> --mount type=bind,src=<path>,dst=/var/www/html -p <port>:8080 -itd defyma/php81-node18:latest
``

## Alpine
``
docker run --name <name> --mount type=bind,src=<path>,dst=/var/www/html -p <port>:8080 -itd defyma/php81-node18:alpine
``
