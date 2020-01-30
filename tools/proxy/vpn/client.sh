#!/usr/bin/env bash

# shell is funny

# Doc: https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients-zh.md#%E4%BD%BF%E7%94%A8%E5%91%BD%E4%BB%A4%E8%A1%8C%E9%85%8D%E7%BD%AE-linux-vpn-%E5%AE%A2%E6%88%B7%E7%AB%AF

VPN_SERVER_IP=''
read -p "Please input VPN server IP: " VPN_SERVER_IP
VPN_IPSEC_PSK='zhcppy'
VPN_USER='zhanghang'
VPN_PASSWORD='zhanghang@666'

# 判断是否为root用户
if [[ "$EUID" -ne 0 ]]; then
    echo "Sorry, you need to run this as root";exit 1
fi

function init_vpn_client() {

    if [[ ! -f `which xl2tpd` ]]; then
        apt-get update
        apt-get -y install strongswan xl2tpd
    fi

#配置 strongSwan:
cat > /etc/ipsec.conf <<EOF
# ipsec.conf - strongSwan IPsec configuration file

# basic configuration

config setup
# strictcrlpolicy=yes
# uniqueids = no

# Add connections here.

# Sample VPN connections

conn %default
  ikelifetime=60m
  keylife=20m
  rekeymargin=3m
  keyingtries=1
  keyexchange=ikev1
  authby=secret
  ike=aes128-sha1-modp2048!
  esp=aes128-sha1-modp2048!

conn myvpn
  keyexchange=ikev1
  left=%defaultroute
  auto=add
  authby=secret
  type=transport
  leftprotoport=17/1701
  rightprotoport=17/1701
  right=${VPN_SERVER_IP}
EOF

cat > /etc/ipsec.secrets <<EOF
: PSK "${VPN_IPSEC_PSK}"
EOF

chmod 600 /etc/ipsec.secrets

# For CentOS/RHEL & Fedora ONLY
#mv /etc/strongswan/ipsec.conf /etc/strongswan/ipsec.conf.old 2>/dev/null
#mv /etc/strongswan/ipsec.secrets /etc/strongswan/ipsec.secrets.old 2>/dev/null
#ln -s /etc/ipsec.conf /etc/strongswan/ipsec.conf
#ln -s /etc/ipsec.secrets /etc/strongswan/ipsec.secrets

#配置 xl2tpd:
cat > /etc/xl2tpd/xl2tpd.conf <<EOF
[lac myvpn]
lns = ${VPN_SERVER_IP}
ppp debug = yes
pppoptfile = /etc/ppp/options.l2tpd.client
length bit = yes
EOF

cat > /etc/ppp/options.l2tpd.client <<EOF
ipcp-accept-local
ipcp-accept-remote
refuse-eap
require-chap
noccp
noauth
mtu 1280
mru 1280
noipdefault
defaultroute
usepeerdns
connect-delay 5000
name ${VPN_USER}
password ${VPN_PASSWORD}
EOF

chmod 600 /etc/ppp/options.l2tpd.client
}

function connection_vpn() {
    # 创建 xl2tpd 控制文件
    mkdir -p /var/run/xl2tpd
    touch /var/run/xl2tpd/l2tp-control

    # 重启服务
    service strongswan restart
    service xl2tpd restart
    sleep 1

    # 开始 IPsec 连接
    ipsec up myvpn
    sleep 2;echo

    # 开始 L2TP 连接
    echo "c myvpn" > /var/run/xl2tpd/l2tp-control

    # 检查你现有的默认路由
    # ip route
    # 从新的默认路由中排除你的 VPN 服务器 IP 和 本地电脑的公有 IP
    GW_IP=$(ip route | grep default | awk '{print $3}')
    LOCAL_PUBLIC_IP=$(wget -qO- http://ipv4.icanhazip.com)
    route add ${VPN_SERVER_IP} gw ${GW_IP}
    route add ${LOCAL_PUBLIC_IP} gw ${GW_IP}

    # 添加一个新的默认路由，并且开始通过 VPN 服务器发送数据
    sleep 2 && route add default dev ppp0

    # 至此 VPN 连接已成功完成, 检查 VPN 是否正常工作
    sleep 1 && wget -qO- http://ipv4.icanhazip.com
}

function shutdown_vpn() {
    # 要停止通过 VPN 服务器发送数据
    route del default dev ppp0

    # 要断开连接
    echo "d myvpn" > /var/run/xl2tpd/l2tp-control
    ipsec down myvpn
}

case ${1} in
    -i|init)
        init_vpn_client;exit;;
    -c|connection)
        connection_vpn;exit;;
    -s|shutdown)
        shutdown_vpn;exit;;
    *)
        echo -e "\n`basename ${0}`:Usage: [OPTIONS]\n"
        echo -e "Options:"
        echo -e "\t-i, init \t\t Install strongswan,xl2tpd and init config"
        echo -e "\t-c, connection \t\t Connection VPN server: ${VPN_SERVER_IP}"
        echo -e "\t-s, shutdown \t\t Shutdown VPN \n"
        exit 1;;
esac