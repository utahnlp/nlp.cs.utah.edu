#!/bin/bash
set -e

# This script is meant to be run automatically
# as part of the jekyll-hook application.
# https://github.com/developmentseed/jekyll-hook

branch=$1
giturl=$2
source=$3
build=$4

# Check to see if repo exists. If not, git clone it
if [ ! -d $source ]; then
    git clone $giturl $source
fi

# Git checkout appropriate branch, pull latest code
cd $source
git checkout $branch
git pull origin $branch
cd -

# Run jekyll
cd $source
rvm use ruby-2.4.1
[ -f Gemfile ] && (bundle check || bundle install)
jekyll build -s $source -d $build
cd -
