#!/usr/bin/env bash

# shell is funny

# 搭建完整的服务器监控环境

mkdir -p monitoring
work_path=`pwd`/monitoring

function clear() {
    pkill -e node_exporter
    sudo docker stop cadvisor prometheus grafana
    sudo docker rm -f cadvisor prometheus grafana
    rm -rf monitoring/*
}

function restart() {
    pkill -e node_exporter
    nohup ${work_path}/node_exporter-0.17.0.linux-amd64/node_exporter --web.listen-address=":9000" > log-node_exporter.log 2>&1 &
    sudo docker restart cadvisor prometheus grafana
}

function is_run(){
    read -p "Are you sure(y/n):" is
    if [[ "${is}" != "y" ]];then exit; fi
}

is_run
clear

# Node Exporter
# 用于收集主机硬件和操作系统信息
# 官方不建议在docker中安装，那我就不用docker装了
# https://github.com/prometheus/node_exporter

echo "================================================ Node Exporter"
cd ${work_path}
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz
tar -zxvf node_exporter-0.17.0.linux-amd64.tar.gz
cd node_exporter-0.17.0.linux-amd64
nohup ./node_exporter --web.listen-address=":9000" > log-node_exporter.log 2>&1 &

# cAdvisor
# 用于收集主机上运行的docker容器相关信息
# 开箱即用 哈哈哈哈
# https://github.com/google/cadvisor

echo "================================================ cAdvisor"
cd ${work_path}
sudo docker run -d -p 9100:8080 --name=cadvisor \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/dev/disk/:/dev/disk:ro \
    google/cadvisor:latest

echo "================================================ Prometheus"
# Prometheus
mkdir -p ${work_path}/prometheus/config
mkdir -p ${work_path}/prometheus/data
cat << EOF > ${work_path}/prometheus/config/prometheus.yml
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label 'job=<job_name>' to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['172.31.24.206:9000','172.31.24.206:9100','172.31.24.206:9200']
EOF

sudo docker run -d -p 9200:9090 --name=prometheus \
    -v ${work_path}/prometheus/config/prometheus.yml:/etc/prometheus/prometheus.yml \
    -v ${work_path}/prometheus/data \
    prom/prometheus

# Grafana
# 用各式各样的图像化方式显示数据
# https://github.com/grafana/grafana

echo "================================================ Grafana"
mkdir -p ${work_path}/grafana
sudo docker run -d -p 9300:3000 --user=`id -u` --name=grafana \
  -e "GF_SERVER_ROOT_URL=http://grafana.server.name" \
  -e "GF_SECURITY_ADMIN_PASSWORD=123456" \
  -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
  -v ${work_path}/grafana:/var/lib/grafana \
  grafana/grafana

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#
# 意外收获 windfall
#* 简单网络管理协议（SNMP）是一种Internet标准协议 https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol
#
#* Prometheus PushGateway 用于临时数据缓存，就是服务将源数据提交给 PushGateway，然后再让 Prometheus 从 PushGateway 中取数据
#
#* docker inspect -f 使用给定的Go模板格式化输出
#    https://docs.docker.com/engine/reference/commandline/inspect/#description
#    https://docs.docker.com/config/formatting/#json
#    https://golang.org/pkg/text/template/
#
#* 我今天才弄明白docker中的端口映射-p，前面的是宿主机的端口，后面的是容器端口，搞了半天，太可怕了
#    format: ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort | containerPort
#    https://docs.docker.com/v17.09/edge/engine/reference/run/#expose-incoming-ports