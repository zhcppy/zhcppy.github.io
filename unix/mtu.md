# Maximum Transmission Unit (MTU) 

最大传输单元(MTU)是可以在单个网络层事务中进行通讯的最大协议数据单元(PDU)的大小（https://en.wikipedia.org/wiki/Maximum_transmission_unit）。



**ping -c (number) -M do -s (bytes) IP**

number是次数 bytes是封包大小

ping -c 3 -M do -s 1472 192.168.31.1

ping -c 3 -M do -s 1452 baidu.com



调整MTU值:  **ifconfig eth0 mtu 1500**