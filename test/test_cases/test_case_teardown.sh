#!/bin/bash
set -euxo pipefail

source $TEST_CASES_UTILS

# Restore secret to original value
set_namespace $CONJUR_NAMESPACE_NAME
configure_cli_pod
$cli exec $(get_conjur_cli_pod_name) -- conjur variable values add secrets/test_secret "supersecret"

set_namespace $TEST_APP_NAMESPACE_NAME

$cli delete secret dockerpullsecret --ignore-not-found=true

$cli delete clusterrole secrets-access --ignore-not-found=true

$cli delete secret test-k8s-secret --ignore-not-found=true

#$cli delete serviceaccount -n $TEST_APP_NAMESPACE_NAME ${TEST_APP_NAMESPACE_NAME}-sa --ignore-not-found=true
$cli delete serviceaccount ${TEST_APP_NAMESPACE_NAME}-sa --ignore-not-found=true

$cli delete rolebinding secrets-access-role-binding --namespace $TEST_APP_NAMESPACE_NAME --ignore-not-found=true

$cli delete deploymentconfig -n $TEST_APP_NAMESPACE_NAME test-env --ignore-not-found=true

$cli delete configmap -n $TEST_APP_NAMESPACE_NAME  conjur-master-ca-env --ignore-not-found=true

