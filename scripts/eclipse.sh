#!/bin/bash

. ./conf.sh

cd $ROOT_DIR/roboconf-eclipse
echo "Tagging the Eclipse plugin..."


# Use the last platform version
sed -i "s/$VERSION_TO_RELEASE-SNAPSHOT/$VERSION_TO_RELEASE/g" pom.xml

# Do not change the other versions, we will keep the qualifiers.
mvn clean verify
mkdir -p to_upload
rm -rf to_upload/*
cp repository/target/*.zip to_upload/


# Create the tag
git tag -a -f roboconf-eclipse-$VERSION_TO_RELEASE -m "Eclipse tooling for Roboconf $VERSION_TO_RELEASE"


# Match with Eclipse versioning
# 0.4-SNAPSHOT => 0.4.0-SNAPSHOT
REPLACEMENT=${NEW_VERSION/-SNAPSHOT/}

# Update the platform version
sed -i "s/<roboconf.platform.version>$VERSION_TO_RELEASE/<roboconf.platform.version>$NEW_VERSION/g" pom.xml

# Update the other versions
sed -i "s/$VERSION_TO_RELEASE/$REPLACEMENT/g" pom.xml
sed -i "s/$VERSION_TO_RELEASE/$REPLACEMENT/g" **/pom.xml
sed -i "s/$VERSION_TO_RELEASE/$REPLACEMENT/g" features/net.roboconf.eclipse.feature/feature.xml
sed -i "s/$VERSION_TO_RELEASE/$REPLACEMENT/g" plugins/net.roboconf.eclipse.plugin/META-INF/MANIFEST.MF
sed -i "s/$VERSION_TO_RELEASE/$REPLACEMENT/g" repository/category.xml

git commit -a -m "Switching to the new development version"
git push --tags origin master

echo "Upload the ZIP file to Bintray."
