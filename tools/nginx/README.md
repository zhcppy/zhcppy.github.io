# nginx

##### 来自网络上的一个好介绍

> - 传统上基于进程或线程模型架构的 Web 服务通过每进程或每线程处理并发连接请求，这势必会在网络和 I/O 操作时产生阻塞，其另一个必然结果则是对内存或 CPU 的利用率低下。生成一个新的进程/线程需要事先备好其运行时环境，这包括为其分配堆内存和栈内存，以及为其创建新的执行上下文等。这些操作都需要占用 CPU，而且过多的进程/线程还会带来线程抖动或频繁的上下文切换，系统性能也会由此进一步下降。
> - 在设计的最初阶段，Nginx 的主要着眼点就是其高性能以及对物理计算资源的高密度利用，因此其采用了不同的架构模型。受启发于多种操作系统设计中基于“事件”的高级处理机制，nginx 采用了模块化、事件驱动、异步、单线程及非阻塞的架构，并大量采用了多路复用及事件通知机制。在 Nginx 中，连接请求由为数不多的几个仅包含一个线程的进程 Worker 以高效的回环(run-loop)机制进行处理，而每个 Worker 可以并行处理数千个的并发连接及请求。
> - 如果负载以 CPU 密集型应用为主，如 SSL 或压缩应用，则 Worker 数应与 CPU 数相同；如果负载以 IO 密集型为主，如响应大量内容给客户端，则 Worker 数应该为 CPU 个数的 1.5 或 2 倍。
> - Nginx 会按需同时运行多个进程：一个主进程(Master)和几个工作进程(Worker)，配置了缓存时还会有缓存加载器进程(Cache Loader)和缓存管理器进程(Cache Manager)等。所有进程均是仅含有一个线程，并主要通过“共享内存”的机制实现进程间通信。主进程以 root 用户身份运行，而 Worker、Cache Loader 和 Cache manager 均应以非特权用户身份运行。
> - 主进程主要完成如下工作：
    - 1.读取并验正配置信息；
    - 2.创建、绑定及关闭套接字；
    - 3.启动、终止及维护worker进程的个数；
    - 4.无须中止服务而重新配置工作特性；
    - 5.控制非中断式程序升级，启用新的二进制程序并在需要时回滚至老版本；
    - 6.重新打开日志文件，实现日志滚动；
    - 7.编译嵌入式perl脚本；
> - Worker 进程主要完成的任务包括：
    - 1.接收、传入并处理来自客户端的连接；
    - 2.提供反向代理及过滤功能；
    - 3.nginx任何能完成的其它任务；
> - Cache Loader 进程主要完成的任务包括：
    - 1.检查缓存存储中的缓存对象；
    - 2.使用缓存元数据建立内存数据库；
> - Cache Manager 进程的主要任务：
    - 1.缓存的失效及过期检验；

##### nginx 使用 

- 启动服务：`service nginx start`
- 停止服务：`service nginx stop`
- 重启服务：`service nginx restart`

- 先检查是否在 /usr/local 目录下生成了 Nginx 等相关文件：`cd /usr/local/nginx;ll`，正常的效果应该是显示这样的：

```nginx
drwxr-xr-x. 2 root root 4096 3月  22 16:21 conf
drwxr-xr-x. 2 root root 4096 3月  22 16:21 html
drwxr-xr-x. 2 root root 4096 3月  22 16:21 sbin
```

- 停止防火墙：`service iptables stop`
- 或是把 80 端口加入到的排除列表：
- `sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT`
- `sudo service iptables save`
- `sudo service iptables restart`
- 启动：`/usr/local/nginx/sbin/nginx`，启动完成 shell 是不会有输出的
- 检查 时候有 Nginx 进程：`ps aux | grep nginx`，正常是显示 3 个结果出来
- 检查 Nginx 是否启动并监听了 80 端口：`netstat -ntulp | grep 80`
- 访问：`192.168.1.114`，如果能看到：`Welcome to nginx!`，即可表示安装成功
- 检查 Nginx 启用的配置文件是哪个：`/usr/local/nginx/sbin/nginx -t`
- 刷新 Nginx 配置后重启：`/usr/local/nginx/sbin/nginx -s reload`
- 停止 Nginx：`/usr/local/nginx/sbin/nginx -s stop`
- 如果访问不了，或是出现其他信息看下错误立即：`vim /var/log/nginx/error.log`

##### nginx 路由配置

http://dmouse.iteye.com/blog/1880474

nginx配置proxy_pass，需要注意转发的路径配置 

下面两种配置，区别只在于proxy_pass转发的路径后是否带 “/”

1:
```nginx
location /zhcppy/ { 
    proxy_pass https://github.com/zhcppy:443; 
} 
```

针对情况1，如果访问 `url = http://server/zhcppy/index.html`，
则被nginx代理后，请求路径会便问 `http://proxy_pass/zhcppy/index.html`，
将 `zhcppy/` 作为根路径，请求 `zhcppy/` 路径下的资源

2:
```nginx
location /zhcppy/ { 
    proxy_pass https://github.com/zhcppy:443/; 
} 
```

针对情况2，如果访问 `url = http://server/zhcppy/index.html`，
则被nginx代理后，请求路径会变为 `http://proxy_pass/index.html`，直接访问server的根资源 

典型实例： 
同一个域名下，根据根路径的不同，访问不同应用及资源  
例如：A应用 `http://server/a` B应用 `http://server/b`  

A 应用和 B 应用共同使用访问域名 `http://server`； 
配置nginx代理转发时，如果采用情况2的配置方式，则会导致访问 `http://server/a/index.html` 时，
代理到 `http://proxy_pass/index.html`，导致无法访问到正确的资源，页面中如果有对根资源的访问，
也都会以 `http://server` 做为根路径访问资源，导致资源失效。

针对此类情况，需要采用情况1，分别针对不用应用，设置不同的根资源路径，并保证代理后的根路径也依然有效。

### Nginx 全局变量

- \$arg_PARAMETER #这个变量包含 GET 请求中，如果有变量 PARAMETER 时的值。
- \$args #这个变量等于请求行中(GET 请求)的参数，例如 foo=123&bar=blahblah;
- \$binary_remote_addr #二进制的客户地址。
- \$body_bytes_sent #响应时送出的 body 字节数数量。即使连接中断，这个数据也是精确的。
- \$content_length #请求头中的 Content-length 字段。
- \$content_type #请求头中的 Content-Type 字段。
- \$cookie_COOKIE #cookie COOKIE 变量的值
- \$document_root #当前请求在 root 指令中指定的值。
- $document_uri #与$uri 相同。
- \$host #请求主机头字段，否则为服务器名称。
- \$hostname #Set to the machine’s hostname as returned by gethostname
- \$http_HEADER
- $is_args #如果有$args 参数，这个变量等于”?”，否则等于”"，空值。
- \$http_user_agent #客户端 agent 信息
- \$http_cookie #客户端 cookie 信息
- \$limit_rate #这个变量可以限制连接速率。
- $query_string #与$args 相同。
- \$request_body_file #客户端请求主体信息的临时文件名。
- \$request_method #客户端请求的动作，通常为 GET 或 POST。
- \$remote_addr #客户端的 IP 地址。
- \$remote_port #客户端的端口。
- \$remote_user #已经经过 Auth Basic Module 验证的用户名。
- \$request_completion #如果请求结束，设置为 OK. 当请求未结束或如果该请求不是请求链串的最后一个时，为空(Empty)。
- \$request_method #GET 或 POST
- \$request_filename #当前请求的文件路径，由 root 或 alias 指令与 URI 请求生成。
- \$request_uri #包含请求参数的原始 URI，不包含主机名，如：”/foo/bar.php?arg=baz”。不能修改。
- \$scheme #HTTP 方法（如 http，https）。
- \$server_protocol #请求使用的协议，通常是 HTTP/1.0 或 HTTP/1.1。
- \$server_addr #服务器地址，在完成一次系统调用后可以确定这个值。
- \$server_name #服务器名称。
- \$server_port #请求到达服务器的端口号。
- $uri #不带请求参数的当前URI，$uri 不包含主机名，如”/foo/bar.html”。该值有可能和\$request_uri 不一致。
- \$request_uri 是浏览器发过来的值。该值是 rewrite 后的值。例如做了 internal redirects 后。

### Nginx 常用配置

* location 配置

```nginx
= 开头表示精确匹配
^~ 开头表示uri以某个常规字符串开头，不是正则匹配
~ 开头表示区分大小写的正则匹配;
~* 开头表示不区分大小写的正则匹配
/ 通用匹配, 如果没有其它匹配,任何请求都会匹配到

location / {}
location /user {}
location = /user {}
location /user/ {}
location ^~ /user/ {}
location /user/youmeek {}
location ~ /user/youmeek {}
location ~ ^(/cas/|/casclient1/|/casclient2/|/casclient3/) {}
location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|ico|woff|woff2|ttf|eot|txt)$ {}
location ~ .*$ {}
```

* HTTP 服务，绑定多个域名

    - <https://www.ttlsa.com/nginx/use-nginx-proxy/>

* 防盗链

    - <https://help.aliyun.com/knowledge_detail/5974693.html?spm=5176.788314853.2.18.s4z1ra>

* Nginx 禁止特定用户代理（User Agents）访问，静止指定 IP 访问

    - <https://www.ttlsa.com/nginx/how-to-block-user-agents-using-nginx/>
    - <https://help.aliyun.com/knowledge_detail/5974693.html?spm=5176.788314853.2.18.s4z1ra>

* Nginx 缓存

* Nginx 自动分割日志文件

* 安全相预防

在配置文件中设置自定义缓存以限制缓冲区溢出攻击的可能性  
client_body_buffer_size 1K;  
client_header_buffer_size 1k;  
client_max_body_size 1k;  
large_client_header_buffers 2 1k;  

将 timeout 设低来防止 DOS 攻击 所有这些声明都可以放到主配置文件中。  
client_body_timeout 10;  
client_header_timeout 10;  
keepalive_timeout 5 5;  
send_timeout 10;  

限制用户连接数来预防 DOS 攻击  
limit_zone slimits \$binary_remote_addr 5m;  
limit_conn slimits 5;  

### SSL证书生成


### Config Demo

[nginx.conf](nginx.conf ':include :type=code nginx')
