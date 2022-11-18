#!/bin/bash

DIR=$(dirname "$0")
cd $DIR/..

if [ "$1" != "--force" ]; then
	if [[ $(git status -s) ]]; then
		echo "The working directory is dirty. Please commit any pending changes."
		exit 1;
	fi
fi

echo "Deleting old publication"
rm -rf public/
mkdir public/
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public #origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
#hugo
#~/code/gopath/bin/hugo
./bin/hugo

echo "purpleidea.com" > public/CNAME

echo "Updating gh-pages branch"
cd public && git add . && git commit -m "hugo: Publishing new site via publish.sh" && cd -

echo "Pushing to public branch"
git push origin gh-pages --force
