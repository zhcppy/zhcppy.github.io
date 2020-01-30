# nginx

http://dmouse.iteye.com/blog/1880474

nginx配置proxy_pass，需要注意转发的路径配置 

1、location /test/ { 
                proxy_pass http://t6:8300; 
     } 

2、location /test/ { 
                proxy_pass http://t6:8300/; 
     } 

上面两种配置，区别只在于proxy_pass转发的路径后是否带 “/” 

针对情况2，如果访问url = http://server/test/test.jsp，则被nginx代理后，请求路径会变为 http://proxy_pass/test.jsp，直接访问server的根资源 

针对情况1，如果访问url = http://server/test/test.jsp，则被nginx代理后，请求路径会便问http://proxy_pass/test/test.jsp，将test/ 作为根路径，请求test/路径下的资源 


典型实例： 
同一个域名下，根据根路径的不同，访问不同应用及资源 
例如：A应用 http://server/a  ; B应用 http://server/b 

A 应用和 B应用共同使用访问域名 http://server； 
配置nginx代理转发时，如果采用情况2的配置方式，则会导致访问http://server/a/test.jsp时，代理到http://proxy_pass/test.jsp，导致无法访问到正确的资源，页面中如果有对根资源的访问，也都会以http://server 做为根路径访问资源，导致资源失效 

针对此类情况，需要采用情况1，分别针对不用应用，设置不同的根资源路径，并保证代理后的根路径也依然有效

### SSL证书生成
