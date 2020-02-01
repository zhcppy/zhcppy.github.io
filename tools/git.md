# git常用技巧

## git命令使用

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

* 合并提交

```bash
git rebase -i [startpoint] [endpoint] #([startpoint] [endpoint]则指定了一个编辑区间)
```
    
* 修改commit msg

```bash
git commit --amend
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
