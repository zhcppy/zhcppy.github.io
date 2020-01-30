#!/usr/bin/env bash

# shell is funny

#ABSTRACT MAC上安装应用

set -e

if [[ `uname` == "Darwin" ]];then
    echo "This script only runs in a MAC OS.";exit 1
fi

echo "=================== install start >>> `uname` ======================="
echo "OS X 的版本信息:\n"; sw_vers

# install Homebrew
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
which curl || brew install curl
which jq   || brew install jq

if [ $SHELL != '/bin/zsh' ]; then
    # change default shell
    chsh -s $(which zsh)
    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    # install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi


# import env rc
cat << EOF >> ~/.zshrc
# zhanghang
export GOBIN=$HOME/go/bin
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOBIN

#export ANDROID_NDK=/usr/local/android-ndk-r16b
#export ANDROID_HOME=$HOME/Library/Android/sdk
#export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_NDK

# export PATH=$PATH:/usr/local/apache-maven-3.6.0/bin

alias setproxy="export http_proxy=socks5://127.0.0.1:1086;export https_proxy=socks5://127.0.0.1:1086;"
alias getip="curl ip.gs"
EOF

git config --global user.name zhanghang
git config --global user.email zhcppy@icloud.com

# .ssh
cd ~ && mkdir -p .ssh
cat << EOF > ~/.ssh/config
Host *
    ServerAliveInterval 60
EOF

cat << EOF > ~/.ssh/environment
PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
EOF

GUI_APP=(iterm2)

for app in ${GUI_APP[@]} ; do
    echo ${app}
done

pwd
# 临时转移工作路径
(cd ~/go/src/;pwd)
pwd