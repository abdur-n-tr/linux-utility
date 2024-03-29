#!/bin/bash

##############################
# Author: Abdur Rehman
# Date: Mar 29, 2024
#
# Version: v1
# Input Args: OWNER, REPO
#
# This script will report the AWS resource usage.
##############################


###############################
# GitHub API URL
# https://docs.github.com/en/rest/collaborators/collaborators?apiVersion=2022-11-28
#
# to run this script, execute the below command,
# ./list_github_repo_users.sh <org-name> <repo-name>
# also, make sure to set the env variable GITHUB_TOKEN as `export GITHUB_TOKEN=<github-token>`
###############################


API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
GITHUB_TOKEN=$github_token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" "$url"
    # curl -s -u "${USERNAME}:${TOKEN}" "$url"
}


# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

function helper {
    
    if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
        echo "Error: Please provide OWNER and REPO as command-line arguments."
        echo "Usage: $0 OWNER REPO"
        exit 1  # Exit with error code 1
    fi
}

helper


# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
