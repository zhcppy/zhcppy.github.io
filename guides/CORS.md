# CORS

### Curl

```bash
curl --data '{"method":"eth_blockNumber","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST http://18.163.163.138:8001 -v
```

### 浏览器控制台跨域测试

```javascript
var xhr = new XMLHttpRequest();
xhr.open('POST', 'http://18.163.163.138:8001');
xhr.setRequestHeader('Content-Type','application/json');
xhr.send('{"method":"eth_blockNumber","params":[],"id":1,"jsonrpc":"2.0"}');
```

### nginx 配置允许跨域

```
add_header Access-Control-Allow-Origin *;
add_header Access-Control-Allow-Methods GET,POST,OPTIONS;
add_header Access-Control-Allow-Headers DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization;
if ($request_method = 'OPTIONS') {
    return 204;
}
```