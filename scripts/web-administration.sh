#!/bin/bash

. ./conf.sh

git tag -a roboconf-web-administration-$VERSION_TO_RELEASE -m "The web administration used with Roboconf Platform $VERSION_TO_RELEASE"

CMD=--tags https://github.com/roboconf/roboconf-web-administration.git
if [ DRY_RUN == "true" ]; then
	CTX = "--dry-run $CTX"
fi

git push $CMD
