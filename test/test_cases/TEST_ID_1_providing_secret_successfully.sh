#!/bin/bash
set -euxo pipefail

source $TEST_CASES_UTILS

create_secret_access_role

create_secret_access_role_binding

deploy_test_env

echo "Verifying pod test_env has environment variable 'TEST_SECRET' with value 'supersecret'"
pod_name=$(cli_get_pods_test_env | awk '{print $1}')
verify_secret_value_in_pod $pod_name TEST_SECRET supersecret
