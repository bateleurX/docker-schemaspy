#!/bin/bash

set -eo

BRANCH_NAME_CLEAN=$(sed 's/\//-/g' <<< "$BUILDKITE_BRANCH")
DOCKER_TAG="${BUILDKITE_COMMIT}.${BRANCH_NAME_CLEAN}"


if [[ -n ${BUILDKITE_TAG} ]] && [[ ${BUILDKITE_BRANCH} == "${BUILDKITE_TAG}" ]]; then
  IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/annalise-schemaspy:${BUILDKITE_TAG}"
else
  IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/annalise-schemaspy:${DOCKER_TAG}"
fi

docker build -t "${IMAGE_URI}" .

if { [[ -n ${BUILDKITE_TAG} ]] && [[ ${BUILDKITE_BRANCH} == "${BUILDKITE_TAG}" ]];}  || [[ ${BUILDKITE_BRANCH} == "feat/devops" ]] || [[ ${BUILDKITE_BRANCH} == "main" ]] || [[ ${BUILDKITE_BRANCH} == *"release/"* ]]; then
  docker push "${IMAGE_URI}"
fi
