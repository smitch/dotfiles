#!/bin/bash

TARGET=".zshrc .emacs.d .screenrc .gitconfig"
FILE_DIR=$(cd $(dirname $0); pwd)
echo "original files are in $FILE_DIR"

for f in $TARGET; do
  echo make symbolic link of $f
  ln -snfv $FILE_DIR/$f ~/
done

echo dotfiles install finished!
