#!/usr/bin/make -f

TIME_NOW=$$(date +"%Y-%m-%d %H:%M.%S")

.PHONY: push
push:
	@git commit -am "UPDATE $(TIME_NOW)" && git push origin master

preview:
	@python3 -m http.server --bind 0.0.0.0 4000

commit:
	@read -p "commit: " && git commit -am "$$REPLY"