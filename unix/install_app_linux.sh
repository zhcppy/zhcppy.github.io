#!/bin/bash

# shell is funny

# Linux上安装应用

set -euo pipefail
trap "echo 'error: Script failed: see failed command above'" ERR

if [[ `uname` == "Linux" ]];then
    echo "This script only runs in a Linux.";exit 1
fi

echo "=================== install start >>> `uname` ======================="

# install docker
../docker/install_docker.sh

# install snap
# 什么是snap，snap安装包是Canonical公司发布的全新的软件包管理方式，它类似一个容器拥有一个应用程序所有的文件和库，各个应用程序之间完全独立。
# 所以使用snap包的好处就是它解决了应用程序之间的依赖问题，使应用程序之间更容易管理。但是由此带来的问题就是它占用更多的磁盘空间。
# snap应用可以安装同样一个软件的不同版本而不造成任何的干扰，理论上一个snap应用可以安装到任何一个Linux的发行版上，因为它不依赖于操作系统及其发布版本。

sudo apt-get update

index=0
app_array=(git vim wget curl node python3)

while (($index < ${#app_array[*]})); do

    if [[ ! -d $(which ${app_array[$index]}) ]]; then
        sudo apt-get -y install ${app_array[index]}
    else
        echo
        echo $(${app_array[$index]} --version)
    fi
    let index++
done

echo "=================== install end ======================="
