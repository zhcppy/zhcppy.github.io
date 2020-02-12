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

```js
let ws = new WebSocket("wss://echo.websocket.org");

ws.onopen = function(evt) { 
  console.log("Connection open ...", evt); 
};

ws.onmessage = function(res) {
  console.log( "Received Message: " + res.data);
  ws.close();
};

ws.onclose = function(err) {
  console.log("Connection closed.");
};
```

* Console

```
// 断言并输出
console.assert(false, "debug");
// 统计代码被执行的次数
console.count('count:');
// 将DOM结点以DOM树的结构进行输出
console.dir();
// 统计时间
console.time('test time:'); // 计时开始
console.timeEnd('test time:'); // 计时结束
// 查看CPU使用信息
console.profile()
console.profileEnd()
// 堆栈跟踪相关的调试
console.trace()
// 输出表格
console.table()
// 监听函数执行
monitor(function name)

$ // 简单理解就是 document.querySelector 而已。
$$ // 简单理解就是 document.querySelectorAll 而已。
$_ // 是上一个表达式的值
0-4 // 是最近5个Elements面板选中的DOM元素，待会会讲。
dir // 其实就是 console.dir
keys // 取对象的键名, 返回键名组成的数组
values // 去对象的值, 返回值组成的数组
```
