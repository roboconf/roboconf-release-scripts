#!/bin/bash

. ./conf.sh

cd $ROOT_DIR/roboconf-examples
echo "Tagging the examples..."


# Update the version in the POM
if [ $DRY_RUN != "true" ]; then
	mvn versions:set -DnewVersion=$VERSION_TO_RELEASE -DgenerateBackupPoms=false
	mvn verify
	git commit -a -m "Using the newly released Roboconf version"
fi


# Tag
CMD="--tags origin"
if [ $DRY_RUN == "true" ]; then
	CMD="--dry-run $CMD"
else
	git tag -a -f roboconf-examples-$VERSION_TO_RELEASE -m "Examples for Roboconf $VERSION_TO_RELEASE"
fi

git push $CMD


# Switch to the new development version
if [ $DRY_RUN != "true" ]; then
	mvn versions:set -DnewVersion=$NEW_VERSION -DgenerateBackupPoms=false
	git commit -a -m "Switching to the new development version"
	git push origin
fi
