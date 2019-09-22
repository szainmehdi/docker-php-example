# Example Project: Docker for PHP, MySQL, and nginx

This codebase serves as an example of a PHP, MySQL, nginx project using Docker.

## Getting Started

#### Configure nginx

Edit `nginx/default.conf` and replace `example.test` with your domain name. 
Then, generate an SSL certificate for the domain:

```shell script
cd nginx
# Replace "example.test" with your domain name.
./setup.sh example.test
``` 

#### Up, Up, and Away

```shell script
docker-compose up -d
```
