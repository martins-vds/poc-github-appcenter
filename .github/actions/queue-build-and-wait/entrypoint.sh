#!/usr/bin/env sh

set -e

app="$1/$2"
branch=$3
token=$4

echo "Queueing build for '$app' on branch $branch..."

buildId=$(appcenter build queue --app $app --branch $branch --token $token --output json | jq -r '.buildId')

echo "Build with id '$buildId' queued, waiting for build to finish..."

# Wait for build to finish
while true; do
    buildStatus=$(curl -X 'GET' -H 'accept: application/json' -H "X-API-Token: $token" "https://api.appcenter.ms/v0.1/apps/$app/branches/$branch/builds" | jq ". [] | select(.id==$buildId)" | jq -r '.result')
    if [ "$buildStatus" == "succeeded" ]; then
        break
    elif [ "$buildStatus" == "failed" ]; then
        echo "Build failed"
        exit 1
    elif [ "$buildStatus" == "canceled" ]; then
        echo "Build canceled"
        exit 1
    fi
    sleep 10
done

echo "Build finished"
echo "buildId=$buildId" >> $GITHUB_OUTPUT