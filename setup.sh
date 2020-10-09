#!/bin/bash
SOURCE_DIR=`dirname $(readlink -f ${BASH_SOURCE[0]})`
ln -s $SOURCE_DIR/fish ~/.config/
ln -s $SOURCE_DIR/bash_commands ~/.config/
echo "If using bash, run 'echo \"\\nsource ~/.config/bash_commands/loader.sh\\n\" >>~/.bashrc && source ~/.bashrc"
