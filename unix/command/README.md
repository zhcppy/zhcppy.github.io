&emsp;[:back: 返回上一级](/unix/linux.md)

# Linux Command

https://www.cnblogs.com/peida/tag/linux%E5%91%BD%E4%BB%A4

* `data`查看操作系统时间
* `data =%Y/%m/%d`
* `hwclock`查看硬件时间
* `echo` 查看输入内容
* `echo "写入文本" >> text`
* `cat` 显示文本内容
* `head -n` 显示文本头几行
* `tail -n` 显示文本尾几行
* `tail -f` 追踪文件更新
* `more` 翻页显示文本
* `less` 翻页显示文本
* `lspci` 查看 PCI 设备
* `lspci -v` 详细显示
* `lsusb`查看 USB 设备
* `lsmod`查看加载的模块（驱动）
* `shutdown` 关机
* `shutdown -h`关机
* `shutdown -r`重启
* `shutdown -h now`现在关机
* `shutdown -h +10` 十分钟后关机
* `shutdown -h 23:30` 23 点三十分关机
* `locate`快速查找文件
* `updatedb` 更新 locate 数据库
* `find` 实时查找
* `find . -name *tmp*`查找当前目录文件名通配 tmp 的文件
* `find / -name *tmp*` 查找根目录
* `find / -perm 777` 按权限查找
* `find / -type d` 按类型查找
* `find . name "a*" - exec ls -l{}\;`
* `find . -user` 用户
* `find . -group` 组
* `find . -ctime` 修改时间
* `find . -size` 大小

## 系统

- uname -a 查看内核/操作系统/CPU 信息
- head -n 1 /etc/issue 查看操作系统版本
- cat /proc/cpuinfo 查看 CPU 信息
- hostname 查看计算机名
- lspci -tv 列出所有 PCI 设备
- lsusb -tv 列出所有 USB 设备
- lsmod 列出加载的内核模块
- env 查看环境变量

## 资源

- free -m 查看内存使用量和交换区使用量
- df -h 查看各分区使用情况
- du -sh <目录名>查看指定目录的大小
- grep MemTotal /proc/meminfo 查看内存总量
- grep MemFree /proc/meminfo 查看空闲内存量
- uptime 查看系统运行时间、用户数、负载
- cat /proc/loadavg 查看系统负载

## 磁盘和分区

- mount | column -t 查看挂接的分区状态
- fdisk -l 查看所有分区
- swapon -s 查看所有交换分区
- hdparm -i /dev/hda 查看磁盘参数(仅适用于 IDE 设备)
- dmesg | grep IDE 查看启动时 IDE 设备检测状况

## 网络

- ifconfig 查看所有网络接口的属性
- iptables -L 查看防火墙设置
- route -n 查看路由表
- netstat -lntp 查看所有监听端口
- netstat -antp 查看所有已经建立的连接
- netstat -s 查看网络统计信息
- traceroute 网络诊断
  

## 进程

- ps -ef 查看所有进程
- top 实时显示进程状态

## 用户

- w 查看活动用户
- id <用户名>查看指定用户信息
- last 查看用户登录日志
- cut -d: -f1 /etc/passwd 查看系统所有用户
- cut -d: -f1 /etc/group 查看系统所有组\
- crontab -l 查看当前用户的计划任务

## 服务

- chkconfig --list 列出所有系统服务
- chkconfig --list | grep on 列出所有启动的系统服务
