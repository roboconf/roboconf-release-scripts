#!/bin/bash

. ./conf.sh

cd $ROOT_DIR/roboconf.github.io
echo "Updating the web site..."


# Copy the user guide
DIRECTORY=en/user-guide-$VERSION_TO_RELEASE
if [ -d "$DIRECTORY" ]; then
	echo "User guide $VERSION_TO_RELEASE already exists. Exiting..."
	exit 1
fi

cp -R en/user-guide $DIRECTORY
cd $DIRECTORY


# Update the page IDs
DOC_ID=${VERSION_TO_RELEASE/\./-}

sed -i "s/ug-snapshot/ug-$DOC_ID/g" *.md
sed -i "s/\"user-guide\"/\"user-guide\", \"$VERSION_TO_RELEASE\"/g" *.md
echo "The English user guide has been updated."


# Do the same for the French user guide...
# ... except we do not deal with guides translations for the moment.
cd ../..
DIRECTORY=fr/guide-utilisateur-$VERSION_TO_RELEASE

cp -R fr/guide-utilisateur-0.1 $DIRECTORY
cd $DIRECTORY

sed -i "s/ug-0-1/ug-$DOC_ID/g" *.md
sed -i "s/0\.1/$VERSION_TO_RELEASE/g" *.md
echo "The French user guide has been updated."


# Deal with internationalization of the URLs
cd ../../_data
cp ug-snapshot.yml ug-$DOC_ID.yml

sed -i "s/Guide Snapshot/Guide Version $VERSION_TO_RELEASE/g" ug-$DOC_ID.yml
sed -i "s/\//-$VERSION_TO_RELEASE\//g" ug-$DOC_ID.yml

# Remove some French entries since guides are not yet translated
sed -i '/tutoriel/d' ug-$DOC_ID.yml
sed -i '/presentations-reutilisables/d' ug-$DOC_ID.yml


# This is not complete!
echo ""
echo "Please, review the web site and add a link to the newly released user guide."
echo "Commit is not automatic, you will have to do it yourself."
