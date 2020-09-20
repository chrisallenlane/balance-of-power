FROM alpine:3.7

WORKDIR /app

RUN apk add lua5.2 luacheck
