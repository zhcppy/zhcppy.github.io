# git常用技巧

doc: https://git-scm.com/book/zh

## git命令使用

```bash
# 切换到前一个分支
git checkout -
# 合并提交
git rebase -i [startpoint] [endpoint] #([startpoint] [endpoint]则指定了一个编辑区间)
# 修改commit msg
git commit --amend
# 直观显示修改内容
git status -sb 
# git查询提交信息
git show :/fix
# 终端内容着色
git config --global color.ui true
# 启用自动纠错功能, 在键入 `pul` 调用 `pull`命令
git config --global help.autocorrect true
```

* 合并分支
  
输入命令:

```bash
git branch --merged
```

这会显示所有已经合并到你当前分支的分支列表。

相反地：

```bash
git branch --no-merged
```

会显示所有还没有合并到你当前分支的分支列表。

[_进一步了解 Git `branch` 命令._](http://git-scm.com/docs/git-branch)

* 直观显示 git log 

```bash
git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --

# 添加alias
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"

git lg
```

* Stripspace 命令

Git Stripspace 命令可以:

- 去掉行尾空白符
- 多个空行压缩成一行
- 必要时在文件末尾增加一个空行

使用此命令时必须传入一个文件，像这样：

```bash
git stripspace < README.md
```
[_进一步了解 Git `stripspace` 命令._](http://git-scm.com/docs/git-stripspace)

* 提交空改动 :trollface:

可以使用`--allow-empty`选项强制创建一个没有任何改动的提交：

```bash
git commit -m "v0.0.1" --allow-empty
```

这样做在如下几种情况下是有意义的：

- 标记新的工作或一个新功能的开始。
- 记录对项目的跟代码无关的改动。
- 跟使用你仓库的其他人交流。
- 作为仓库的第一次提交，因为第一次提交后不能被 rebase：`git commit -m "init repo" --allow-empty`.

* 强制pull

```bash
git fetch --all 
git reset --hard origin/master
git pull
```

* 回滚

```bash
git reset --hard #<commit_id>
git push origin HEAD --force
```

* 本地提交后，git pull 拉到新的提交（导致git分叉）

```bash
git branch xx
git reset --hard #(回到本地提交的上一次提交)
git pull
git merge xx
git add .
git commit -am "cc"
git pull
git push
git branch -D xx
```

* 修改远端仓库

```bash
git remote rm origin
git remote add origin git@github.com:zhcppy/zhcppy.github.io.git
```    

* git pull 免密码

* 执行下面命令，再次输入密码后，以后将不再需要密码
* 注意：这里的用户名和密码都将以明文的方式默认保存在用户目录下的 .git-credentials 文件中，如果需要恢复，删除该文件即可
* 更多操作可查看[官方文档](https://www.google.com/search?q=credential.helper)

```bash
git config --global credential.helper store --file ~/.git-credentials
git config --local credential.helper --timeout 2019 cache
git pull
```

* 修改历史 commit 和 auther 信息

```base
git rebase -i HEAD~6
git commit --amend
git commit --amend --author "zhanghang <zhcppy@icloud.com>"
git rebase --continue
```

## 生成sshkey

```bash
ssh-keygen -t rsa -C "zhcppy@icloud.com" -f ~/.ssh/git_id_rsa
# --help 帮助文档
# -t rea 使用rsa加密算法
# -C "zhcppy@icloud.com" 添加说明
# -f ~/.ssh/git_id_rsa 保存文件
```

## 中文显示乱码

问题描述：当在终端中操作git时，中文被八进制的字符替换了

解决方法：

```bash
git config --global core.quotepath false
```

## 测试连通性

```bash
ssh -T git@github.com
```

GIT_TERMINAL_PROMPT=1 go get -v 