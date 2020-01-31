#!/usr/bin/env bash

# shell is funny

# 使用shell脚本编译打包安装Android应用

set -o nounset
set -o errexit

# # # # # # # # # # # # # #
# shell build android apk #
# # # # # # # # # # # # # #

root=$(pwd)
echo "${root}"

apk_name='com.zhcppy.chainserver'

gradlew tasks

gradlew assembleDebug
echo "apk 构建完成"

#./gradlew installDebug

adb shell am force-stop ${apk_name}
echo "停止应用"

adb uninstall ${apk_name}
echo "卸载完成"

adb install "${root}"/app/build/outputs/apk/debug/app-debug.apk
echo "安装成功"

adb shell am start -n ${apk_name}/${apk_name}.MainActivity
echo "成功启动"

# adb uninstall com.zhcppy.chainserver

# android shell
#
#kill -9 `pgrep -f /data/user/0/com.zhcppy.chainserver/source/server`