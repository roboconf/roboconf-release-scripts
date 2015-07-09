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



################################################################################
# Configuration for the Roboconf release scripts
# Please edit this file *BEFORE* performing a release.
################################################################################

# The version to be release.
# /!\ To be incremented manually!!!
readonly RELEASE_VERSION="0.5"

# The version of the next development iteration.
# /!\ To be incremented manually!!!
readonly DEVELOPMENT_VERSION="0.6-SNAPSHOT"

# Dry run: don't checkin or tag anything in the repositories.
readonly DRY_RUN="true"

# The local directory where the scripts check out and build the Roboconf source.
readonly STAGING_DIR="/tmp/roboconf-release-staging"
