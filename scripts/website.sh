#!/bin/bash

# Copyright 2014-2015 Linagora, Université Joseph Fourier, Floralis
#
# The present code is developed in the scope of the joint LINAGORA - Université
# Joseph Fourier - Floralis research program and is designated as a "Result"
# pursuant to the terms and conditions of the LINAGORA - Université Joseph
# Fourier - Floralis research program. Each copyright holder of Results
# enumerated here above fully & independently holds complete ownership of the
# complete Intellectual Property rights applicable to the whole of said Results,
# and may freely exploit it in any manner which does not infringe the moral
# rights of the other copyright holders.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.



# Import the commons.
source common.sh



echo
echo "Checking out the website..."
echo

DIR="$(localStagingDirectory ${ROBOCONF_WEBSITE})"

mkdir -p "${DIR}" && cd "${DIR}"
ensureSuccess $? "Cannot create/access local staging directory: ${DIR}"

git clone "$(gitRepositoryUrl ${ROBOCONF_WEBSITE})" "${DIR}"
ensureSuccess $? "Cannot clone project in ${DIR}"


echo
echo "Archiving the current user guide (EN)..."
echo

USER_GUIDE_DIR="en/user-guide-${PREVIOUS_VERSION}"
if [[ -d "${USER_GUIDE_DIR}" ]]; then
	ensureSuccess 1 "User guide ${PREVIOUS_VERSION} already exists."
fi

mv en/user-guide "${USER_GUIDE_DIR}" && cd "${USER_GUIDE_DIR}"
ensureSuccess $? "Failed to archive the user guide in ${USER_GUIDE_DIR}"

# Update the page IDs
DOC_ID="${PREVIOUS_VERSION/\./-}"

sed -i "s/ug-last/ug-${DOC_ID}/g" *.md
sed -i "s/\"user-guide\"/\"user-guide\", \"${PREVIOUS_VERSION}\"/g" *.md

# Remove the links to other user guides.
# Only the last and the snapshot ones should list them.
# We delete all the lines between <!-- TRWWR --> and <!-- TRWWR -->
sed -i "/<!-- TRWWR -->/,/<!-- TRWWR -->/d" user-guide.md



echo
echo "Adding a link to the newly archived user guide..."
echo

cd ../user-guide-snapshot
sed -i "s/<!-- RELEASE_MARKER -->/<!-- RELEASE_MARKER -->\n\t<li><a href=\"..\/user-guide-${PREVIOUS_VERSION}\/user-guide.html\">User Guide for version ${PREVIOUS_VERSION}<\/a><\/li>/g" user-guide.md



echo
echo "Copying & updating the snapshot user guide (EN)..."
echo

cd ../..
USER_GUIDE_DIR="en/user-guide"
if [[ -d "${USER_GUIDE_DIR}" ]]; then
	ensureSuccess 1 "User guide ${RELEASE_VERSION} already exists."
fi

cp -R en/user-guide-snapshot "${USER_GUIDE_DIR}" && cd "${USER_GUIDE_DIR}"
ensureSuccess $? "Failed to copy the snapshot user guide to ${USER_GUIDE_DIR}"

# Update the page IDs
sed -i "s/ug-snapshot/ug-last/g" *.md
sed -i "s/\"user-guide\", \"Snapshot\"/\"user-guide\"/g" *.md

# Update the introduction text of the new user guide.
sed -i "s/This is the user guide for the version under development./This is the user guide for Roboconf ${RELEASE_VERSION}./g" user-guide.md



echo
echo "Create an archive page for the previous user guide (FR)..."
echo

# Do the same for the French user guide...
# ... except we do not deal with guides translations for the moment.
cd ../..
USER_GUIDE_DIR="fr/guide-utilisateur-${PREVIOUS_VERSION}"

cp -R fr/guide-utilisateur-0.1 "${USER_GUIDE_DIR}" && cd "${USER_GUIDE_DIR}"
ensureSuccess $? "Failed to copy user guide to ${USER_GUIDE_DIR}" 

# Update the page IDs
sed -i "s/ug-0-1/ug-${DOC_ID}/g" *.md
sed -i "s/0\.1/${PREVIOUS_VERSION}/g" *.md



echo
echo "Updating the site layout..."
echo

# Deal with internationalization of the URLs
# Last -> Archived
cd ../../_data
sed -i "s/\//-${PREVIOUS_VERSION}\//g" ug-last.yml

mv ug-last.yml "ug-${DOC_ID}.yml"

# Snapshot -> Last
cp ug-snapshot.yml "ug-last.yml"
sed -i "s/Guide Snapshot/Guide Version ${RELEASE_VERSION}/g" ug-last.yml
sed -i "s/-snapshot\//\//g" ug-last.yml

# Remove some French entries since guides are not yet translated
DOC_ID="${RELEASE_VERSION/\./-}"
sed -i '/tutoriel/d' "ug-last.yml"
sed -i '/presentations-reutilisables/d' ug-last.yml



# This is not complete!
echo
echo "Please, review the web site."
echo
echo "  (x) In the download pages: update the links to the user guide for version ${PREVIOUS_VERSION}."
echo "  (x) Verify there is a New & Noteworthy page for the new release."
echo "  (x) Update the download pages for the new version."
echo
echo "Commit is not automatic, you will have to do it yourself."
echo
