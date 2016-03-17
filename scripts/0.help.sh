#!/bin/bash

# Copyright 2016 Linagora, Université Joseph Fourier, Floralis
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


echo
echo "Help about Roboconf's release scripts"
echo
echo "1. Create/update conf.bintray.sh and edit conf.sh with your settings."
echo "2. Update and tag roboconf-web-administration."
echo "3. Release roboconf-platform. Wait for it to be available on Maven Central."
echo "Be careful, there are 2 scripts: one for « normal » releases and one for « maintenance » releases."
echo "4. Release roboconf-eclipse-plugin."
echo "5. Release roboconf-system-installers."
echo "6. Update the web site. There may be some little things to complete by hand."
echo "7. Commit and push the web site on Github."
echo "8. Update and tag roboconf-examples."
echo
echo "Visit http://roboconf.net/en/developer-guide/release-management.html for more details."
echo
