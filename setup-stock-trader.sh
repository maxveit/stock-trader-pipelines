#       Copyright 2017-2019 IBM Corp All Rights Reserved

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#!/bin/bash

export OC_PROJECT=tekton
oc create project $OC_PROJECT
oc project $OC_PROJECT

# Tekton pipeline prep
oc apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/git/git-clone.yaml # gite clone task, to be used instead of the old PipelineResource

# Postgresql ephemeral database instance
oc new-app --template=postgresql-ephemeral -p POSTGRESQL_USER=postgresql -p POSTGRESQL_PASSWORD=postgresql
