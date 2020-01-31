#!/usr/bin/env bash

# shell is funny

# Golang Scaffold

read -p "Please enter the project name: " project_name

mkdir -p ${project_name}
cd ${project_name} || exit

git init
# git remote add [URL]  添加远程仓库
# git fetch             从远程仓库抓取数据

mkdir -p assets # 静态资源
mkdir -p internal # 私有应用程序和库代码
mkdir -p build # 构建和持续集成
mkdir -p configs # 配置文件模板或默认配置
mkdir -p docs # 设计和用户文档
mkdir -p tools # 该项目的支持工具
mkdir -p test/data # 其他外部测试应用和测试数据
mkdir -p vendor # 第三方依赖包

# go 启动文件
cat << EOF > main.go
/*
@Time $(date)
@Author ZH

*/
package main

func main() {

}

EOF

cat << EOF > .gitignore
*.o
*.a
*.out
*.test
*.log

.idea
.vscode
.DS_Store

vendor

EOF

cat << EOF > Makefile
#!/usr/bin/make -f

export GO111MODULE=on
export GOPROXY=https://goproxy.io

.PHONY: go.mod
go.mod:
	@go mod tidy && go mod verify && go mod download

.PHONY: install
install: go.mod
	@go install -v -mod=readonly .

.PHONY: format
format:
	@find . -name '*.go' -type f -not -path "./vendor*" -not -path "*.git*" | xargs gofmt -w -s

.PHONY: test
test:
	@go test -short -cover -mod=readonly ./...

EOF

cat << EOF > README.md
# ${project_name}

EOF

make go.mod

git add .
