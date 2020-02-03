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

### Cargo

Cargo 负责三个工作：构建代码，下载代码依赖的库并编译这些库。