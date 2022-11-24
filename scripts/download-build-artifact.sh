#!/usr/bin/env bash

set -e

app=$1
branch=$2
token=$3

# download the build artifact
npx appcenter build download --app $app --branch $branch --token $token --output-dir build