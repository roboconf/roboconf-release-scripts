#!/bin/bash

. ./conf.sh

mvn org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=$VERSION_TO_RELEASE
mvn clean verify
cp zip

git commit -a -m "prepare for release"
git tag v$VERSION_TO_RELEASE

mvn org.eclipse.tycho:tycho-versions-plugin:set-version -DnewVersion=$NEW_VERSION
mvn clean verify
git commit -a -m "increment to next development version"
git --tags push origin master

echo "Upload the ZIP file to Bintray."
