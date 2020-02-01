# Kubernetes(k8s)

Kubernetes是一个开源容器编排引擎，用于自动化容器化应用程序的部署，扩展和管理

Kubernetes 提供以容器为中心的管理环境。
它代表用户工作负载协调计算，网络和存储基础架构。
这提供了平台即服务（PaaS）的大部分简单性，具有基础架构即服务（IaaS）的灵活性，并支持跨基础架构提供商的可移植性。

* 一个容器平台
* 一个微服务平台
* 便携式云平台等等

kubeadm 引导群集的命令，就是用于部署集群的工具 https://github.com/kubernetes/kubeadm
kubelet 在群集中的所有计算机上运行的组件，并执行诸如启动pod和容器之类的操作,是在每个节点上运行的主要“节点代理”, 它确保容器在pod中运行
kubectl 用于与群集通信的命令行util,命令行工具，部署成功后，主要用到是这个

### 部署

* microk8s

[microk8s](https://microk8s.io)用于快速安装k8s

```bash
sudo snap install microk8s --classic
```

* 部署需要用到的docker镜像

如果部署机器无法翻墙，在启动集群之前，先拉取镜像：  
```bash
docker pull k8s.gcr.io/kube-proxy:v1.14.2
docker pull k8s.gcr.io/kube-apiserver:v1.14.2
docker pull k8s.gcr.io/kube-controller-manager:v1.14.2
docker pull k8s.gcr.io/kube-scheduler:v1.14.2
docker pull k8s.gcr.io/coredns:1.3.1
docker pull k8s.gcr.io/etcd:3.3.10
docker pull k8s.gcr.io/pause:3.1
docker pull k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1
docker pull quay.io/coreos/flannel:v0.10.0-amd64
```

* 部署脚本
    * get
    ```bash
    wget -c -o k8s_deploy.sh https://raw.githubusercontent.com/zhcppy/zhcppy.github.io/master/tools/k8s/deploy.sh
    ```
    * show
    
[deploy](deploy.sh ':include :type=code bash')

* 使用帮助

```bash
# 在ROOT用户下使kubectl命令可用:
export KUBECONFIG=/etc/kubernetes/admin.conf
# 在非root用户下使kubectl命令可用:
mkdir -p $HOME/.kube; sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;sudo chown $(id -u):$(id -g) $HOME/.kube/config
# 检查一下
kubectl cluster-info
echo 'source <(kubectl completion bash)' >>~/.bashrc
# 设置单机集群
kubectl taint nodes --all node-role.kubernetes.io/master-
# 查看集群上的所有节点
kubectl get nodes
# 查看集群上所有的pod
kubectl get pod --all-namespaces || kubectl get pod -A
# 查看集群上所有的服务
kubectl get svc --all-namespaces
# 查看pod日志
kubectl describe po -n kube-system <pod-name>
kubectl logs -n kube-system <pod-name>
# 删除pod
kubectl -n kube-system delete $(kubectl -n kube-system get pod -o name | grep dashboard)
# 移除节点
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
# 拆除集群
kubeadm reset
```