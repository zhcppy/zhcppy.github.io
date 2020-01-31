# MacOS

* Mac系统输入法长按一个按键不能连续输入

```bash
defaults write NSGlobalDomain ApplePressAndHoldEnabled -boolean false
```

or

```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```

### brew

* brew 主要用来下载一些不带界面的命令行下的工具和第三方库来进行二次开发

* brew cask主要用来下载一些带界面的应用软件，下载好后会自动安装，并能在mac中直接运行使用

### mac 电脑设置文档

https://github.com/sb2nov/mac-setup
