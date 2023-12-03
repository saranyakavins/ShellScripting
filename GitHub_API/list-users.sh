#!/bin/bash

#########################################
# Author: Saranya
# Description: Script to fetch the owners of GitHub account
#########################################

################################################
# GitBub API documentation
# https://docs.github.com/en/rest/collaborators/collaborators?apiVersion=2022-11-28
# curl -L \
# -H "Accept: application/vnd.github+json" \
# -H "Authorization: Bearer <YOUR-TOKEN>" \
# -H "X-GitHub-Api-Version: 2022-11-28" \
#  https://api.github.com/repos/OWNER/REPO/collaborators
#################################################

# call helper function
helper

# GitHub API Url
api_url="https://api.github.com"

# GitHub Username and personal access token
# Export username and token before executing this script
username=$username
token=$token

# GitHub User and Repository details passed as command line arguments
 repo_owner=$1
 repo_name=$2

# Function to make a get request to GitHub API
function get_github_api {
local endpoint="$1"
local url="${api_url}/${endpoint}"

# send a GET request to GitHub API with authentication
# -s -> silent or quiet mode, -u user:password
curl -s -u "${username}:${token}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
local endpoint="repos/${repo_owner}/${repo_name}/collaborators"

# get the list of collaborators on the repository
# jq -r command that extracts and outputs properly quoted strings for use by the shell
# call the function get_github_api
collabotorators="$(get_github_api "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

# display the list of collaborators with read access
# -z -> string is null or zero length
if [ -z "$collabotorators" ]; then
echo "No users found with read access for ${repo_owner}/${repo_name}"
else
echo "Users with read access to ${repo_owner}/${repo_name}:"
echo "$collabotorators"
fi
}

# helper function to specify the cmd args
function helper {
expectedCmdArgs=2
if [ $# -ne $expectedCmdArgs ]; then
echo "Execute the script with required cmd args"
fi
}

# Main script

echo "Listing users with read access to repo ${repo_owner}/${repo_name}: "
#call the function list_users_with_read_access
list_users_with_read_access
