#!/bin/bash

cd ~/.vim/bundle/command-t/ruby/command-t
ruby extconf.rb
make

cd ~/.vim/bundles/tern_for_vim.git
npm install
