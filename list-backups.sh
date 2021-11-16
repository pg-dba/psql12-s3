#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [[ -z "$1" ]];
then

echo -e "\n${YELLOW}backuped servers list:${NC}"

mc ls ${AWS_PROFILE_MINIO}/backups

else

echo -e "\n${YELLOW}full backup list for $1:${NC}"

barman-cloud-backup-list -P ${AWS_PROFILE_MINIO} --endpoint-url ${MINIO_ENDPOINT_URL} s3://backups $1

fi
