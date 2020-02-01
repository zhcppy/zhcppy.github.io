&emsp;[:back: 返回上一级](/tools/docker/README.md?id=docker-machine)

# Docker Machine

https://docs.docker.com/machine/get-started

Docker Machine是一个Docker工具，实际上它就是创建虚拟机并在虚拟机中安装docker，然后可以通过该工具管理该docker

[run](run.sh ':include :type=code bash')

* 使用帮助

```bash

docker-machine ls

docker-machine create --driver virtualbox default

docker-machine ls

docker-machine env default

eval "$(docker-machine env default)"

docker-machine ip default

sudo docker run -d -p 8000:80 nginx

curl $(docker-machine ip default):8000

docker-machine stop default

docker-machine start default

env | grep DOCKER

eval $(docker-machine env -u)

env | grep DOCKER
```
