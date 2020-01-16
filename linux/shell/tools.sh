#!/usr/bin/env bash

# shell is funny

# 日期格式化 2018-12-25
date "+%Y-%m-%d %H:%M:%S %W %w"

# 设置echo字体颜色
heading(){ echo ; echo "$(tput setaf 6)==>$(tput sgr0)$(tput bold) $1 $(tput sgr0)"; }
success(){ echo ; echo "$(tput setaf 2)==>$(tput bold) $1 $(tput sgr0)"; }
error(){ echo ; echo "$(tput setaf 1)==>$(tput bold) Error: $1 $(tput sgr0)"; }

read -p "Are you sure:(y/n) " an
if [[ ${an} != "y" ]]; then exit; fi

# 判断是否存在程序
function check_app_exist() {
    app_command=$1
    if [[ -f $(which ${app_command} 2>/dev/null) ]];then
        echo "${app_command} exist"
    fi

#    if which ${app_command} >/dev/null 2>&1; then
#        echo "${app_command} exist"
#    fi
}

# 获取IP地址
function get_ip() {
    # ifconfig | grep 'inet' | grep 'broadcast' | awk '{print $2}'
    local_IP=$(ifconfig | grep 'inet ' | grep -v '127.0.0.1' | head -n1 | awk '{print $2}' | cut -d':' -f2)
    echo "Local IP: ${local_IP}"

    pub_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
    echo "Public IP: ${pub_IP}"
}

# 接受输入
function read_data() {
    echo "Please choose one of the following:"
    echo "1. success"
    echo "2. error"
    while true; do
        read -p "Choose the implementation: " input
        case ${input} in
            [1]* ) success "1. success"; break;;
            [2]* ) error "2. error"; break;;
            * ) echo "Please answer 1 or 2.";;
        esac
    done
}

# 判断是否为root用户
function check_root_user() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "Sorry, you need to run this as root"
        exit
    fi
}

# 判断文件是否存在
function check_file_exist() {
    file_path=$1
    if [[ -f ${file_path} ]];then
        echo "exist"
    fi
}

# -n 判断一个变量是否有值
if [[ ! -n $1 ]]; then
  echo "$1 is empty"
fi

# -d 参数判断 $folder 是否存在
if [[ ! -d "$folder" ]]; then
  echo "$folder"
fi

# -x 参数判断 $folder 是否存在并且是否具有可执行权限
if [[ ! -x "$folder" ]]; then
  echo "$folder"
fi

function alert() {
message="$@"
osascript<<EOF

tell application "Finder"
	activate
	display Dialog "${message}"
end tell

EOF
}
alert "$@"
