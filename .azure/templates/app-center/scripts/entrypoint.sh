#!/usr/bin/env bash

set -e

org=$1
appName=$2
app="$org/$appName"
branch=$3
output=$4
token=$5

echo "Queueing build for '$app' on branch $branch..."

buildId=$(appcenter build queue --app $app --branch $branch --token $token --output json | jq -r '.buildId')

echo "Build with id '$buildId' queued, waiting for build to finish..."

# Wait for build to finish
while true; do
    buildStatus=$(curl -s -X 'GET' -H 'accept: application/json' -H "X-API-Token: $token" "https://api.appcenter.ms/v0.1/apps/$app/branches/$branch/builds" | jq ". [] | select(.id==$buildId)" | jq -r '.result')
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

echo "Build succeeded, downloading artifacts..."
apk_file="$appName_$branch_$buildId.apk"
appcenter build download -i $buildId -a $app --token $token -t build -f $apk_file -d $output

echo "##vso[task.setvariable variable=buildId;isoutput=true]$buildId"
echo "Done."