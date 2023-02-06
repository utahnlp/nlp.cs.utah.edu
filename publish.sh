#!/bin/bash -e

if [[ "$#" -ne 1 ]]; then
    echo "Usage: publish.sh <username>"
    exit 1
fi

USER=$1

jekyll build

rsync -azP \
      --delete \
      --chmod=Du=rwx,Dg=rwx,Do=rx,Fu=rw,Fg=rw,Fo=rx \
      _site/ $USER@shell.cs.utah.edu:/uusoc/res/nlp/public_html/
