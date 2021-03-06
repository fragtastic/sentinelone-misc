#!/usr/bin/env bash

set -e

print_usage() {
        echo ${0} -u USER_ID -g GROUP_ID
        exit 1
}

while getopts “u:g:” opt; do
  case $opt in
    u) newuid=$OPTARG ;;
    g) newgid=$OPTARG ;;
    *) print_usage ;;
  esac
done

if [ -z "$newuid" ] || [ -z "$newgid" ]
then
      print_usage
fi

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
find /opt/sentinelone/ -group ${autogid} -exec chgrp -h sentinelone {} \;

echo Verify files
ls -hal /opt/ | grep sentinelone
ls -hal /opt/sentinelone/ | grep sentinelone

echo Verify /etc/passwd
grep sentinelone /etc/passwd
