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
echo "Checking out the platform..."
echo

DIR="$(localStagingDirectory ${ROBOCONF_PLATFORM})"

mkdir -p "${DIR}" && cd "${DIR}"
ensureSuccess $? "Cannot create/access local staging directory: ${DIR}"

git clone "$(gitRepositoryUrl ${ROBOCONF_PLATFORM})" "${DIR}"
ensureSuccess $? "Cannot clone project in ${DIR}"



echo
echo "Preparing the platform release..."
echo
mvn release:prepare -B -DdryRun="${DRY_RUN}"\
	-DreleaseVersion="${RELEASE_VERSION}"\
	-DdevelopmentVersion="${DEVELOPMENT_VERSION}"
ensureSuccess $? "Failed to prepare the release"



echo
echo "Performing the platform release..."
echo

mvn release:perform -B -DdryRun="${DRY_RUN}"
ensureSuccess $? "Failed to perform the release"



echo
echo "Updating the parent POM's properties..."
echo

sed -i "s/[0-9]\.[0-9])\(<\/version\.range>\)/${NEXT_MINOR_VERSION})\1/g" pom.xml



echo
echo "Updating versions in IT modules..."
echo

mvn versions:update-child-modules -DgenerateBackupPoms=false -DallowSnapshots=true -P it-all



echo
echo "Committing these last changes..."
echo

git commit -a -m "Updating the versions and OSGi imports range"
ensureSuccess $? "Failed to commit the change of versions and OSGi imports range"



echo
echo "Pushing the last commit to origin..."
echo

if [[ "${DRY_RUN}" == "true" ]]; then
	git push origin master --dry-run
else
  git push origin master
fi
ensureSuccess $? "Failed to push the last commit to origin"
