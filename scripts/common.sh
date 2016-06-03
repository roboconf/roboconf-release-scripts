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



# Imports the configuration
source 1.conf.sh
source 1.conf.bintray.sh


################################################################################
# Roboconf repository locations & directory layouts.
# /!\ DO *NOT* EDIT unless you know perfectly what you're doing!!!
################################################################################
readonly ROBOCONF_ECLIPSE="roboconf-eclipse"
readonly ROBOCONF_EXAMPLES="roboconf-examples"
readonly ROBOCONF_LANGUAGE="language-roboconf"
readonly ROBOCONF_MAVEN_ARCHETYPE="roboconf-maven-archetype"
readonly ROBOCONF_PARENT="roboconf-parent"
readonly ROBOCONF_PLATFORM="roboconf-platform"
readonly ROBOCONF_SYSTEM_INSTALLERS="roboconf-system-installers"
readonly ROBOCONF_WEB_ADMINISTRATION="roboconf-web-administration"
readonly ROBOCONF_DOCKER="roboconf-dockerfile"
readonly ROBOCONF_WEBSITE="roboconf.github.io"

# Bintray parameters
readonly BINTRAY_URL="https://bintray.com/api/v1"



################################################################################
# Common utility functions
################################################################################

# Returns the Git repository URL for the given Roboconf project.
# @param 1    the name of the Roboconf project. One of the above constants.
# @stdout     the Git repository URL for the given Roboconf project.
gitRepositoryUrl() {
	echo "git@github.com:roboconf/$1.git"
}

# Returns the local staging directory for the given Roboconf project.
# @param 1    the name of the Roboconf project. One of the above constants.
# @globals    STAGING_DIR
# @stdout     the local staging directory for the given Roboconf project.
localStagingDirectory() {
	echo "${STAGING_DIR}/$1"
}

# Checks that the given error code is zero. If not, exits the script after printing the given error message.
# @param 1    the return code to check.
# @param 2    the error message to display in case the given error code is non-zero.
# @stdout     nothing in case of success, the given error message otherwise.
ensureSuccess() {
	if [[ $1 -ne 0 ]]; then
		echo
		echo "Error: $2"
		echo "ABORTING!"
		exit 1
	fi
}
