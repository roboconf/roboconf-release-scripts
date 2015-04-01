#!/bin/bash

. ./conf.sh

cd $ROOT_DIR/roboconf-web-administration
echo "Tagging the web administration..."

CMD="--tags origin"
if [ $DRY_RUN == "true" ]; then
	CMD="--dry-run $CMD"
else
	git tag -a -f roboconf-web-administration-$VERSION_TO_RELEASE -m "The web administration used with Roboconf Platform $VERSION_TO_RELEASE"
fi

git push $CMD
