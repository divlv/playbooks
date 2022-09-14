#!/bin/bash

# Cleaning unused Docker containers and images to save HDD space:

docker container prune -f
docker image prune -a -f
docker volume prune -f
#
