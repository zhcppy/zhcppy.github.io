# crontab

```bash
# 每5s向指定文件中打印hello world
touch task.cron
echo "*/5 * * * * * echo 'hello word' >> /tmp/hello.log" > task.cron
crontab task.cron # 启用定时任务
crontab -l  # 查看任务列表
crontab -r  # 清除任务
```

```bash
sudo service cron restart   # 重启
sudo service cron start     # 启动
sudo service cron stop      # 停止
sudo service cron status    # 查看服务状态
```

* open file
```bash
#最前的 * 表示所有用户，可根据需要设置某一用户
echo "* soft nofile 1048576" | sudo tee -a vim /etc/security/limits.conf
echo "* hard nofile 1048576" | sudo tee -a vim /etc/security/limits.conf
```

