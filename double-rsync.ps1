# Configuration
${localDir} = "C:/Users/Leo/GitProjects/Python/recipe-app-api"
${remoteHost} = "lux@luxsystems.it"
${remoteDir} = "/home/lux/GitProjects/Python/recipe-app-api/"
${rsyncIgnore} = ".rsyncignore"
${sshCmd} = "C:/cwrsync/bin/ssh.exe -i C:/Users/Leo/.ssh/id_rsa -o UserKnownHostsFile=C:/Users/Leo/.ssh/known_hosts"

# Convert local path to Cygwin-compatible format
${localDirCygwin} = "/cygdrive/" + (${localDir} -replace ":", "").Replace("\", "/")

# Sync from local to remote
Write-Host "Syncing from local to remote..." -ForegroundColor Green
${rsyncLocalToRemote} = "rsync -avz --delete -e `"${sshCmd}`" --exclude-from=`"${localDirCygwin}/${rsyncIgnore}`" `"${localDirCygwin}/`" `"${remoteHost}:${remoteDir}`""
Invoke-Expression ${rsyncLocalToRemote}

# Sync from remote to local
Write-Host "Syncing from remote to local..." -ForegroundColor Green
${rsyncRemoteToLocal} = "rsync -avz --delete -e `"${sshCmd}`" --exclude-from=`"${localDirCygwin}/${rsyncIgnore}`" `"${remoteHost}:${remoteDir}`" `"${localDirCygwin}/`""
Invoke-Expression ${rsyncRemoteToLocal}

Write-Host "Sync completed!" -ForegroundColor Cyan