#!/usr/bin/env bash

# shell is funny

set -e

if [[ $1 != "test" && $1 != "dev" && $1 != "prod" ]]; then
    echo "please set build env [dev, test, prod]";exit 1
fi

image_name="zhcppy:5000/project-name:1.0"

echo -e "build ..."

GOOS=linux GOARCH=386 go build -o project-name .

docker rmi -f ${image_name}
echo -e "make new images by Dockerfile" $1
docker build -f Dockerfile -t ${image_name} --build-arg HX_ENV=$1 .

if [[ "$2" ]];then
    docker push ${image_name}
fi
