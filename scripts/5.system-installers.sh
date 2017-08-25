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
echo "Verifying CURL is installed..."
echo

curl --version



echo
echo "Verifying Docker is installed..."
echo

docker --version



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

sed -i "s/<roboconf.short.version>.*<\/roboconf.short.version>/<roboconf.short.version>${RELEASE_VERSION}<\/roboconf.short.version>/g" pom.xml
sed -i "s/<package.build.version>.*<\/package.build.version>/<package.build.version>${PACKAGE_VERSION_UPDATE}<\/package.build.version>/g" pom.xml
sed -i "s/<version.qualifier>.*<\/version.qualifier>/<version.qualifier><\/version.qualifier>/g" pom.xml

mvn clean verify
ensureSuccess $? "Failed to verify the system installers build"

git commit -a -m "Roboconf system installers ${RELEASE_VERSION}"
ensureSuccess $? "Failed to commit the released system installers"



echo
echo "Running tests..."
echo

./tests/run-tests-in-docker.sh
ensureSuccess $? "One or several tests failed"



echo
echo "Tagging the system installers..."
echo

git tag -a -f "roboconf-system-installers-${RELEASE_VERSION}" -m "Roboconf system installers ${RELEASE_VERSION}"
ensureSuccess $? "Failed to tag system installers"



echo
echo "Bumping versions for next development iteration..."
echo

sed -i "s/<roboconf.short.version>.*<\/roboconf.short.version>/<roboconf.short.version>${SHORT_DEVELOPMENT_VERSION}<\/roboconf.short.version>/g" pom.xml
sed -i "s/<package.build.version>.*<\/package.build.version>/<package.build.version>1.0<\/package.build.version>/g" pom.xml
sed -i "s/<version.qualifier>.*<\/version.qualifier>/<version.qualifier>-SNAPSHOT<\/version.qualifier>/g" pom.xml

mvn validate
ensureSuccess $? "Failed to verify the system installers after the switch for the next iteration"

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
echo "Creating the version on Bintray (DEB)..."
echo

curl -vvf -u${BINTRAY_USER}:${BINTRAY_API_KEY} -H "Content-Type: application/json" \
	-X POST ${BINTRAY_URL}/packages/roboconf/roboconf-debian-packages/main/versions \
	--data "{\"name\": \"${RELEASE_VERSION}\", \"github_use_tag_release_notes\": false }"



echo
echo "Uploading the DEB files to Bintray..."
echo

for f in $(find -name "*.deb" -type f)
do
	echo
	echo "Uploading $f"
	curl -X PUT -T $f -u ${BINTRAY_USER}:${BINTRAY_API_KEY} \
		-H "X-Bintray-Debian-Distribution:jessie" \
		-H "X-Bintray-Debian-Component:main" \
		-H "X-Bintray-Debian-Architecture:i386,amd64" \
		-# -o "/tmp/curl-output.txt" \
		${BINTRAY_URL}/content/roboconf/roboconf-debian-packages/main/${RELEASE_VERSION}/
	
	echo
	echo "$(</tmp/curl-output.txt)"
	echo
done



echo
echo "Creating the version on Bintray (RPM)..."
echo

curl -vvf -u${BINTRAY_USER}:${BINTRAY_API_KEY} -H "Content-Type: application/json" \
	-X POST ${BINTRAY_URL}/packages/roboconf/roboconf-rpm/main/versions \
	--data "{\"name\": \"${RELEASE_VERSION}\", \"github_use_tag_release_notes\": false }"



echo
echo "Uploading the RPM files to Bintray..."
echo

for f in $(find -name "*.rpm" -type f)
do
	echo
	echo "Uploading $f"
	curl -X PUT -T $f -u ${BINTRAY_USER}:${BINTRAY_API_KEY} \
		-H "X-Bintray-Version:${RELEASE_VERSION}" \
		-H "X-Bintray-Package:main" \
		-# -o "/tmp/curl-output.txt" \
		${BINTRAY_URL}/content/roboconf/roboconf-rpm/main/${RELEASE_VERSION}/
	
	echo
	echo "$(</tmp/curl-output.txt)"
	echo
done



echo
echo "Please, visit https://bintray.com/roboconf/roboconf-debian-packages/main/${RELEASE_VERSION}/view to publish the uploaded files."
echo "Please, visit also https://bintray.com/roboconf/roboconf-rpm/main/${RELEASE_VERSION}/view to publish the uploaded files."
echo
echo "Notice that RPM meta-data should be calculated automatically after artifacts are published."
echo "See http://dl.bintray.com/roboconf/roboconf-rpm/repodata/repomd.xml"
echo
echo "If it was not updated, please refer to this script sources."
echo


#
# Here is the CURL command to force the calculation of RPM meta-data. 
# curl -X POST -u ${BINTRAY_USER}:${BINTRAY_API_KEY} https://api.bintray.com/calc_metadata/roboconf/roboconf-rpm
#
