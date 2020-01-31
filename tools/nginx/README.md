# nginx

http://dmouse.iteye.com/blog/1880474

* nginx配置proxy_pass，需要注意转发的路径配置 

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

### SSL证书生成


### Config Demo

[nginx.conf](nginx.conf ':include :type=code nginx')
