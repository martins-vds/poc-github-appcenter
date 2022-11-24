#!/usr/bin/env bash

set -e

app=$1
branch=$2
token=$3

npm install appcenter

echo "Queueing build for '$app' on branch $branch..."

buildId=$(npx appcenter build queue --app $app --branch $branch --token $token --output json | jq -r '.buildId')

echo "Build with id '$buildId' queued, waiting for build to finish..."

# Wait for build to finish
while true; do
    buildStatus=$(npx appcenter build show --app $app --build-id $buildId --token $token --output json | jq -r '.status')
    if [ "$buildStatus" == "completed" ]; then
        break
    fi
    sleep 30
done

echo "Build finished"