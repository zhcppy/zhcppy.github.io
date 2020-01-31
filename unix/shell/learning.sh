#!/usr/bin/env bash

# shell is funny

# Linux脚本学习指南 ha ha ha

uptime
iftop
tmux
fg

dmesg
dmesg | less
sudo apt install sysstat
sudo sar -n DEV 1

sudo apt-get install mosh
mosh-server new -c 256 -s -l LANG=zh_CN.UTF-8 -l LC_CTYPE=zh_CN.UTF-8
mosh --ssh 'ssh -i ~/.ssh/test.pem' ubuntu@54.255.232.82

find . -name '*.go' -o -name '*.md' | xargs cat | wc -l

tcpdump

telnet host port

sudo nmap -sU -p port target

监听任意的 TCP 或 UDP 连接: nc -l 8080

端口使用情况  lsof -i

# 查询命令用法
man data

# 切换用户 switch user
su

# 监听任意的 TCP 或 UDP 连接
nc -l 8080

# -a 显示所有进程
# -u 显示用户以及详细信息
# -x 显示没有控制终端的进程
ps -aux

# Linux ip-172-31-26-167 4.4.0-1072-aws #82-Ubuntu SMP Fri Nov 2 15:00:21 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
# 内核名称 主机名 内核发行版本 节点名 系统时间 硬件平台 处理器类型 操作系统名称
uname -a

# 查看系统信息
cat /etc/os-release

# 查看系统的负载信息
# 01:25:43 up 21 days, 11:55,  1 user,  load average: 0.00, 0.01, 0.00
# 系统时间 已运行时间 终端数量 平均负载（1，5，15分钟）
uptime


# 显示内存使用量信息
free -h

# 查看当前登陆主机的用户终端信息
who
whoami
users

# 查看系统所有的登陆记录
# 该信息是保存在日志中的，所以仅能做为参考
last

# 显示历史执行过的命令
# 清空 other -c
other

# 显示行号
cat -n file.name

# 查看长篇文章
# 空格向下翻页
# b 向上翻页
# / 搜索
more file.name

# 查看文本的前n行
head -n 10 file.name

# 查看文本的后n行
tail -n 10 file.name

# 文本替换
# 将文件中的全部英文内容转换为小写
cat file.name | tr [A-Z] [a-z]

# 统计文本的行数，字数，字节数
wc /etc/passwd

# 查看文件的具体存储信息
stat /etc/hostname

# 提取文本信息
# -d 按列设置分割符
# -f 设置列数
cut -d : -f 1 /etc/passwd

# 比较文件差异
diff --brief fileA fileB # 判断两文件是否相同
diff -c fileA fileB # 显示两文件的差异

# 按照指定大小和个数的数据块来复制文件和转换文件
# if 输入文件名称
# of 输出文件名称
# bs 设置每个块的大小
# count 设置要复制块的个数
dd if=/dev/sero of=1M_file count=1 bs=1M

# 查看文件类型
file file.name

# 压缩或解压缩文件
# z 使用Dzip压缩或解压
# f 目标文件名
tar -czvf xxx.tar.gz ./
tar -xzvf xxx.tart.gz -C ./

# 文本搜索
# -n 显示行号
# -v 反选
# -i 忽略大小写
grep -n -v -i

# 文件查找
# -prune 忽略某个目录
# find / -name "home" -print
find [查找路径] 查找条件 操作

# 查看系统中所有的环境变量
env

# 创建单次计划任务
# ps. echo "xxx" | at 12:00
# 查看任务列表 at -l
# 取消任务 atrm 1
at

# 创建周期性计划任务
# 查 crond -l
# 删 crond -r
# 分 时 日 月 星期 命令
crond -e

# 设置文件的隐藏属性
chattr

# 显示文件的隐藏全新
lsattr

# 挂载文件系统
mount

# 磁盘管理
fdisk

# 查看文件数据占用量
du

# 创建链接文件
ln

# 早期的Linux系统中默认的防火墙管理服务
iptables

# * * * * * * * * * *
# Linux file
#
# - 普通文件
# d 目录文件
# l 链接文件
# b 块设备文件
# c 字符设备文件
# p 管道文件
#
# r 4 读
# w 2 写
# x 1 执行
#

# * * * * * * * * * *
# vim
#
# dd 剪切当前整行
# yy 复制当前整行
# p  粘贴
# u  撤销

# * * * * * * * * * *
# shell
#
# -d 判断文件是否为目录类型
# -e 判断文件是否存在
# -f 判断是否为一般文件
# -x 判断当前用户是否有可执行权限
#
# || 前面的命令失败后，执行后面的命令
# && 前面的命令成功后，执行后面的命令
#
# if ;then ;else ;fi
# for ;in ;do ;done
# while ;do ;done

# * * * * * * * * * *
# about
#
# 执行命令的末尾加上&符号，可以让命令进入后台运行，但是终端关闭时，该命令也会停止
# 如果希望命令摆脱终端的限制，可以在命令前面加上 nohup 或 setsid
# PS. nohup [command] > /dev/null 2>&1 &
#
# R(运行)：进程正在运行或运行队列中等待
# S(中断)：进程处于休眠中，当某个条件形成后或者接收到信号时，则脱离该状态
# D(不可中断)：进程不响应系统异步信号，即便使用kill命令也不能对其中断
# Z(僵死)：进程已经终止，但进程描述符依然存在，直到父进程调用wait()系统函数后将进程释放
# T(停止)：进程收到停止信号后停止运行
#
# stdin 标准输入  0
# stdout 标准输出 1
# stderr 错误输出 2
#
# 星号(*) 匹配零个或多个字符
# 问号(?) 匹配单个字符
# [0-9]  匹配0～9之间的单个数字字符
#
# su 用于切换身份的命令