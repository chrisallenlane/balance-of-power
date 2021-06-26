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

# asset paths
BUILD_DIR  := build
DIST_DIR   := dist
EXPORT_DIR := balance-of-power.bin

# executable paths
BROWSER  := sensible-browser
CAT      := cat
COLUMN   := column
DOCKER   := docker
GREP     := grep
LUA      := lua5.2
MKDIR    := mkdir -p
MV       := mv
PICO8    := pico8
RMDIR    := rm -rf 
SCC      := /root/go/bin/scc
SED      := sed
SH       := /bin/ash
SORT     := sort

# files (used for minification
lua_src := $(wildcard ./src/*.lua)
lua_min := $(lua_src:./src/%.lua=./build/%.lua)

# vars
docker_image := bop-build

## setup: build the docker container and link source files into the cartridge
.PHONY: setup
setup:
	$(DOCKER) build -t $(docker_image) -f Dockerfile .

## fast: format and lint
.PHONY: fast
fast: | fmt lint minify build-stages
	@echo 'done.'

## check: format, lint, and test
.PHONY: check
check: | fmt lint test
	@echo 'done.'

## minify: minify source files
.PHONY: minify
minify: $(BUILD_DIR) $(lua_min)
build/%.lua: src/%.lua
	@echo "minify: $@" && \
	$(DOCKER) run -tv $(realpath .):/app $(docker_image) \
		$(SH) -c 'luamin -f src/$(notdir $@) > $@'

## test: run unit-tests
.PHONY: test
test: $(COVER_DIR) 
	@$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		$(SH) -c 'busted --coverage test/*'

## build-doc: build project documentation
.PHONY: build-doc
build-doc:
	$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		$(SH) -c 'ldoc .'

## doc: build project documentation, and view it in a browser
.PHONY: doc
doc: build-doc
	$(BROWSER) doc/index.html

## cover: generate a test coverage report
.PHONY: cover
cover: test
	@echo 'generating coverage report...' && \
		$(DOCKER) run -v $(realpath .):/app $(docker_image) \
			$(SH) -c 'luacov -r lcov && genhtml $(REPORT_FILE) -o $(COVER_DIR)' && \
		$(BROWSER) $(COVER_REPORT)

## lint: lint files
.PHONY: lint
lint:
	@echo 'running luacheck...' && \
	$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		luacheck scripts/*.lua src/*.lua test/*.lua --formatter=plain --no-color --quiet

## fmt: format files
.PHONY: fmt
fmt:
	@echo "running lua-format..." && \
	$(DOCKER) run -v $(realpath .):/app $(docker_image) scripts/fmt.sh

## sloc: count "semantic lines of code"
.PHONY: sloc
sloc:
	@$(DOCKER) run -v $(realpath .):/app $(docker_image) \
		$(SCC) --exclude-dir=vendor --count-as p8:lua

## clean: remove distributions and coverage report
.PHONY: clean
clean:
	@$(RMDIR) $(DIST_DIR)/* $(BUILD_DIR)/* $(REPORT_FILE) $(STATS_FILE)

## distclean: remove the docker container
.PHONY: distclean
distclean:
	@echo 'removing $(docker_image) docker image...' && \
	$(DOCKER) image rm $(docker_image) --force

## install: link cartridge into Pico-8 environment
.PHONY: install
install:
	ln -sf $(CART_LOCAL) $(CART_PICO)

## uninstall: unlink cartridge from Pico-8 environment
.PHONY: uninstall
uninstall:
	rm $(CART_PICO)

## sh: spawn a shell inside the docker container
.PHONY: sh
sh:
	$(DOCKER) run -v $(realpath .):/app -ti $(docker_image) $(SH) || true

## lua: open a lua REPL within the docker container (exit with `os.exit()`)
.PHONY: lua
lua:
	$(DOCKER) run -v $(realpath .):/app -ti $(docker_image) $(LUA)

## build-release: build release versions of the game
.PHONY: build-release
build-release: $(DIST_DIR) build-stages check
	$(PICO8) balance-of-power.p8 \
		-export "$(EXPORT_DIR) -i 0 -s 1 -c 1" && \
	$(MV) $(EXPORT_DIR)/*.zip dist/ && \
	$(RMDIR) $(EXPORT_DIR)

# create the `build` directory for storing minified source files
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

## build-stages: serialize stage data
build-stages:
	@echo 'building stages...' && \
	$(DOCKER) run -v $(realpath .):/app -ti $(docker_image) \
		$(LUA) scripts/build-stages.lua > build/stages.lua

# create the coverage directory
$(COVER_DIR):
	@$(MKDIR) $(COVER_DIR)

# create `dist` directory
$(DIST_DIR):
	$(MKDIR) $(DIST_DIR)

## help: display this help text
help:
	@$(CAT) $(makefile) | \
	$(SORT)             | \
	$(GREP) "^##"       | \
	$(SED) 's/## //g'   | \
	$(COLUMN) -t -s ':'
