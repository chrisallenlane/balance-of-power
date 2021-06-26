#!/bin/sh

# NB: this appears more complex than necessary at a glance, but this behavior
# is intentional. `lua-format -i` updates a file's timestamp **regardless of
# whether that file needed to be formatted**. As such, it will cause `make
# minify` to minify all files on each build.
#
# By performing a `--check` before running `lua-format`, we can ensure that we
# only touch the timestamps of files that truly must be rebuilt.
for f in `find scripts src test -iname "*.lua" -type f`
do
	if ! lua-format --check $f; then
		lua-format -i $f
	fi
done
