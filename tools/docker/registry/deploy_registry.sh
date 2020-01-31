#!/usr/bin/env bash

# shell is funny

# 部署需要账户登录的docker仓库

username=admin
password=admin

echo "work dir:"`pwd`

mkdir -p auth certs data

# 创建证书
openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
  -x509 -days 365 -out certs/domain.crt

echo "========== success to create certs"

# 创建docker仓库登陆用户名和密码
docker run --rm --entrypoint htpasswd \
  registry:2 -Bbn ${username} ${password} > auth/htpasswd

echo "========== success to create password"

docker run -d -p 5000:5000 --name registry \
  --restart=always \
  -v `pwd`/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v `pwd`/certs:/certs \
  -e REGISTRY_HTTP_SECRET=/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  -v `pwd`/data:/var/lib/registry \
  registry:2


echo "========== success to deploy docker registry"

# docker run -d -p 5000:5000 --name registry --restart=always registry:latest