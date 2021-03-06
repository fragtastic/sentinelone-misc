#!/usr/bin/env bash

set -e

s1package="${1}"
newuid=${2}
newgid=${3}

echo Installing SentinelOne Agent from ${s1package}
dpkg -i ${s1package}

autouid=`id -u sentinelone`
autogid=`id -g sentinelone`
echo Found uid:${autouid} and gid:${autogid}

echo Setting new uid:${newuid} and gid:${newgid}
usermod -u ${newuid} sentinelone
groupmod -g ${newgid} sentinelone

echo Changing file /opt/sentinelone/ user id
chown -h sentinelone /opt/sentinelone
find /opt/sentinelone/ -user ${autouid} -exec chown -h sentinelone {} \;


echo Changing file /opt/sentinelone/ group id
chgrp -h sentinelone /opt/sentinelone
find /opt/sentinelone/ -user ${autogid} -exec chgrp -h sentinelone {} \;

echo Verify files
ls -hal /opt/ | grep sentinelone
ls -hal /opt/sentinelone/ | grep sentinelone

echo Verify /etc/passwd
grep sentinelone /etc/passwd
