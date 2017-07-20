#!/bin/sh

git stash save
git clean -df
yes | pulp publish --no-push
git stash pop
