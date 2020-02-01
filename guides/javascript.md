# JavaScript

### Chrome Console

* http请求

```js
// get请求
fetch("http://localhost:4000").then(res => console.log(res));

// post请求
fetch("http://localhost:4000",{ 
	method:"POST",
	headers: {
        "Content-Type": "application/json"
   }, 
   body:''
})
.then(res => console.log(res))
.catch(err => console.log("something went wrong: " + err));
```

* 加载js文件(库)

```js
let scriptElement = document.createElement('script');
scriptElement.src = "https://code.jquery.com/jquery-3.4.1.js";
document.getElementsByTagName('head')[0].appendChild(scriptElement);
jQuery.noConflict();
jQuery.ajax({
    url: 'http://localhost:4000',
    type: "GET",
    success:function(res) {
        console.log('发送成功！', res);
    },
    error:function(err) {
        console.log('发送失败！', err);
    }
});
```

* WebSocket连接

```js
let ws = new WebSocket("ws://192.169.20.18:8080/api/v1/ws");
ws.send('{}');
ws.close();
```

