# Makefile

```makefile
#!/usr/bin/make -f

.PHONY: test nginx

test:
    # 判断 goimports 是否安装
    @type "goimports" 2>&1 > /dev/null || echo "Please install goimports \$ go get golang.org/x/tools/cmd/goimports"

nginx:
	@sudo nginx -p `pwd` -c nginx.conf -s reload

push:
    @git commit -am "UPDATE $(TIME_NOW)" && git push origin master
```

[makefile](../Makefile ':include :type=code makefile')
