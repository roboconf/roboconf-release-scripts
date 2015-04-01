#!/bin/bash

. ./conf.sh

cd $ROOT_DIR/roboconf-platform
echo "Releasing the platform..."

# Release:clean
mvn clean
mvn release:clean

# Release:prepare
CMD="release:prepare -B -DreleaseVersion=$VERSION_TO_RELEASE -DdevelopmentVersion=$NEW_VERSION"
if [ $DRY_RUN == "true" ]; then
	CMD="$CMD -DdryRun=true"
fi

mvn $CMD

# Release:perform
CMD="release:perform -B"
if [ $DRY_RUN == "true" ]; then
	CMD="$CMD -DdryRun=true"
fi

mvn $CMD
