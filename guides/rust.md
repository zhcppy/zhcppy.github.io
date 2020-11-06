# Rust

* Rust 速度惊人且内存利用率极高。由于没有运行时和垃圾回收，它能够胜任对性能要求特别高的服务，可以在嵌入式设备上运行，还能轻松和其他语言集成。
* Rust 丰富的类型系统和所有权模型保证了内存安全和线程安全，让您在编译期就能够消除各种各样的错误。
* Rust 是一门面向表达式的语言。
* Rust 是一种预编译语言，先编译再执行。

```bash
# 安装
curl https://sh.rustup.rs -sSf | sh
# 添加环境变量
echo "~/.cargo/bin" >> .profile && source .profile
# 卸载
rustup self uninstall
# 文档
rustup doc
```

用 `rustup component add rustfmt` 安装代码格式化工具 Rustfmt;

用 `rustup component add clippy` 安装 lint 工具 Clippy。

## Cargo

Cargo 负责三个工作：构建代码，下载代码依赖的库并编译这些库。

* cargo 配置国内镜像

在`$HOME/.cargo/config`文件中添加如下配置

```config
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = "ustc"
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
```


#### Macro rules

宏系统，元编程
调用宏时不是调用函数，调用宏会在编程阶段将宏转为可编译的源代码与其它程序一起运行


## 所有权

let A
let B = A

已知（固定）大小的类型完全存储在堆栈中，

可变大小的类型在传递的过程中会发生所有权的转移，即前者（A）会被回收，如果不想被回收，可以调用clone()方法

使用&进行引用的反义词是解引用,通过解引用运算符*来完成

只能在一个特定范围内对一个特定的数据进行一个可变引用

在任何时候，你可以拥有任何一个可变引用或任意数量不变引用。
