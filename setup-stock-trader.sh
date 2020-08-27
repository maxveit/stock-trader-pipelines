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

export OC_PROJECT=demo
oc new-project $OC_PROJECT
oc project $OC_PROJECT

###### Tekton pipeline prep
oc apply -f tekton-setup/github-binding.yaml
oc apply -f tekton-setup/trigger-role.yaml
oc apply -f tekton-setup/trigger-rolebinding.yaml

###### Tekton task setup
oc apply -f tekton-tasks/cleanup-folder.yaml
oc apply -f tekton-tasks/container-build-push.yaml
oc apply -f tekton-tasks/init-pipeline.yaml
oc apply -f tekton-tasks/maven.yaml

###### Tekton container build pipeline
oc apply -f container-build-pipeline/pipeline.yaml
oc apply -f container-build-pipeline/triggertemplate.yaml
oc apply -f container-build-pipeline/eventlistener.yaml
# Expose the route
oc expose svc/el-github-listener-container-build
# run "oc get route" and extract the route to configure github

###### Tekton maven build pipeline
#oc apply -f maven-build-pipeline/eventlistener.yaml 
#oc apply -f maven-build-pipeline/pipeline.yaml
#oc apply -f maven-build-pipeline/triggertemplate.yaml
# Expose the route
#oc expose svc/el-github-listener-maven-build
# run "oc get route" and extract the route to configure github

###### Postgresql ephemeral database instance
#oc new-app --template=postgresql-ephemeral -p POSTGRESQL_USER=postgresql -p POSTGRESQL_PASSWORD=postgresql -p POSTGRESQL_DATABASE=portfolio
