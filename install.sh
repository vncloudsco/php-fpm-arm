#!/bin/bash

option="${1}"

case ${option} in
-v)
    if [[ ${2} != @(7.3|7.4|8.0|) ]]; then
        echo "only input 7.3 7.4 8.0"
        exit 1 # Command to come out of the program with status 1
    fi
    php_version="${2}"
    ;;
*)
    echo "input -v to version php"
    exit 1 # Command to come out of the program with status 1
    ;;
esac

function php_docker_name_random() {
    while :; do
        db_creat=$(openssl rand -hex 8)
        db=$(find ./ -type f -name "*.yaml" -exec grep '$db_creat' {} \;)
        if [ -z "$db" ]; then
            break
        fi
    done

}

function creat_php_fpm_docker_file() {

    cat >docker-compser-$db_creat.yaml <<EOF
version: '2'

services:
  $db_creat:
    tty: true # Enables debugging capabilities when attached to this container.
    image: docker.io/bitnami/php-fpm:$php_version
    ports:
      - 9000:9000
    volumes:
      - ./$php_version/$db_creat:/app
    restart: always
EOF

}
function start_docker()
{
    docker_compose -f docker-compser-$db_creat.yaml up -d
}

php_docker_name_random
creat_php_fpm_docker_file
start_docker
