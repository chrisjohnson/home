#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

git submodule update --init --recursive

command -v ruby >/dev/null 2>&1 || { echo >&2 "I require ruby but it's not installed.  Aborting."; exit 1; }
command -v make >/dev/null 2>&1 || { echo >&2 "I require make but it's not installed.  Aborting."; exit 1; }
command -v npm >/dev/null 2>&1 || { echo >&2 "I require npm but it's not installed.  Aborting."; exit 1; }

cd ~/.vim/bundle/command-t/ruby/command-t && if [ ! -e Makefile ]; then
	ruby extconf.rb &&
	make
fi

cd ~/.vim/bundle/tern_for_vim.git &&
	npm install

cd $SCRIPTPATH &&
	node -e "require.resolve('jsctags')" 2>/dev/null || npm install git://github.com/ramitos/jsctags.git &&
	echo $PATH | grep -qv jsctags &&
		echo "Add $SCRIPTPATH/node_modules/jsctags/bin to your PATH"

echo "Done!"
