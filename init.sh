#!/bin/bash

SCRIPTPATH=`dirname $0`

git submodule update --init --recursive

command -v ruby >/dev/null 2>&1 || { echo >&2 "I require ruby but it's not installed.  Aborting."; exit 1; }
command -v make >/dev/null 2>&1 || { echo >&2 "I require make but it's not installed.  Aborting."; exit 1; }
command -v npm >/dev/null 2>&1 || { echo >&2 "I require npm but it's not installed.  Aborting."; exit 1; }

cd ~/.vim/bundle/command-t/ruby/command-t && if [ ! -e Makefile ]; then
	ruby extconf.rb &&
	make
fi

echo "Done!"
