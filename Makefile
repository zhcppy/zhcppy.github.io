#!/usr/bin/make -f

TIME_NOW=$$(date +"%Y-%m-%d %H:%M.%S")

# push:
# 	@git commit -am "UPDATE $(TIME_NOW)" && git push origin master
.PHONY: push
msg=$$(sed -n "$$(($$RANDOM%6521))p" .motto)
push:
	@git commit -m "$(msg)" && git push origin master

preview:
	@which python3 && python3 -m http.server --bind 0.0.0.0 4000 \
	|| which python && python -m SimpleHTTPServer 4000

commit:
	@read -p "commit: " && git commit -am "$$REPLY"