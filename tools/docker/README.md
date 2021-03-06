# Docker

### About Docker CE

Docker Community Edition (CE) -- Docker 社区版

Docker Engine -- Docker 引擎

Docker Client -- Docker 客户端

### Docker Machine

Docker Machine是一个Docker工具，可让在虚拟主机上安装Docker Engine，并使用docker-machine命令管理主机

* 在Mac或Windows上安装并运行Docker
* 配置和管理多个远程Docker主机
* 提供Swarm集群

[更多 Machine](/tools/docker/machine/README.md)

### Docker 与 VM 区别

其实他们都有各自特定的目的，并没有太多相似的地方，并且一个并不会淘汰掉另一个。

一个容器指的是一个轻量级的程序运行环境，在容器中运行的若干个应用，它们都与外界隔离，并且这个环境的性能与裸机相当。

但如果需要运行一整个操作系统或生态系统，又或者需要运行与底层环境不兼容的应用程序，那么就需要使用虚拟机。

虚拟机：通过获取主机实际的硬件资源后，再重新构建一个接近于真实的机器，拥有自己独立的操作系统，程序运行于该系统之上，与宿主机完全隔离。

Docker容器：利用Linux主机的内核技术，容器运行时，实际上是对应主机上的一批相互对立的进程（Bins/Libs），程序的执行者还是宿主机，共享内核。

Bins/Libs：一些工具和用户空间的库，容器是在主机管理的一组通过namespace、cgroup、overlay file、system技术隔离的进程中。

DockerFile相当与一道菜的菜谱

### 为什么要用 Docker

解决环境问题，方便运维管理，方便开发测试

## Docker 安装（Linux）

```bash
wget -cqO- https://raw.githubusercontent.com/zhcppy/zhcppy.github.io/master/docker/install_docker.sh | bash
```

**docker安装脚本：**

[install_docker](install_docker.sh ':include :type=code bash')

## Docker Compose

[mysql-docker-compose.yml](compose/mysql-docker-compose.yml ':include :type=code yaml')

[daemon_tls.md](daemon_tls.md ':include')

## Docker Command Help

* 移除所有无用镜像

```bash
docker rmi -f $(docker images | awk '$1 == "<none>" {print $3}')
docker rm -f `docker imaages -a | grep "<none>" | awk '{print $3}'`
```

* 移除所有容器

```bash
docker rm -f `docker ps -a | awk '{print $1}'`
docker rm $(docker ps -a | awk '{if($0~"Exited")print $1}')
```

* ubuntu下添加不安全仓库

```bash
echo "192.168.20.78 zhcppy" | sudo tee -a /etc/hosts

echo '{"insecure-registries":["zhcppy:5000"]}' | sudo tee -a /etc/docker/daemon.json
```

* ubuntu下重启docker

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

* docker容器中安装ping工具

```bash
apt update
apt install -y iputils-ping
```

* docker容器时区修改

```bash
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
```

* Manage Docker as a non-root user

```bash
sudo groupadd docker
sudo usermod -aG docker ${USER}
```

```bash
docker inspect -f '{{.State.Pid}} {{.Id}}' $(docker ps -a -q)
```

* docker查看磁盘占用
```bash
docker system df --verbose
```

* docker config

[run.sh](run.sh ':include :type=code bash')
