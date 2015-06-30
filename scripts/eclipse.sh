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
sed -i "s/${RELEASE_VERSION}-SNAPSHOT/${RELEASE_VERSION}/g" pom.xml

# Do not change the other versions, we will keep the qualifiers.
mvn clean verify
ensureSuccess $? "Failed to verify the eclipse plugin build"

TO_UPLOAD="target/to_upload"

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
sed -i "s/${RELEASE_VERSION}/${REPLACEMENT}/g" pom.xml
sed -i "s/${RELEASE_VERSION}/${REPLACEMENT}/g" **/pom.xml
sed -i "s/${RELEASE_VERSION}/${REPLACEMENT}/g" features/net.roboconf.eclipse.feature/feature.xml
sed -i "s/${RELEASE_VERSION}/${REPLACEMENT}/g" plugins/net.roboconf.eclipse.plugin/META-INF/MANIFEST.MF
sed -i "s/${RELEASE_VERSION}/${REPLACEMENT}/g" repository/category.xml

git commit -a -m "Switching to the new development version"
ensureSuccess $? "Failed to commit for next development iteration"



echo
echo "Pushing tag & commit to origin..."
echo

ARGS=""
if [[ "${DRY_RUN}" == "true" ]]; then
	ARGS="--dry-run"
fi
git push --tags origin master "${ARGS}"
ensureSuccess $? "Failed to push tag and commit to origin"



echo
echo "Upload the ZIP file to Bintray."
echo

# ?? TODO Automate ??
