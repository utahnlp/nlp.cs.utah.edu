#!/bin/bash -e

if [[ "$#" -ne 1 ]]; then
    echo "Usage: publish.sh <username>"
    exit 1
fi

USER=$1

jekyll build

rsync -azP --delete _site/ $USER@shell.cs.utah.edu:~/nlp/public_html/
