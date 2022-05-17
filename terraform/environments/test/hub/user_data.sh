#!/bin/bash

set -euo pipefail

pid=$$

# Redirect startup logs to /var/log/
exec > >(sudo tee /var/log/user-data-$pid.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Copying files from:"
echo "s3://${bucket_name}/files/environment/${environment}/${registry_name}/"
aws s3 cp s3://${bucket_name}/files/environment/${environment}/${registry_name}/ /data --recursive

# Make script executable just in case
sudo chmod +x /data/scripts/upload_logs.sh

# Run all cluster
# https://github.com/docker/compose/issues/1339
export HOSTNAME=$HOSTNAME
sudo TMPDIR=/var/tmp docker-compose -f /data/docker-compose.yml up -d





