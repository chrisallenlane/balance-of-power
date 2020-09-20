makefile := $(realpath $(lastword $(MAKEFILE_LIST)))

# executable paths
CAT    := cat
COLUMN := column
DOCKER := docker
GREP   := grep
LUA    := lua5.2
SED    := sed
SORT   := sort

# vars
docker_image := bop

## setup: build the docker container
.PHONY: setup
setup:
	$(DOCKER) build -t $(docker_image) -f ./Dockerfile .

## test: run unit-tests
.PHONY: test
test:
	$(DOCKER) run -v $(realpath .):/app $(docker_image) $(LUA) \
		./test/example.lua

## distclean: remove the docker container
.PHONY: distclean
distclean:
	$(DOCKER) image rm $(docker_image) --force

## sh: spawn an ash shell inside the docker container
.PHONY: sh
sh:
	$(DOCKER) run -v $(realpath .):/app -ti $(docker_image) /bin/ash || true

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
