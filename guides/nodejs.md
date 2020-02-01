# NodeJs

事件驱动、非阻塞式 I/O

## 安装

* MAC 安装 nodejs

```bash
# 下载pkg安装
curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"
# brew安装
brew install node
```

* Ubuntu 安装 nodejs

    * [How to install Node.js via binary archive on Linux?](https://github.com/nodejs/help/wiki/Installation#how-to-install-nodejs-via-binary-archive-on-linux)
    * [distributions](https://github.com/nodesource/distributions)
    * [nodejs](https://nodejs.org/en/download/package-manager)

```bash
# Using Ubuntu
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs
```

* nvm 管理 node.js 版本

https://github.com/nvm-sh/nvm

```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
```

## npm 包管理工具

```bash
# npm是随同node.js一起安装的，设置npm国内淘宝代理镜像
npm config set registry https://registry.npm.taobao.org

# 修改npm全局包目录权限
sudo chown -R ${USER} /usr/local/lib/node_modules

# 命令行http服务器 (https://www.npmjs.com/package/http-server)
npm install http-server -g
```

## 实战

* 非阻塞式读取文件

```js
let fs = require("fs");

fs.readFile(guides, function(err, data){//回调
    if (err) {
        return console.error(err);
    }
    console.log(data.toString());
});

console.log("END");
```

* HtmlToPDF

```js
let fs = require('fs');
let pdf = require('html-pdf');
let html = fs.readFileSync('./contract_mould.html', 'utf8');
let options = { format: 'Letter' };

pdf.create(html, options).toFile('./contract.pdf', function(err, res) {
if (err) return console.log(err);
console.log(res); // { filename: '/app/businesscard.pdf' }
});
```

* MarkdownToPDF

```js
let markdownpdf = require("markdown-pdf");
let fs = require("fs");
fs.createReadStream("./nodejs.md")
.pipe(markdownpdf())
.pipe(fs.createWriteStream("./nodejs.pdf"))
```

* 正则脱敏

```js
let reg = /^(\d{4})(\d*)(\d{4})$/;
let str = "1213324343555454";
str = str.replace(reg, function(a, b, c, d) {
    return b + c.replace(/\d/g, "*") + d;
    });
console.log(str);
```

* 阿里短信服务API

* 新建短信签名

    签名 （产品名称）

    上传 企业营业执照、组织机构带代码证、税务登记证

    备注：主要用途：验证手机号是否为本人操作;

* 新建短信模板

    模板内容 您的验证码是${no}。如非本人操作，请忽略本短信。

* 使用node.js发送请求

```js
var http = require('http');
var querystring = require('querystring');

var data={
    ParamString: '{"no":"123456"}',
    RecNum: '电话号码',
    SignName: '签名名称',
    TemplateCode: '模板代码'
};

var querys = querystring.stringify(data);

var options = {
    hostname: 'sms.market.alicloudapi.com',
    port:80,
    path: '/singleSendSms?' + querys,
    method: 'GET',
    headers:{'Authorization':'APPCODE '+'自己的AppCode'}
};

//发送请求
var req = http.request(options,function(res){
    console.log('STATUS:' + res.statusCode);//打印状态
    res.setEncoding('utf8');
    res.on('data',function(chunk){
        var returnData = JSON.parse(chunk);//返回结果
        console.log(returnData);
    });
    res.on('end',function(){//请求结束
        console.log('END');
    });  
});

req.on('error', function(e){//请求出现错误
     console.log('ERROR：' + e.message);
});

req.end();
```

* 木偶 puppeteer

```js
const puppeteer = require('puppeteer');

// 浏览器截图
(async () => {
    const browser = await puppeteer.launch({
        headless: false,
        // args: ['--proxy-server=socks5://127.0.0.1:1086'],
    });
    const page = await browser.newPage();
    await page.goto('https://baidu.com');
    await page.screenshot({path: 'baidu.png'});

    await browser.close();
})();

// 导出PDF
// (async () => {
//     const browser = await puppeteer.launch();
//     const page = await browser.newPage();
//     await page.goto('https://baidu.com', {waitUntil: 'body'});
//     await page.pdf({path: 'baidu.pdf', format: 'A4'});
//
//     await browser.close();
// })();
```
