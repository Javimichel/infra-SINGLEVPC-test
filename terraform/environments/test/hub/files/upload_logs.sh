#!/bin/bash
# This file is run via crontab job with root user reconfigured in the AMI

set -euo pipefail

pid=$$

SOURCE_FILENAME=logstash-`date -d yesterday +%F`.log
SOURCE_FILEPATH=/data/logs/logstash/$SOURCE_FILENAME

# The target filename adds the hostname to the filename to prevent overwriting it
# when uploading the file from another node
TARGET_FILEPATH=logs/production/hub/`date "+%Y/%m" -d "yesterday"`/logstash-$HOSTNAME-`date -d yesterday +%F`.log.gz

#Verificamos la existencia del archivo
if [[ -f "${SOURCE_FILEPATH}" ]]; then
        #Comprimimos el archivo a subir
        RESULT=`gzip ${SOURCE_FILEPATH}`
        if [[ $? -eq 0 ]]; then
                #Subimos el archivo al S3
                RESULT=`aws s3 cp ${SOURCE_FILEPATH}.gz s3://fury-container-platform/$TARGET_FILEPATH`
                if [[ $? -eq 0 ]]; then
                        echo "File ${SOURCE_FILEPATH}.gz was uploaded."
                        `rm "${SOURCE_FILEPATH}.gz"` && echo "The gzipped file was deleted."
                else
                        echo "Unable to upload ${SOURCE_FILEPATH}.gz file to S3 directory. Check the result value: ${RESULT} in gzip manual."
                        exit 3
                fi
        else
                echo "Unable to compress ${SOURCE_FILEPATH}. Check the result value: ${RESULT} in gzip manual."
                exit 2
        fi
else
        echo "The file ${SOURCE_FILEPATH} doesn't exists."
        exit 1
fi