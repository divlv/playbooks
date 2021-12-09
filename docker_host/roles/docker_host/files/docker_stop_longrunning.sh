#!/bin/bash

# Stopping long running containers (filtered by image name part) (>2 min run)
# E.g. MSSQL containers...
#
export CONTAINERFILTER=mssql
#
docker ps --format="{{.RunningFor}} {{.Names}} {{.Image}}" | grep $CONTAINERFILTER | grep minutes |  awk -F: '{if($1>2)print$1}' | awk ' {print $4} ' | xargs docker kill
#
