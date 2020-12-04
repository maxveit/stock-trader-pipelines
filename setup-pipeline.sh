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

###### Create service account and add permissions for Service Provisioning
oc create sa service-deploy # This must be kept
## Remove the next two lines if you haven't deployed the IBM Cloud Operator in your cluster
oc apply -f tekton-setup/service-provision-role.yaml
oc apply -f tekton-setup/service-provision-rolebinding.yaml 

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

###### Tekton maven build pipeline
oc apply -f maven-build-pipeline/eventlistener.yaml 
oc apply -f maven-build-pipeline/pipeline.yaml
oc apply -f maven-build-pipeline/triggertemplate.yaml

###### Tekton maven build pipeline
oc apply -f gradle-build-pipeline/eventlistener.yaml 
oc apply -f gradle-build-pipeline/pipeline.yaml
oc apply -f gradle-build-pipeline/triggertemplate.yaml

# Expose the route as edge routes (creates https endpoints that offload TLS)
oc create route edge el-github-listener-container-build --service=el-github-listener-container-build
oc create route edge el-github-listener-gradle-build --service=el-github-listener-gradle-build
oc create route edge el-github-listener-maven-build --service=el-github-listener-maven-build