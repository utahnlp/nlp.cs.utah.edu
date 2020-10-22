#!/bin/bash
JEKYLL_ENV=production bundle exec jekyll build -d _deploy
cd _deploy
git add --all --verbose
git commit -m `date "+%Y%m%d%H%M%S"`
git push origin deploy
cd ..
echo 'Site in _deploy deployed!'
