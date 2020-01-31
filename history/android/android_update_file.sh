#!/usr/bin/env bash

# shell is funny

# 通过adb更新Android应用外部依赖文件

set -o nounset
set -o errexit

# # # # # # # # # # # # # #

# adb devices
device=$1

# stop server
adb -s "${device}" shell am force-stop com.zhcppy.chainserver

# rm server
adb -s "${device}" shell rm /data/data/com.zhcppy.chainserver/source/server

# update server
adb -s "${device}" push ./build/bin/server /data/data/com.zhcppy.chainserver/files/webserver/

# start server
adb -s "${device}" shell am start -n com.zhcppy.chainserver/com.zhcppy.chainserver.MainActivity

# check the log
adb -s "${device}" shell tail -f /data/data/com.zhcppy.chainserver/source/logs/server.log