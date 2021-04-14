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
LUAMIN   := luamin
MKDIR    := mkdir -p
SCC      := /root/go/bin/scc
SED      := sed
SORT     := sort

# files (used for minification
lua_src := $(wildcard ./src/*.lua)
lua_min := $(lua_src:./src/%.lua=./build/%.lua)

# vars
docker_image := bop

## setup: build the docker container and link source files into the cartridge
.PHONY: setup
setup: inc
	$(DOCKER) build -t $(docker_image) -f Dockerfile .

# create the `build` directory for storing minified source files
build:
	mkdir -p build

## minify: minify source files
.PHONY: minify
minify: build $(lua_min)
$(lua_min): %:
	$(DOCKER) run -tv $(realpath .):/app $(docker_image) \
		bash -c '$(LUAMIN) -f src/$(notdir $@) > $@'

## fast: format and lint
.PHONY: fast
fast: | fmt lint build-stages minify

## check: format, lint, and test
.PHONY: check
check: | fmt lint build-stages test minify

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
		$(LUACHECK) scripts/*.lua src/*.lua test/*.lua --formatter=plain --no-color --quiet

## fmt: format files
.PHONY: fmt
fmt:
	$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		$(LUAFMT) -i scripts/*.lua src/*.lua test/*.lua

## sloc: count "semantic lines of code"
.PHONY: sloc
sloc:
	$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		$(SCC) --exclude-dir=vendor --count-as p8:lua

## clean: remove coverage report files
.PHONY: clean
clean:
	@rm -f $(REPORT_FILE) $(STATS_FILE)

## clean-all: remove coverage report and minified files
.PHONY: clean-all
clean-all: clean
	@rm -f build/*

## distclean: remove the docker container
.PHONY: distclean
distclean:
	$(DOCKER) image rm $(docker_image) --force

# by default, link development files into the cartridge
inc: link-dev

## link-dev: link development source files into cartridge
.PHONY: link-dev
link-dev:
	rm -f inc && ln -s src inc

## link-release: link release (minified) source files into cartridge
.PHONY: link-release
link-release: minify
	rm -f inc && ln -s build inc

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

## build-stages: serialize stage data
build-stages:
	$(DOCKER) run -v $(realpath .):/app -ti $(docker_image) \
		$(LUA) scripts/build-stages.lua > build/stages.lua

## help: display this help text
help:
	@$(CAT) $(makefile) | \
	$(SORT)             | \
	$(GREP) "^##"       | \
	$(SED) 's/## //g'   | \
	$(COLUMN) -t -s ':'
