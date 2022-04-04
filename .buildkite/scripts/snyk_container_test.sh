#!/bin/bash

set -eo

BRANCH_NAME_CLEAN=$(sed 's/\//-/g' <<< "$BUILDKITE_BRANCH")

if [[ -n ${BUILDKITE_TAG} ]] && [[ ${BUILDKITE_BRANCH} == "${BUILDKITE_TAG}" ]]; then
  IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/annalise-schemaspy:${BUILDKITE_TAG}"
else
  IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/annalise-schemaspy:${BUILDKITE_COMMIT}.${BRANCH_NAME_CLEAN}"
fi

# Test always as monitor doesn't output anything informative, it just returns 0 even if there are vulns.
snyk container test "${IMAGE_URI}" --exclude-base-image-vulns --file=Dockerfile --project-name=annalise-schemaspy

if { [[ -n ${BUILDKITE_TAG} ]] && [[ ${BUILDKITE_BRANCH} == "${BUILDKITE_TAG}" ]];} || [[ ${BUILDKITE_BRANCH} == "main" ]]; then
  snyk container monitor "${IMAGE_URI}" --file=Dockerfile --project-name=annalise-schemaspy
fi
