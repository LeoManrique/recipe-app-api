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

# Check for the --sync flag
sync_flag=false
if [[ "$1" == "--sync" ]]; then
  sync_flag=true
  shift # Remove the --sync flag from the arguments
fi

# Perform sync from local to remote if --sync is specified
if [ "$sync_flag" = true ]; then
  echo "Syncing from local to remote..."
  rsync -avz --delete -e "$sshCmd" --exclude-from="${localDir}${rsyncIgnore}" "$localDir" "$remoteHost:$remoteDir"
  if [ $? -ne 0 ]; then
    echo "Error during sync from local to remote."
    exit 1
  fi
  echo -e "\n"
fi

# Optional: Execute a remote command
if [ $# -gt 0 ]; then
  echo -e "Executing remote command..."
  $sshCmd "$remoteHost" "cd $remoteDir && $@"
  if [ $? -ne 0 ]; then
    echo "Error executing remote command."
    exit 1
  fi
  echo "Execution completed!"
fi

# Perform sync from remote to local if --sync is specified
if [ "$sync_flag" = true ]; then
  echo -e "\nSyncing from remote to local..."
  rsync -avz --delete -e "$sshCmd" --exclude-from="${localDir}${rsyncIgnore}" "$remoteHost:$remoteDir" "$localDir"
  if [ $? -ne 0 ]; then
    echo "Error during sync from remote to local."
    exit 1
  fi

  echo -e "\nSync completed!"
fi