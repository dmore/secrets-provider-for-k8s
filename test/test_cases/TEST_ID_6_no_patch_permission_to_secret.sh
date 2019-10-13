#!/bin/bash
set -euxo pipefail

source $TEST_CASES_UTILS

echo "Creating secrets access role without 'get' permission"
export SECRET_CLUSTER_ROLE_VERBS="    verbs: [ \"get\" ]"
create_secret_access_role

create_secret_access_role_binding

deploy_test_env

echo "Expecting secrets provider to fail with error 'CSPFK005D Failed to patch k8s secret. Reason:...'"
pod_name=$($cli get pods --namespace=$TEST_APP_NAMESPACE_NAME --selector app=test-env --no-headers | awk '{print $1}')
wait_for_it 30 "$cli logs $pod_name -c cyberark-secrets-provider | grep 'CSPFK005D'"



