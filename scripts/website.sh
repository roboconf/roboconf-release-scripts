#!/bin/bash

. ./conf.sh

cp en/user-guide en/uder-guide-$VERSION_TO_RELEASE

# Update the page IDs
sed -i "s/\.snapshot\./\.$VERSION_TO_RELEASE\./g" en/uder-guide-$VERSION_TO_RELEASE/*.md
sed -i "s/\"user-guide\"/\"user-guide\", \"$VERSION_TO_RELEASE\"/g" en/uder-guide-$VERSION_TO_RELEASE/*.md

# Externalize identifiers from the config.yml file
# See http://roboconf.net/en/developer-guide/documenting-a-new-version.html
