#!/bin/bash

set -e

# usage
# <rolename> <accountid>

unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

function log() {
  MSG=$1
  printf "\n=======%s========\n" "${MSG}"
}

function assumeRole() {
  rolename=$1
  accountid=$2
  aws sts assume-role --role-arn "arn:aws:iam::${accountid}:role/$rolename" --role-session-name $rolename > assume-role-tmp.txt
  export AWS_ACCESS_KEY_ID=`jq -r '.Credentials.AccessKeyId' assume-role-tmp.txt`
  export AWS_SECRET_ACCESS_KEY=`jq -r '.Credentials.SecretAccessKey' assume-role-tmp.txt`
  export AWS_SESSION_TOKEN=`jq -r '.Credentials.SessionToken' assume-role-tmp.txt`

  log "role assumed with session name ${rolename}"
  aws sts get-caller-identity
  log "session started with ${accountid}-${rolename}"
}

assumeRole $1 $2
