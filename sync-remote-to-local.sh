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

# Perform sync from remote to local
rsync -avz --delete -e "$sshCmd" --exclude-from="${localDir}${rsyncIgnore}" "$remoteHost:$remoteDir" "$localDir"
if [ $? -ne 0 ]; then
  echo "Error during sync from remote to local."
  exit 1
fi

echo -e "\nSync completed!"