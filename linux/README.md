### Shell Script

```shell script
du -smh # 查看文件(夹)大小

scp # 远程文件拷贝

curl -O https://zhcppy.github.io/README.md # 文件下载

tar -zxvf # 解压tar.gz文件
tar -zcvf # 压缩tar.gz文件

curl ip.sb # 获取IP地址

# Terminal set proxy
export ALL_PROXY=socks5://127.0.0.1:1086
export http_proxy=http://127.0.0.1:1086
export https_proxy=https://127.0.0.1:1086
export http_proxy=socks5://127.0.0.1:1086
export https_proxy=socks5://127.0.0.1:1086
# Terminal cancel proxy
unset ALL_PROXY http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
```

```shell script
# Linux查看系统开启启动时间情况
systemd-analyze blame
systemd-analyze critical-chain
```

### Linux

#### 动态主机配置协议（DHCP）

子网掩码是用来判断任意两台计算机的IP地址是否属于同一子网络的重要根据

* 软件端口三种类型：
1. 公认端口，也称 常用端口，端口号为从0～1023，常用端口机密绑定于一些特定的服务，不允许改变
2. 注册端口，端口号为从1024～49151 松散地绑定于一些服务
3. 动态或私有端口， 端口号从49152～65535

* 端口协议类型划分：
1. TCP 传输控制协议
2. UDP 用户数据包协议
3. IP 网络协议（Internet协议）
4. ICMP 网络控制消息歇息（Internet控制消息协议）

#### ICMP 互联网控制消息协议

属于TCP/IP协议族中的子协议，与传输协议不同，它在TCP/IP网络中发送控制消息，提供可能发生在通信环境中的各种问题反馈
ICMP与UDP一样，是不可靠的通信

> ps: TTL Time To Live 存活时间，指数据包在经过路由器时，可传输的最大跃点数（每经过一个路由器时，其存活次数减一）

ping的运作原理就是向目标主机传出一个ICMP的echo数据包，并等待回应

#### 关于定时器的使用(crontab)

每5s向指定文件中打印hello world

```shell script
touch task.cron
echo "*/5 * * * * * echo 'hello word' >> /tmp/hello.log" > task.cron
crontab task.cron # 启用定时任务
crontab -l  # 查看任务列表
crontab -r  # 清除任务
```

```shell script
sudo service cron restart   # 重启
sudo service cron start     # 启动
sudo service cron stop      # 停止
sudo service cron status    # 查看服务状态
```

#### 修改 Linux swap 分区

* 查看交换分区信息

```shell script
sudo swapon -s
free -h
```

* 检查硬盘分区使用情况

```shell script
df -h
```

* 设置交换分区大小

```shell script
sudo swapoff /swapfile # 停用
sudo dd if=/dev/zero of=/swapfile bs=1024M count=8 # 分配大小
ls -lh /swapfil # 查看文件权限
sudo chmod 600 /swapfile # 设置文件权限
sudo mkswap /swapfile # 设置文件格式
sudo swapon /swapfile # 启用
```

* 永久保存交换文件

```shell script
sudo cat /etc/fstab | grep swapfile
# 查看是否有 '/swapfile none swap sw 0 0' 如果没有就添加
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

* swap other

```shell script
# 系统将数据从RAM交换到交换空间的频率(0-100)
cat /proc/sys/vm/swappiness
```

### ubuntu

#### ubuntu apt-get install 失败的情况

一般是由于依赖包引起的，如果没有找的依赖包，可以更换软件源，
如果是本身电脑安装的版本高于所需版本，可以试着先卸载依赖包版本一致的那个软件，
然后再安装，这里卸载的时候要注意，卸载的依赖包会不会影响到其他的软件。

#### ubuntu VirtualBox 使用usb设备

下载版本对应的[扩展](http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html#extpack)，
在【管理 > 全局设定 > 扩展】添加进去就可以了

* 添加usbfs用户组

```shell script
sudo groupadd usbfs
```

* 将你的Linux常用用户添加到vboxusers、usbfs这个两个组中

```shell script
sudo adduser xx vboxusers  
sudo adduser xx usbfs
```

> 如果还是没有，可以尝试重启电脑
