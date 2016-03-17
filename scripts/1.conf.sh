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



################################################################################
# Configuration for the Roboconf release scripts
# Please edit this file *BEFORE* performing a release.
################################################################################


#######################################################
# Basic Properties
#######################################################


# The version to be released.
# A new tag with this version will be created in the appropriate Git repositories.
# /!\ To be incremented manually!!!
readonly RELEASE_VERSION="0.6.1"

# The previous release's version (for the web site).
# "user-guide" will be renamed "user-guide-${PREVIOUS_VERSION}".
# /!\ To be incremented manually!!!
readonly PREVIOUS_VERSION="0.5"

# The version of the next development iteration (no qualifier).
# This is for the system installers which use a custom qualifier.
# /!\ To be incremented manually!!!
readonly SHORT_DEVELOPMENT_VERSION="0.7"

# The version of the next development iteration (full version).
# /!\ To be incremented manually!!!
readonly DEVELOPMENT_VERSION="${SHORT_DEVELOPMENT_VERSION}-SNAPSHOT"

# The next minor version (for import-package directives).
#
# Typically, the parent POM in the platform defines a property whose value
# is [${project.version}, ${NEXT_MINOR_VERSION}). It is used to define a
# version range for OSGi imports.
#
# /!\ To be incremented manually!!!
readonly NEXT_MINOR_VERSION="0.8"

# Dry run: don't check-in or tag anything in the repositories.
readonly DRY_RUN="false"

# The local directory where the scripts check out and build the Roboconf source.
readonly STAGING_DIR="/tmp/roboconf-release-staging"


#######################################################
# Advanced Properties
#######################################################


# The tag to checkout for a maintenance release.
#
# Only used by the platform's maintenance release script.
# If you are not releasing a maintenance version of the platform, do not modify it.
#
# /!\ To be incremented manually!!! 
readonly MAINTENANCE_VERSION="0.6"

# The package version for system installers.
#
# When doing a full release of the platform (0.6, 0.6.1, 0.6.2, 0.7...),
# this property should be "1.0".
#
# When releasing a maintenance version
# of a SYSTEM PACKAGE, that is to say to fix a bug in the packages (and not
# in the platform), then you should update this property.
#
# /!\ To be incremented manually!!! 
readonly PACKAGE_VERSION_UPDATE="1.0"
