#!/usr/bin/make -f

.PHONY: push preview commit http

TIME_NOW=$$(date +"%Y-%m-%d %H:%M.%S")

msg=$$(sed -n "$$(($$RANDOM%6521))p" .motto)
push:
	@git add .
	@git commit -m "$(msg)" && git push origin master

preview:
	@which python3 && python3 -m http.server --bind 0.0.0.0 4000 \
	|| which python && python -m SimpleHTTPServer 4000

commit:
	@read -p "commit: " && git commit -am "$$REPLY"

http:
	@http-server . -p 4000 || echo "Please Run 'npm install http-server -g' to Install"
