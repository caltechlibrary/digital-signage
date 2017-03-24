#
# Simple Makefile
#

PROJECT = digital-signage

BRANCH = $(shell git branch | grep "* " | cut -d\   -f 2)

build: 
	./mk-website.bash

status:
	git status

save:
	if [ "$(msg)" = "" ]; then git commit -am "Quick Save"; else git commit -am "$(msg)"; fi
	git push origin $(BRANCH)

refresh:
	git fetch origin 
	git pull origin $(BRANCH)

website:
	./mk-website.bash

publish:
	./mk-website.bash
	./publish.bash

