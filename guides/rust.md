# Rust

* Rust是一种安全、并发、实用的编程语言，有着惊人的运行速度，能都防止段错误，并保证线程安全，是每个人都能构建可靠、高效的软件
* Rust非常快速且节省内存：没有运行时和垃圾收集器，它可以为性能关键性服务提供动力，在嵌入式设备上运行，并且可以轻松地与其他语言集成
* Rust的丰富类型系统和所有权模型保证了内存安全性和线程安全性 - 使您能够在编译时消除许多类错误
* Rust拥有出色的文档，友好的编译器和有用的错误消息，以及一流的工具-集成的包管理器和构建工具，具有自动完成的类型检查的智能多编辑器支持，自动格式化程序等。

Rustup: Rust安装器和版本管理工具

```bash
curl https://sh.rustup.rs -sSf | sh
```

用 `rustup component add rustfmt` 安装代码格式化工具 Rustfmt;

用 `rustup component add clippy` 安装 lint 工具 Clippy。
