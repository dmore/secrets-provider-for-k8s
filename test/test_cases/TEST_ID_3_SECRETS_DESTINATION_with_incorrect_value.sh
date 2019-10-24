#!/bin/bash
set -euxo pipefail

source $TEST_CASES_UTILS

create_secret_access_role

create_secret_access_role_binding

echo "Deploying test_env with incorrect value for SECRETS_DESTINATION envrionment variable"
export SECRETS_DESTINATION_KEY_VALUE="SECRETS_DESTINATION SECRETS_DESTINATION_incorrect_value"
deploy_test_env

echo "Expecting secrets provider to fail with error 'CSPFK005E Provided incorrect value for environment variable SECRETS_DESTINATION'"
pod_name=$(cli_get_pods_test_env | awk '{print $1}')
wait_for_it 600 "$cli logs $pod_name -c cyberark-secrets-provider | grep 'CSPFK005E'"
