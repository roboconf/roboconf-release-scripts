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
echo "Copying & updating user guide (EN)..."
echo

USER_GUIDE_DIR="en/user-guide-${RELEASE_VERSION}"
if [[ -d "${USER_GUIDE_DIR}" ]]; then
	ensureSuccess 1 "User guide ${RELEASE_VERSION} already exists."
fi

cp -R en/user-guide "${USER_GUIDE_DIR}" && cd "${USER_GUIDE_DIR}"
ensureSuccess $? "Failed to copy user guide to ${USER_GUIDE_DIR}" 

# Update the page IDs
DOC_ID="${RELEASE_VERSION/\./-}"

sed -i "s/ug-snapshot/ug-${DOC_ID}/g" *.md
sed -i "s/\"user-guide\"/\"user-guide\", \"${RELEASE_VERSION}\"/g" *.md



echo
echo "Copying & updating user guide (FR)..."
echo

# Do the same for the French user guide...
# ... except we do not deal with guides translations for the moment.
cd ../..
USER_GUIDE_DIR="fr/guide-utilisateur-${RELEASE_VERSION}"

cp -R fr/guide-utilisateur-0.1 "${USER_GUIDE_DIR}" && cd "${USER_GUIDE_DIR}"
ensureSuccess $? "Failed to copy user guide to ${USER_GUIDE_DIR}" 

# Update the page IDs
sed -i "s/ug-0-1/ug-${DOC_ID}/g" *.md
sed -i "s/0\.1/${RELEASE_VERSION}/g" *.md



echo
echo "Updating site layout..."
echo


# Deal with internationalization of the URLs
cd ../../_data
cp ug-snapshot.yml "ug-${DOC_ID}.yml"

sed -i "s/Guide Snapshot/Guide Version ${RELEASE_VERSION}/g" "ug-${DOC_ID}.yml"
sed -i "s/\//-${RELEASE_VERSION}\//g" "ug-${DOC_ID}.yml"

# Remove some French entries since guides are not yet translated
sed -i '/tutoriel/d' "ug-${DOC_ID}.yml"
sed -i '/presentations-reutilisables/d' "ug-${DOC_ID}.yml"



# This is not complete!
echo
echo "Please, review the web site and add a link to the newly released user guide."
echo "Commit is not automatic, you will have to do it yourself."
echo
