FROM alpine:3.13

# lua-format repo
ARG LUA_FMT="https://github.com/Koihik/LuaFormatter.git"

# add system dependencies
RUN apk update && apk upgrade && \
  apk add --no-cache             \
		cmake      \
		g++        \
		git        \
		go         \
		lua5.2     \
		luarocks   \
		make       \
		nodejs     \
		npm        \
		perl       \
    lua5.2-dev \
    yaml-dev

# install luarocks dependencies
RUN luarocks-5.2 install busted             && \
	luarocks-5.2 install cluacov              && \
	luarocks-5.2 install ldoc                 && \
	luarocks-5.2 install luacheck             && \
	luarocks-5.2 install luacov-reporter-lcov && \
	luarocks-5.2 install luafilesystem        && \
	luarocks-5.2 install lyaml                && \
	luarocks-5.2 install penlight

# install lua-format
# NB: don't try to do this via luarocks - dependency hell awaits
RUN cd /tmp                       && \
	git clone                          \
		--depth=1                        \
		--shallow-submodules             \
		--recurse-submodules $LUA_FMT && \
  cd LuaFormatter                 && \
  cmake .                         && \
  make                            && \
  make install                    && \
  rm -rf /tmp/LuaFormatter

# install lcov
RUN cd /tmp && git clone https://github.com/linux-test-project/lcov.git && \
  cd /tmp/lcov/bin && \
  cp genhtml get_version.sh /usr/bin && \
  rm -rf /tmp/lcov

# install go tooling
RUN go get -u github.com/boyter/scc

# install luamin
RUN npm install -g luamin

# uninstall build dependencies
RUN apk del  \
  cmake      \
  g++        \
  git        \
  go         \
  lua5.2-dev \
  luarocks   \
  make       \
  npm

# create an directory for mounting the application
WORKDIR /app
