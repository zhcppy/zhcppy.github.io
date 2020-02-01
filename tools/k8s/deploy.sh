#!/usr/bin/env bash

# shell is funny

# 在局域网中简单的部署一个k8s集群
# https://kubernetes.io/docs/setup/independent/install-kubeadm/

# 判断是否为root用户
if [[ "$EUID" -ne 0 ]]; then
    echo "Sorry, you need to run this as root";exit 1
fi

echo "防火墙状态:";service iptables status

swapoff -a

hostnamectl --static set-hostname  k8s-master

if [[ $(cat /etc/hosts | grep master) ]]; then
    ip=$(ifconfig | grep broadcast | grep 192 | awk '{print $2}')
    echo "${ip} k8s-master" | sudo tee -a /etc/hosts
fi

function restart_kubelet() {
    kubeadm reset -f
    iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X

    kubeadm_config=/etc/systemd/system/kubelet.service.d/10-kubeadm.conf
    if [[ ! `cat ${kubeadm_config} | grep fail-swap-on` ]]; then
        sed -i '2a\Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false' ${kubeadm_config}
#        echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> ${kubeadm_config}
    else
        sed -i '3d' ${kubeadm_config}
    fi
    # 重启kubelet
    systemctl daemon-reload
    systemctl restart kubelet
}

function install_k8s() {
    # 安装 kubelet kubeadm kubectl
    # export http_proxy=http://192.168.20.18:1087;export https_proxy=http://192.168.20.18:1087;

    if [[ ! -f /etc/apt/sources.list.d/kubernetes.list ]]; then
        apt-get update && apt-get install -y apt-transport-https curl
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
        echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    fi
    if [[ ! -f `which kubeadm` ]]; then
        apt-get update
        apt-get install -y kubelet kubeadm kubectl
        apt-mark hold kubelet kubeadm kubectl # 设置为禁止自动更新
    fi
}

function deploy_k8s() {
    # To run containers in Pods, Kubernetes uses a container runtime
    # Docker
    if [[ ! -f /etc/docker/daemon.json && ! $(cat /etc/docker/daemon.json | grep systemd) ]]; then
        cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries":["function.x:5000"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

        mkdir -p /etc/systemd/system/docker.service.d

        # Restart docker.
        systemctl daemon-reload
        systemctl restart docker
    fi

    # 初始化master节点，这个执行完，集群就部署成功了，就这个简单，你说气不气
    # 后面的参数是跟下面部署的网络组建对应的
    # 部署成功后会输出其他节点加入集群的命令，看好了
    # https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
    kubeadm version;echo
    kubeadm reset -f && iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
    kubeadm init --image-repository="k8s.gcr.io" --kubernetes-version="v1.14.2" --pod-network-cidr=10.244.0.0/16 #--ignore-preflight-errors=Swap

    if [[ $? -eq 0 ]]; then
        export KUBECONFIG=/etc/kubernetes/admin.conf;sleep 1;
        kubectl get nodes
        kubectl get cs
        sleep 2;kubectl get pods --all-namespaces -o wide
        kubectl taint nodes --all node-role.kubernetes.io/master-
        sysctl net.bridge.bridge-nf-call-iptables=1
        kubectl apply -f ./base/flannel/flannel.yaml
    fi
}

case ${1} in
    -i|install)
        install_k8s;exit;;
    -r|reset)
        restart_kubelet;exit;;
    -d|deploy)
        deploy_k8s;exit;;
    *)
        echo -e "\n`basename ${0}`:Usage: [OPTIONS]\n"
        echo -e "Options:"
        echo -e "\t-i, install \t\t Install k8s"
        echo -e "\t-r, reset \t\t Reset k8s config"
        echo -e "\t-d, deploy \t\t Deploy k8s\n"
        exit 1;;
esac
