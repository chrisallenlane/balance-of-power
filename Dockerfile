FROM ubuntu:20.04

# lua-format repo
ARG LUA_FMT="https://github.com/Koihik/LuaFormatter.git"

# set the timezone
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install build dependencies
RUN apt-get update       && \
  apt-get install           \
    --yes                   \
    --no-install-recommends \
      build-essential       \
      ca-certificates       \
      cmake                 \
      git                   \
      liblua5.2-dev         \
      lua5.2                \
      luarocks

# install luacheck
RUN luarocks install luacheck

# install lua-format
# NB: don't try to do this via luarocks - dependency hell awaits
RUN cd /tmp                       && \
  git clone                          \
    --depth=1                        \
    --recurse-submodules $LUA_FMT && \
  cd LuaFormatter                 && \
  cmake .                         && \
  make                            && \
  make install

# uninstall build dependencies
RUN apt-get remove --yes      \
  build-essential             \
  cmake                       \
  git                      && \
  rm -rf /tmp/LuaFormatter && \
  apt-get clean --yes      && \
  apt-get autoremove --yes

# create an directory for mounting the application
WORKDIR /app
