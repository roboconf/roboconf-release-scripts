#!/bin/bash

. ./conf.sh

git tag -a roboconf-examples-$VERSION_TO_RELEASE -m "Examples for Roboconf $VERSION_TO_RELEASE"

CMD=--tags https://github.com/roboconf/roboconf-examples.git
if [ DRY_RUN == "true" ]; then
	CTX = "--dry-run $CTX"
fi

git push $CMD
