#!/bin/bash

# Copyright 2014-2017 Linagora, Université Joseph Fourier, Floralis
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
echo "Checking out the examples..."
echo

DIR="$(localStagingDirectory ${ROBOCONF_EXAMPLES})"

mkdir -p "${DIR}" && cd "${DIR}"
ensureSuccess $? "Cannot create/access local staging directory: ${DIR}"

git clone "$(gitRepositoryUrl ${ROBOCONF_EXAMPLES})" "${DIR}"
ensureSuccess $? "Cannot clone project in ${DIR}"



echo
echo "Bump versions for release..."
echo

mvn versions:set -DnewVersion="${RELEASE_VERSION}" -DgenerateBackupPoms=false
ensureSuccess $? "Failed to bump versions for release"

mvn verify
ensureSuccess $? "Failed to verify the examples build"

git commit -a -m "Using the newly released Roboconf version"
ensureSuccess $? "Failed to commit the released examples"



echo
echo "Tagging the release..."
echo

git tag -a -f "roboconf-examples-${RELEASE_VERSION}" -m "Examples for Roboconf ${RELEASE_VERSION}"
ensureSuccess $? "Failed to tag examples"


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
