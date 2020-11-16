#!/bin/sh

# shell is funny

set -e

# 钉钉通知
SendToDingDing() {
    curl -s -X POST -H "Content-Type: application/json" \
    -d '{"msgtype":"text","text":{"content":"'"${1}"'"}}' \
    --url https://oapi.dingtalk.com/robot/send?access_token=2ab...e197
}

case ${1} in
zhcppy)
  msg=$(git pull)
  SendToDingDing "zhcppy: ${msg}"
  ;;
*)
  echo "undefined parameter [${1}]"
  SendToDingDing "undefined parameter error: ${1}"
  exit 1
  ;;
esac
