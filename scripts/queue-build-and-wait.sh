#!/usr/bin/env bash

set -e

local app, branch, token, buildId
    
app=$1
branch=$2
token=$3

buildId = $(appcenter build queue --app $app --branch $branch --token $token --output json | jq -r '.buildId')

echo "Build queued, waiting for build to finish..."

# Wait for build to finish
while true; do
    local buildStatus
    buildStatus = $(appcenter build show --app $app --build-id $buildId --token $token --output json | jq -r '.status')
    if [ "$buildStatus" == "completed" ]; then
        break
    fi
    sleep 30
done