#!/bin/bash

# Copyright 2014-2016 Linagora, Université Joseph Fourier, Floralis
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
echo "Verifying CURL is installed..."
echo

curl --version



echo
echo "Checking out the system installers..."
echo

DIR="$(localStagingDirectory ${ROBOCONF_SYSTEM_INSTALLERS})"

mkdir -p "${DIR}" && cd "${DIR}"
ensureSuccess $? "Cannot create/access local staging directory: ${DIR}"

git clone "$(gitRepositoryUrl ${ROBOCONF_SYSTEM_INSTALLERS})" "${DIR}"
ensureSuccess $? "Cannot clone project in ${DIR}"



echo
echo "Bump versions for release..."
echo

mvn versions:set -DnewVersion="${RELEASE_VERSION}" -DgenerateBackupPoms=false
ensureSuccess $? "Failed to bump versions for release"

mvn clean verify
ensureSuccess $? "Failed to verify the system installers build"

git commit -a -m "Roboconf system installers ${RELEASE_VERSION}"
ensureSuccess $? "Failed to commit the released system installers"



echo
echo "Tagging the system installers..."
echo


TO_UPLOAD="to_upload"

mkdir -p "${TO_UPLOAD}" && cp roboconf-dist-debian-agent/target/*.deb roboconf-dist-debian-dm/target/*.deb "${TO_UPLOAD}/"
ensureSuccess $? "Failed to copy Deb packages in ${TO_UPLOAD}"

# Create the tag
git tag -a -f "roboconf-system-installers-${RELEASE_VERSION}" -m "Roboconf system installers ${RELEASE_VERSION}"
ensureSuccess $? "Failed to tag system installers"



echo
echo "Bumping versions for next development iteration..."
echo

mvn versions:set -DnewVersion="${DEVELOPMENT_VERSION}" -DgenerateBackupPoms=false
ensureSuccess $? "Failed to bump versions for next development iteration"

git commit -a -m "Switching to the new development version"
ensureSuccess $? "Failed to commit for next development iteration"



echo
echo "Pushing tag & commit to origin..."
echo

if [[ "${DRY_RUN}" == "true" ]]; then
	git push --dry-run --tags origin master
else
  git push --tags origin master
fi

ensureSuccess $? "Failed to push tag and commit to origin"



echo
echo "Updating the package names for Bintray..."
echo

find -name "*+*.deb" -type f | rename 's/\+/_/g'



echo
echo "Creating the version on Bintray..."
echo

curl -vvf -u${BINTRAY_USER}:${BINTRAY_API_KEY} -H "Content-Type: application/json" \
	-X POST ${BINTRAY_URL}/packages/roboconf/roboconf-debian-packages/main/versions \
	--data "{\"name\": \"${RELEASE_VERSION}\", \"github_use_tag_release_notes\": false }"



echo
echo "Uploading the DEB files to Bintray..."
echo

for f in $(find -name "*.deb" -type f)
do
	echo "Uploading $f"
	curl -X PUT -T $f -u ${BINTRAY_USER}:${BINTRAY_API_KEY} \
		-H "X-Bintray-Debian-Distribution:jessie" \
		-H "X-Bintray-Debian-Component:main" \
		-H "X-Bintray-Debian-Architecture:i386,amd64" \
		${BINTRAY_URL}/content/roboconf/roboconf-debian-packages/main/${RELEASE_VERSION}/
done



echo
echo "Please, visit https://bintray.com/roboconf/roboconf-debian-packages/main/${RELEASE_VERSION}/view to publish the uploaded files."
echo
