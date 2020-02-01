# Golang

强类型 跨平台 二进制运行

## study blog

https://yourbasic.org/golang/

http://wiki.jikexueyuan.com/list/go/

## 实战

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

* TLS

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

## 脚手架

* run

```bash
wget -qcO- https://raw.githubusercontent.com/zhcppy/zhcppy.github.io/master/guides/go_scaffold.sh | bash
```

* show

[go-scaffold](go_scaffold.sh ':include :type=code bash')
