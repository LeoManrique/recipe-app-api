#!/bin/bash

# Configuration
localDir="/home/leo/GitProjects/Python/recipe-app-api/"
remoteHost="lux@luxsystems.it"
remoteDir="/home/lux/GitProjects/Python/recipe-app-api/"
rsyncIgnore=".rsyncignore"
sshCmd="ssh"

# Ensure .rsyncignore exists
if [ ! -f "${localDir}${rsyncIgnore}" ]; then
  echo -e "Error: .rsyncignore file not found at ${localDir}${rsyncIgnore}"
  exit 1
fi

# Check for the --no_sync_flag flag
no_sync_flag=false
if [[ "$1" == "--no_sync_flag" ]]; then
  no_sync_flag=true
  shift # Remove the --no_sync_flag flag from the arguments
fi

# Perform sync from local to remote if --no_sync_flag not is specified
if [ "$no_sync_flag" = false ]; then
  rsync -avz --delete -e "$sshCmd" --exclude-from="${localDir}${rsyncIgnore}" "$localDir" "$remoteHost:$remoteDir"
  if [ $? -ne 0 ]; then
    echo "Error during sync from local to remote."
    exit 1
  fi
  printf "\n"
fi

# Optional: Execute a remote command
if [ $# -gt 0 ]; then
  echo -e "Executing remote command...\n"
  $sshCmd "$remoteHost" "cd $remoteDir && $@"
  if [ $? -ne 0 ]; then
    echo "Error executing remote command."
    exit 1
  fi
  echo -e "\nExecution completed!"
fi

# Perform sync from remote to local if --no_sync_flag not is specified
if [ "$no_sync_flag" = false ]; then
  printf "\n"
  ./sync-remote-to-local.sh
fi
