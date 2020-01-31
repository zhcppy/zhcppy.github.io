# Python 

Python是一种解释型、面向对象、动态数据类型的高级程序设计语言。

## 安装

* python3

```bash
# ubuntu install python3
sudo apt-get install python3
sudo apt-get install pip3

# mac install
brew install python3
```

* pip

```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
```

## python3 tool

```bash
# file server
python3 -m http.server

# parse json
python3 -m json.tool

# 检查python库是否安装成功
python3 -c "import pkgname"

# 解压zip
# -c 创建zip格式压缩包
# -e 提取zip格式压缩包
# -l 显示zip格式压缩包中的文件列表
# -t 验证文件是否为有效的zip格式压缩包
python3 -m zipfile -c xx.zip aa.txt bb.txt
    
```

## python3 lib

阻塞式http请求库 : pip3 install requests

驱动浏览器执行库 : pip3 install selenium

异步Web服务库 : pip3 install aiohttp

html解析库 : pip3 install lxml

ocr识别库 : sudo apt-get install tesseract-ocr libtesseract-dev libleptonica-dev  
添加ocr支持的语言

```bash
git clone https://github.com/tesseract-ocr/tessdata.git
sudo mv tessdata/* /usr/share/tesseract-ocr/tessdata

pip3 install tesserocr pillow

#* 安装 ChromeDriver
#* 安装 GeckoDriver
#* 安装 PhantomJS
```

## GIL

* CPython的线程是操作系统的原生线程。在Linux上为pthread，在Windows上为Win thread，完全由操作系统调度线程的执行。一个Python解释器进程内有一个主线程，以及多个用户程序的执行线程。即便使用多核心CPU平台，由于GIL的存在，也将禁止多线程的并行执行。[2]
* Python解释器进程内的多线程是以协作多任务方式执行。当一个线程遇到I/O任务时，将释放GIL。计算密集型（CPU-bound）的线程在执行大约100次解释器的计步（ticks）时，将释放GIL。计步（ticks）可粗略看作Python虚拟机的指令。计步实际上与时间片长度无关。可以通过sys.setcheckinterval()设置计步长度。
* 在单核CPU上，数百次的间隔检查才会导致一次线程切换。在多核CPU上，存在严重的线程颠簸（thrashing）。
* Python 3.2开始使用新的GIL。新的GIL实现中用一个固定的超时时间来指示当前的线程放弃全局锁。在当前线程保持这个锁，且其他线程请求这个锁时，当前线程就会在5毫秒后被强制释放该锁。
* 可以创建独立的进程来实现并行化。Python 2.6引进了多进程包multiprocessing。或者将关键组件用C/C++编写为Python扩展，通过ctypes使Python程序直接调用C语言编译的动态链接库的导出函数。

## 爬虫

爬取[格言网](https://www.geyanw.com)首页数据所有数据，并写入文件

[](motto.py ':include :type=code python')

## MongoDB

[](mongo.py ':include :type=code python')
