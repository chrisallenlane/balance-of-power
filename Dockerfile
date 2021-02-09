FROM ubuntu:20.04

# lua-format repo
ARG LUA_FMT="https://github.com/Koihik/LuaFormatter.git"

# set the timezone
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install build dependencies
RUN apt-get update         && \
		apt-get install --yes \
		build-essential       \
		ca-certificates       \
		cmake                 \
		gcc                   \
		git                   \
		golang                \
		lcov                  \
		liblua5.2-dev         \
		lua5.2                \
		luarocks

# install luarocks dependencies
RUN luarocks install busted   && \
	luarocks install cluacov  && \
	luarocks install luacheck && \
	luarocks install luacov-reporter-lcov

# install lua-format
# NB: don't try to do this via luarocks - dependency hell awaits
RUN cd /tmp                           && \
	git clone                            \
		--depth=1                        \
		--recurse-submodules $LUA_FMT && \
	cd LuaFormatter                   && \
	cmake .                           && \
	make                              && \
	make install

# install go tooling
RUN go get -u github.com/boyter/scc

# uninstall build dependencies
# NB: don't uninstall `gcc`. It will also remove `lcov`.
RUN apt-get remove --yes        \
	build-essential             \
	cmake                       \
	git                         \
	golang                   && \
	rm -rf /tmp/LuaFormatter && \
	apt-get clean --yes      && \
	apt-get autoremove --yes

# create an directory for mounting the application
WORKDIR /app
