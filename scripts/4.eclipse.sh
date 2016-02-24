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
echo "Checking out the eclipse plugin..."
echo

DIR="$(localStagingDirectory ${ROBOCONF_ECLIPSE})"

mkdir -p "${DIR}" && cd "${DIR}"
ensureSuccess $? "Cannot create/access local staging directory: ${DIR}"

git clone "$(gitRepositoryUrl ${ROBOCONF_ECLIPSE})" "${DIR}"
ensureSuccess $? "Cannot clone project in ${DIR}"



echo
echo "Tagging the eclipse plugin..."
echo


# Use the last platform version
sed -i "s/>${RELEASE_VERSION}-SNAPSHOT/>${RELEASE_VERSION}/g" pom.xml

# Do not change the other versions, we will keep the qualifiers.
mvn clean verify
ensureSuccess $? "Failed to verify the eclipse plugin build"

TO_UPLOAD="to_upload"

mkdir -p "${TO_UPLOAD}" && cp repository/target/*.zip "${TO_UPLOAD}/"
ensureSuccess $? "Failed to copy repository files in ${TO_UPLOAD}"

# Create the tag
git tag -a -f "roboconf-eclipse-${RELEASE_VERSION}" -m "Eclipse tooling for Roboconf ${RELEASE_VERSION}"
ensureSuccess $? "Failed to tag eclipse plugin"



echo
echo "Bumping versions for next development iteration..."
echo

# Match with Eclipse versioning
# 0.4-SNAPSHOT => 0.4.0-SNAPSHOT
REPLACEMENT="${DEVELOPMENT_VERSION/-SNAPSHOT/}"

# Update the platform version
sed -i "s/<roboconf.platform.version>${RELEASE_VERSION}/<roboconf.platform.version>${DEVELOPMENT_VERSION}/g" pom.xml

# Update the other versions
for i in $(find . -type f -name pom.xml); do sed -i "s/>${RELEASE_VERSION}/>${REPLACEMENT}/g" $i; done

sed -i "s/Bundle-Version: ${RELEASE_VERSION}/Bundle-Version: ${REPLACEMENT}/g" plugins/net.roboconf.eclipse.plugin/META-INF/MANIFEST.MF
sed -i "s/\"${RELEASE_VERSION}/\"${REPLACEMENT}/g" features/net.roboconf.eclipse.feature/feature.xml
sed -i "s/\"${RELEASE_VERSION}/\"${REPLACEMENT}/g" repository/category.xml

git commit -a -m "Switching to the new development version"
ensureSuccess $? "Failed to commit for next development iteration"



echo
echo "Pushing tag & commit to origin..."
echo

if [[ "${DRY_RUN}" == "true" ]]; then
	git push --tags origin master --dry-run
else
  git push --tags origin master
fi
ensureSuccess $? "Failed to push tag and commit to origin"



echo
echo "Creating the version on Bintray..."
echo

curl -vvf -u${BINTRAY_USER}:${BINTRAY_API_KEY} -H "Content-Type: application/json" \
	-X POST ${BINTRAY_URL}/packages/roboconf/roboconf-eclipse/update-sites/versions \
	--data "{\"name\": \"${RELEASE_VERSION}\", \"github_use_tag_release_notes\": false }"
	
	
	
	
echo
echo "Uploading the plug-ins to Bintray..."
echo

for f in repository/target/*.zip
do
	echo "Uploading $f"
	curl -X PUT -T $f -u ${BINTRAY_USER}:${BINTRAY_API_KEY} \
		-H "X-Bintray-Package:update-sites" \
		-H "X-Bintray-Version:${RELEASE_VERSION}" \
		-H "X-Bintray-Explode:1" \
		${BINTRAY_URL}/content/roboconf/roboconf-eclipse/${RELEASE_VERSION}/
done



echo
echo "Please, visit https://bintray.com/roboconf/roboconf-eclipse/update-sites/${RELEASE_VERSION}/view to publish the uploaded files."
echo
