.DEFAULT_GOAL := fast

makefile := $(realpath $(lastword $(MAKEFILE_LIST)))

# cart paths
CARTS_PATH := ~/.lexaloffle/pico-8/carts
CART_PICO  := $(CARTS_PATH)/balance-of-power
CART_LOCAL := $(shell pwd)

# coverage paths
COVER_DIR    := ./coverage
COVER_REPORT := $(COVER_DIR)/index.html
REPORT_FILE  := $(COVER_DIR)/luacov.report.out
STATS_FILE   := $(COVER_DIR)/luacov.stats.out

# executable paths
BROWSER  := sensible-browser
CAT      := cat
COLUMN   := column
DOCKER   := docker
GREP     := grep
LUA      := lua5.2
LUACHECK := luacheck
LUAFMT   := lua-format
MKDIR    := mkdir -p
SCC      := /root/go/bin/scc
SED      := sed
SORT     := sort

# vars
docker_image := bop

## setup: build the docker container
.PHONY: setup
setup:
	$(DOCKER) build -t $(docker_image) -f ./Dockerfile .

## fast: format and lint
.PHONY: fast
fast: | fmt lint

## check: format, lint, and test
.PHONY: check
check: | fmt lint test

# create the coverage directory
$(COVER_DIR):
	@$(MKDIR) $(COVER_DIR)

## test: run unit-tests
.PHONY: test
test: clean $(COVER_DIR) 
	@$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		bash -c 'busted --coverage test/*'

## cover: generate a test coverage report
.PHONY: cover
cover: test
	@$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		bash -c 'luacov -r lcov && genhtml $(REPORT_FILE) -o $(COVER_DIR)' && \
		$(BROWSER) $(COVER_REPORT)

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

## clean: remove coverage files
.PHONY: clean
clean:
	@rm -f $(REPORT_FILE) $(STATS_FILE)

## distclean: remove the docker container
.PHONY: distclean
distclean:
	$(DOCKER) image rm $(docker_image) --force

## install: link cartridge into Pico-8 environment
.PHONY: install
install:
	ln -sf $(CART_LOCAL) $(CART_PICO)

## uninstall: unlink cartridge from Pico-8 environment
.PHONY: uninstall
uninstall:
	rm $(CART_PICO)

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
