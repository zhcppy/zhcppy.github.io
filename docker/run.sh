#!/usr/bin/env bash

# shell is funny

set -e

root=$(pwd)

function init_deploy_env() {
    echo "设置本地 docker registry"
    # shellcheck disable=SC2006
    if [[ ! -f `which docker` ]]; then
        echo "please install docker or start docker"
        exit
    fi

    IPAddr=""
    Domain=""
    NetworkName="zhcppy_bridge"
    read -p "Please input docker registry IP: " IPAddr
    read -p "Please input docker registry Domain: " Domain
    if [[ IPAddr == "" || Domain == "" ]]; then
        echo "please set docker registry IP address and Domain";exit 1;
    fi

    if [[ `uname` == "Linux" || `cat /etc/hosts | grep ${Domain}` ]];then
        return
    fi
    echo "please input computer password"
    echo "$IPAddr $Domain" | sudo tee -a /etc/hosts

    if [[ `uname` == "Linux" || `cat ~/.docker/daemon.json | grep ${Domain}` ]]; then
        return
    fi
    cat << EOF > ~/.docker/daemon.json
{
  "insecure-registries" : [
    "${Domain}:5000"
  ],
  "debug" : true,
  "experimental" : false
}
EOF
    if [[ ! -f `which docker` ]]; then
        echo "please install docker or start docker"; exit 1
    fi
    osascript -e 'quit app "Docker"'
    open -a Docker

    sleep 30

    if [[ ! `docker network ls | grep ${NetworkName}` ]]; then
        docker network create --driver bridge ${NetworkName}
        # docker network inspect ${NetworkName}
    fi

    docker network ls

    echo "init done . . ."
}

function run_help() {
    echo -e "\n`basename ${0}`:Usage: [OPTIONS]\n"
    echo -e "Options:"
    echo -e "\t-i, --init \t\t Init docker deploy env"
    echo -e "\t-r, --registry \t\t Deploy docker registry and container manage"
    echo -e "\t-d, --deploy fileDir \t Deploy docker Application \n"
    exit 1
}

function check_app() {
    if [[ ${1} == "" || ! -d ${1} ]]; then
        echo -e "\nApplication '${1}' is not exist!";
        echo -e "Please add project .yml file, ./run.sh -d mysql";
        run_help
    fi
}

case ${1} in
    -i|--init)
        init_deploy_env;exit;;
    -r|--registry)
        cd ${root}/registry/ && docker-compose up -d && echo
        cd ${root}/registry_manage/ && docker-compose up -d && echo
        cd ${root}/portainer/ && docker-compose up -d
        echo && docker ps -a && echo;exit;;
    -d|--deploy) DIR=${root}/${2}
        check_app ${2};
        cd ${DIR} && docker-compose pull && docker-compose up -d
        echo && docker ps -a && echo;exit;;
    *)
        run_help;;
esac
