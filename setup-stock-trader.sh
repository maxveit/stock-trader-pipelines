#!/bin/bash
export OC_PROJECT=tekton
oc create project $OC_PROJECT
oc project $OC_PROJECT

# Tekton pipeline prep
oc apply -f https://github.com/tektoncd/catalog/blob/master/git/git-clone.yaml # gite clone task, to be used instead of the old PipelineResource

# Postgresql ephemeral database instance
oc new-app --template=postgresql-ephemeral -p POSTGRESQL_USER=postgresql -p POSTGRESQL_PASSWORD=postgresql
