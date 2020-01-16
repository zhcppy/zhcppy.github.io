# iptables

```bash
# 清空所有的防火墙规则
iptables -F
# 显示所有的防火墙规则
iptables -nL

iptables -I INPUT -p udp --dport 30310 -j DROP
iptables -I INPUT -p tcp --dport 30310 -j DROP
iptables -I INPUT -s 192.168.20.20 -p tcp --dport 30310 -j ACCEPT
iptables -I INPUT -s 192.168.20.20 -p udp --dport 30310 -j ACCEPT
```
