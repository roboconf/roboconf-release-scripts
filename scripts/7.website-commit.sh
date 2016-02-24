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
echo "Committing the web site..."
echo

DIR="$(localStagingDirectory ${ROBOCONF_WEBSITE})"
cd "${DIR}"

git add en/* -f
git add fr/* -f
git commit -a -m "New web site update after the release of Roboconf ${RELEASE_VERSION}"


echo
echo "Pushing to origin..."
echo

if [[ "${DRY_RUN}" == "true" ]]; then
	git push --dry-run origin master
else
  git push origin master
fi

ensureSuccess $? "Failed to push the commit to origin"
