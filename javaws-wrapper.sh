#!/bin/sh

prog="$0"
while [ -h "$prog" ]; do prog=$(readlink $prog); done
[ $# -eq 0 ] && set -- -viewer
exec $(dirname $prog)/javaws.real "$@"
