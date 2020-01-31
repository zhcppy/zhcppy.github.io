# Hexo

使用[Hexo](https://hexo.io/zh-cn/)和[Github](https://github.com)搭建的个人博客网站

## 开始吧
这是我在windows系统下搭建这个博客的过程
PS.我发誓！我再也不会在windows上写一行代码【2018.12.23】

## 安装工具
- 安装[git](https://git-scm.com/)
- 安装[Node.js](https://nodejs.org/en/)

然后在Git Bash Here里通过命令安装Hexo

    $ npm install hexo-cli -g

## 搭建网站

下面都是在Git Bash Here里执行命令

1.创建网站的根目录

    $ hexo init D:/blog

2.进入目录

    $ cd D:/blog

3.初始化网站，[Hexo](https://hexo.io/zh-cn/) 将会在指定文件夹中新建所需要的文件，这个过程可能有点慢

    $ npm install

## 启动Hexo服务

接着刚才的命令，在D:/blog目录下执行

    $ hexo server  或者  $ hexo s

现在就可以打开浏览器在地址栏中输入： localhost:4000

网站就这样出来了，是不是很神奇

## 创建仓库

刚才创建出来的网站只能在本地访问，想要能在网络上来访问就需要在[github](https://github.com)上创建一个仓库，名字格式为：zhcppy.github.io

创建出来是空的，我们还需要一些配置才行

## 修改配置

网站虽然是出来了，但是好像还木有一点自己的内容，那就接着改吧

在刚才创建的D:/blog目录下有个文件 _config.yml 修改里面的几个属性就可以看起来像是你自己的网站了

我自己的配置：

    title: my blog
    subtitle: 一个偏执的热血青年在偏执的道路上越陷越深
    description: zhcppy
    keywords: zhcppy
    author: zhcppy
    email: zhcppy@icloud.com
    language: zh-CN

	···

	deploy:
  		type: git
  		repo: https://github.com/zhcppy/zhcppy.github.io.git
  		branch: master


更多配置属性介绍可以参考[这里](https://hexo.io/zh-cn/docs/configuration.html)


## 见证奇迹

前面所有的都配置好后，执行下面的命令重新生成网站，生成的整个网站在public文件下

    $ hexo generate  或者  $ hexo g

执行下面的命令将生成好的网站提交到[github](https://github.com)

    $ hexo deploy  或者  $ hexo d

上面的命令执行完后，就可以在浏览器地址栏输入[zhcppy.github.io](zhcppy.github.io)

这样你就能在有网络的地方访问到你的网站了

很有趣吧···

## 其他

新建一篇文章

    $ hexo new <title>

查看[Hexo](https://hexo.io/zh-cn/) 版本信息

    $ hexo version

列出网站资料

    $ hexo list <type>

清除缓存文件 (db.json) 和已生成的静态文件 (public)

    $ hexo clean


## 我遇到的问题

问题：修改配置文件 _config.yml 里面的属性后乱码

解决：将配置文件的编码格式改为UTF-8

运行 $ hexo server 报 ENOSPC 错误

错误内容:

    INFO  Start processing
    FATAL Something's wrong. Maybe you can find the solution here: http://hexo.io/docs/troubleshooting.html
    Error: watch /home/XXXXXXX/blog/source/ ENOSPC
        at exports._errnoException (util.js:1018:11)
        at FSWatcher.start (fs.js:1443:19)
        at Object.fs.watch (fs.js:1470:11)
        at createFsWatchInstance (/home/XXXXXXX/blog/node_modules/chokidar/lib/nodefs-handler.js:37:15)
        at setFsWatchListener (/home/XXXXXXX/blog/node_modules/chokidar/lib/nodefs-handler.js:80:15)
        at FSWatcher.NodeFsHandler._watchWithNodeFs (/home/XXXXXXX/blog/node_modules/chokidar/lib/nodefs-handler.js:228:14)
        at FSWatcher.NodeFsHandler._handleDir (/home/XXXXXXX/blog/node_modules/chokidar/lib/nodefs-handler.js:407:19)
        at FSWatcher.<anonymous> (/home/XXXXXXX/blog/node_modules/chokidar/lib/nodefs-handler.js:455:19)
        at FSWatcher.<anonymous> (/home/XXXXXXX/blog/node_modules/chokidar/lib/nodefs-handler.js:460:16)
        at FSReqWrap.oncomplete (fs.js:123:15)

可以运行 $ npm dedupe 来尝试解决，如果不起作用的话，可以尝试在 Linux 终端中运行下列命令：

    $ echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
