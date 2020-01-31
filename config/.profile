# Golang
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
#export GO111MODULE=on
#export GOPRIVATE=
#export GOPROXY=https://goproxy.io
export PATH=$PATH:$GOBIN:$GOROOT/bin

# Rust
export CARGO_HOME=/usr/local/rust
export CARGO_INSTALL_ROOT=/usr/local/rust/bin
export PATH=$PATH:$HOME/.cargo/bin

# Java
export JAVA_HOME=/usr/local/java/jdk1.8
export JRE_HOME=/usr/local/java/jdk1.8/jre
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib
export MAVEN_HOME=/usr/local/maven
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$MAVEN_HOME/bin
# maven
export PATH=$PATH:/usr/local/apache-maven/bin

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_NDK=$ANDROID_HOME/ndk-bundle
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_NDK

alias getip="curl ip.gs"