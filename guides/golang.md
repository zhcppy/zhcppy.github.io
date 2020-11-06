# Golang

强类型 跨平台 二进制运行

* Ubuntu 安装最新版golang
```bash
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go
```

## 垃圾回收（GC）

自动的存储器管理机制，当计算机上的动态存储器不再需要使，就应该予以释放，以让出存储器，这种存储器资源管理被称为垃圾回收。

垃圾回收可以让程序员减轻负担，减少犯错误的机会。

垃圾回收是在后台运行的一个守护线程，它的作用是监控各个对象的状态，识别且丢弃不再使用的对象来释放和重用资源。

Golang 使用的垃圾回收机制是三色标记法配合写屏障和辅助GC，三色标记法是标记-清除法的一种增强版本。

Golang 的 GC 大部分处理是和用户代码并行的，注意是大部分，所以Golang的GC也是会需要STW（Stop The World）


GC调优

避免string和[]byte转化，两者发生转换的时候，底层数据结构会进行复制，因此导致GC效率会变低。

GC触发条件

* 超过内存大小阈值
* 达到定时事件阈值


### 引用类型和值类型

Golang中有三种引用类型：切片slice、哈希表map、管道channel，他们都是通过make完成初始化，其它的都是值类型

### Slice 的底层实现

切片的设计想法是由动态数组概念而来，

### Map 的底层实现

哈希表是计算机科学中最重要数据结构之一，这不仅因为它O(1)的读写性能非常优秀，还因为它提供了键值之间的映射。
实现一个性能优异的哈希表，需要注意两个关键点是哈希函数和冲突解决方法。

通过key进行hash运算，可简单理解为把key转化为一个整形数组，然后对数组的长度取余，得到key存储在数组的哪个下标位置，最后将key和value组装为一个结构体，放入数组下标出。

哈希函数：哈希的结果尽可能均匀，

冲突解决： 开放寻址法，拉链法

Golang 使用拉链法来解决哈希碰撞的问题实现哈希表，它的访问、写入和删除等操作都在编译期间转换成了运行时的函数和方法。
哈希在每一个桶中存储键对应哈希的前8位，当对哈希进行操作时，这些topHash就成为了一级缓存帮助哈希快速遍历桶中元素，每一个桶只能存储8个键值对，一旦当前哈希的某个桶超出8个，新的键值对就会被存储在哈希的溢出桶中。
随着键值对数量的增加，溢出桶的数量和哈希的装载因子也会逐渐升高，超过一定范围后就会触发扩容，扩容会将桶的数量翻倍，元素再分配的过程也是在调用写操作时增量进行的，不会造成性能的瞬时巨大抖动。

## 实战

* 开始一个项目

项目结构规范 https://github.com/golang-standards/project-layout

[脚手架](/guides/go_scaffold.sh ':ignore')

```bash
wget -qcO- https://raw.githubusercontent.com/zhcppy/zhcppy.github.io/master/guides/go_scaffold.sh | bash
```

* 读取文件

```go
func ReadFile(filePath string) ([]byte, error) {
    file, err := os.Open(filePath)
    if err != nil {
        return nil, err
    }
    defer file.Close()

    var b []byte
    buf := make([]byte, 1024)
    bufRead := bufio.NewReader(file)
    for {
        _, err := bufRead.Read(buf)
        b = append(b, buf...)
        if err != nil {
            if err == io.EOF {
                return b, nil
            }
            return nil, err
        }
    }
}
```

* 执行命令工具

```go
func ExecCommand(name string, arg ...string) error {
	cmd := exec.Command(name, arg...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Start(); err != nil {
		return fmt.Errorf("cmd.Start() failed with err:%s", err.Error())
	}
	if err := cmd.Wait(); err != nil {
		return fmt.Errorf("cmd running failed with err:%s", err.Error())
	}
	return nil
}

func checkExecEnv() error {
	for _, cmd := range []string{"git", "go", "make", "docker"} {
		if _, err := exec.LookPath(cmd); err != nil {
			return err
		}
	}
	return nil
}
```

* go lib

```bash
go get -v -u github.com/stretchr/testify/assert # 测试断言
go get -v -u github.com/ethereum/go-ethereum/crypto # ecdsa 解析公钥
go get -v -u github.com/gin-gonic/gin # http server 框架
go get -v -u github.com/gorilla/websocket # webSocket 框架
go get -v -u github.com/jinzhu/gorm # 数据库框架
go get -v -u github.com/karalabe/xgo # 交叉编译工具（依赖于docker）
go get -v -u github.com/go-stack/stack
go get -v -u github.com/mattn/go-sqlite3
```

* 二进制文件混淆

```bash
go help build
go tool link --help

go build -ldflags "-s -w"
```

#### TLS

X.509 秘密学里公钥证书的格式标准，被应用于许多网络协议，如TLS
包括公钥、标示、签名

TLS（Transport Layer Security） 传输层安全性 在计算机网络中提供安全性的加密协议 保证隐私和数据完整性

制作本地可信赖的开发证书 https://github.com/FiloSottile/mkcert

Please don't worry

1.生成服务器端的私钥  openssl genrsa -out server.key 2048
2.生成服务器端的证书  openssl req -new -x509 -key server.key -out server.crt -days 3650
Country Name | State or Province Name | Locality Name | Organization | Organizational Unit Name | Common Name | Email Address

//go:generate openssl req -new -nodes -x509 -out server.crt -keyout server.key -days 3650 -subj "/C=CN/ST=GZ/L=SZ/O=zhcppy/OU=IT/CN=localhost/EA=zhcppy@qq.com"

##### 奇技淫巧

* 数组中的两个元素交换位置，在golang里面一句话搞的，简直了

```go
var ary = []int{0, 1, 2, 3, 4, 5}
ary[0], ary[5] = ary[5], ary[0]

fmt.Println(ary) 
//print out: [5 1 2 3 4 0]
```

## 交叉编译

```bash
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build main.go
```

* GOOS：目标操作系统
* GOARCH：目标操作系统的架构
* CGO_ENABLED=0：
意思是使用C语言版本的GO编译器，参数配置为0的时候就关闭C语言版本的编译器了。
自从golang1.5以后go就使用go语言编译器进行编译了。
在golang1.9当中没有使用CGO_ENABLED参数发现依然可以正常编译。
当然使用了也可以正常编译。比如把CGO_ENABLED参数设置成1，即在编译的过程当中使用CGO编译器，我发现依然是可以正常编译的。
实际上如果在go当中使用了C的库，比如import "C"默认使用go build的时候就会启动CGO编译器，
当然我们可以使用CGO_ENABLED=0来控制go build是否使用CGO编译器

```bash
go build -mod=vendor

GOPROXY=https://goproxy.io GO111MODULE=on go mod tidy
```

## gomobile

* 编译

```
  1. $ go get golang.org/x/mobile/cmd/gomobile
     $ go get golang.org/x/mobile/cmd/gobind
  2. you must have ANDROID_HOME、ANDROID_NDK in env
  3. $ gomobile init  (--ndk $ANDROID_NDK)
  4. $ gomobile bind -target=android  ${go_src_project_path}
```


编译生成aar文件，将aar添加为android项目lib[方式](https://developer.android.com/studio/projects/android-library)

## 学习资源

https://yourbasic.org/golang/

http://wiki.jikexueyuan.com/list/go/
