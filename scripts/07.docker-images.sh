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
source 01.conf.dockerhub.sh


echo
echo "Checking out the Dockerfile..."
echo

DIR="$(localStagingDirectory ${ROBOCONF_DOCKER})"

mkdir -p "${DIR}" && cd "${DIR}"
ensureSuccess $? "Cannot create/access local staging directory: ${DIR}"

git clone "$(gitRepositoryUrl ${ROBOCONF_DOCKER})" "${DIR}"
ensureSuccess $? "Cannot clone project in ${DIR}"



echo
echo "Deleting old images..."
echo

docker rmi roboconf/roboconf-dm:latest
docker rmi roboconf/roboconf-agent:latest



echo
echo "Building the images..."
echo

cd meta-scripts

./build.sh "dm" "${RELEASE_VERSION}"
ensureSuccess $? "The image for the DM could not be built."

./verify.sh "dm"
ensureSuccess $? "The verification for the DM's image failed."

./build.sh "agent" "${RELEASE_VERSION}"
ensureSuccess $? "The image for the agent could not be built."

./verify.sh "agent"
ensureSuccess $? "The verification for the agent's image failed."

cd ..



echo
echo "Uploading the images to Docker Hub..."
echo

docker login -u=${DOCKER_HUB_USER} -p=${DOCKER_HUB_PWD}
docker push roboconf/roboconf-dm:${RELEASE_VERSION}
docker push roboconf/roboconf-dm:latest

docker push roboconf/roboconf-agent:${RELEASE_VERSION}
docker push roboconf/roboconf-agent:latest
docker logout



echo
echo "Tagging the release..."
echo

git tag -a -f "roboconf-dockerfile-${RELEASE_VERSION}" -m "Dockerfile for Roboconf ${RELEASE_VERSION}"
ensureSuccess $? "Failed to tag the Dockerfile"


echo
echo "Pushing the tag to origin..."
echo

if [[ "${DRY_RUN}" == "true" ]]; then
	git push --dry-run --tags origin master
else
  git push --tags origin master
fi

ensureSuccess $? "Failed to push tag and commit to origin"

