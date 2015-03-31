#!/bin/bash

. ./conf.sh

# Release:clean
mvn release:clean

# Release:prepare
CTX=release:prepare -B -DreleaseVersion=$VERSION_TO_RELEASE -DdevelopmentVersion=$NEW_VERSION
if [ DRY_RUN == "true" ]; then
	CTX = "$CTX -DdryRun=true"
fi

mvn $CTX

# Release:perform
CTX=release:perform -B
if [ DRY_RUN == "true" ]; then
	CTX = "$CTX -DdryRun=true"
fi

mvn $CTX
