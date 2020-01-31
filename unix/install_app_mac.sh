#!/usr/bin/env bash

# shell is funny

# MacOS 开发环境

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

# use oh_my_zsh
if [ $SHELL != '/bin/zsh' ]; then
    # change default shell
    chsh -s $(which zsh)
    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    # install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# import env rc
wget -qcO- https://raw.githubusercontent.com/zhcppy/zhcppy.github.io/master/config/.profile >> ~/.zshrc

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

for app in "${GUI_APP[@]}" ; do
    echo ${app}
done

pwd
# 临时转移工作路径
(cd ~/go/src/;pwd)
pwd