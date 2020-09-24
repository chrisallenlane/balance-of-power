FROM alpine:3.7

ARG LUA_FMT="https://github.com/Koihik/LuaFormatter.git"


WORKDIR /app

RUN apk add git

RUN cd /tmp && \
  git clone --recurse-submodules $LUA_FMT --depth=1

# install dependencies
RUN apk add  \
  build-base \
  cmake      \
  g++        \
  gcc        \
  libc-dev   \
  lua5.2     \
  luacheck   \
  linux-vanilla   \
  linux-vanilla-dev   \
  make       \
  musl-dev

  #git        \

# build the lua formatter
#RUN cd /tmp &&                                           \
  #git clone --recurse-submodules $LUA_FMT --depth=1 && \
  #cd LuaFormatter &&                                     \
  #cmake . &&                                             \
  #make &&                                                \
  #make install

RUN cd /tmp/LuaFormatter && \
  cmake . &&                \
  make &&                   \
  make install
