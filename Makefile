CWD := $(shell pwd)
NAME := $(shell jq -r .name META6.json)
VERSION := $(shell jq -r .version META6.json)
ARCHIVENAME := $(subst ::,-,$(NAME))

check:
	git diff-index --check HEAD
	prove6
tag:
	git tag $(VERSION)
	git push origin --tags

dist:
	git archive --prefix=$(ARCHIVENAME)-$(VERSION)/ \
		-o ../$(ARCHIVENAME)-$(VERSION).tar.gz $(VERSION)

test-alpine:
	docker run --rm -t  \
	  -e RELEASE_TESTING=1 \
	  -v $(CWD):/test \
          --entrypoint="/bin/sh" \
	  jjmerelo/raku-test \
	  -c "echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && apk add --update --no-cache primesieve && zef install --/test --deps-only --test-depends . && zef -v test ."

test-debian:
	docker run --rm -t \
	  -e RELEASE_TESTING=1 \
	  -v $(CWD):/test -w /test \
          --entrypoint="/bin/sh" \
	  jjmerelo/rakudo-nostar \
	  -c "apt update && apt install -y libprimesieve && zef install --/test --deps-only --test-depends . && zef -v test ."

test: test-alpine test-debian
