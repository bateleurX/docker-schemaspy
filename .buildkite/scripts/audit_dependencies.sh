#!/bin/bash

BRANCH_NAME_CLEAN=$(sed 's/\//-/g' <<< "$BUILDKITE_BRANCH")
IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/annalise-schemaspy:${BUILDKITE_COMMIT}.${BRANCH_NAME_CLEAN}"
docker build --target rocket-test -t "${IMAGE_URI}" .
docker run -t --rm "${IMAGE_URI}" sh -lc "snyk auth ${SNYK_TOKEN} && snyk monitor --project-name=annalise-schemaspy && snyk test"
