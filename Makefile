makefile := $(realpath $(lastword $(MAKEFILE_LIST)))

# executable paths
CAT      := cat
COLUMN   := column
DOCKER   := docker
GREP     := grep
LUA      := lua5.2
LUACHECK := luacheck
LUAFMT   := lua-format
SCC      := /root/go/bin/scc
SED      := sed
SORT     := sort

# vars
docker_image := bop

## setup: build the docker container
.PHONY: setup
setup:
	$(DOCKER) build -t $(docker_image) -f ./Dockerfile .

## check: format, lint, and test
.PHONY: check
check: | fmt lint test

## test: run unit-tests
.PHONY: test
test:
	$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		$(LUA) ./test/example.lua

## lint: lint files
.PHONY: lint
lint:
	$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		$(LUACHECK) src/* --formatter=plain --no-color --quiet

## fmt: format files
.PHONY: fmt
fmt:
	$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		$(LUAFMT) -i src/* test/*

## sloc: count "semantic lines of code"
.PHONY: sloc
sloc:
	$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		$(SCC) --exclude-dir=vendor --count-as p8:lua

## distclean: remove the docker container
.PHONY: distclean
distclean:
	$(DOCKER) image rm $(docker_image) --force

## sh: spawn an bash shell inside the docker container
.PHONY: sh
sh:
	$(DOCKER) run -v $(realpath .):/app -ti $(docker_image) /bin/bash || true

## lua: open a lua REPL within the docker container (exit with `os.exit()`)
.PHONY: lua
lua:
	$(DOCKER) run -v $(realpath .):/app -ti $(docker_image) $(LUA)

## help: display this help text
help:
	@$(CAT) $(makefile) | \
	$(SORT)             | \
	$(GREP) "^##"       | \
	$(SED) 's/## //g'   | \
	$(COLUMN) -t -s ':'
