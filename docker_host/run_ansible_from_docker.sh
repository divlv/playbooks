#!/bin/bash

#
# Ansible playbook start script - using Dockerized Ansible
#

# A path where this playbook was checked out from GitHub...
export PLAYBOOK_DIR="/path/to/playbooks/docker_host"

# Copy key file to the playbook directory
export PRIVATE_KEY_FILE_NAME="private.key"
export PRIVATE_KEY_FILE_MAPPED_PATH="/p/$PRIVATE_KEY_FILE_NAME"

export PLAYBOOK_TO_RUN="$PLAYBOOK_DIR/azure_playbook.yml"

# Make key file accepable by Ansible
chmod 600 $PLAYBOOK_DIR/$PRIVATE_KEY_FILE_NAME

docker run -it \
-v $PLAYBOOK_DIR:/p \
cytopia/ansible:2.8-tools /bin/sh -c 'cd /p; ansible-playbook --private-key $PRIVATE_KEY_FILE_MAPPED_PATH -i /p/hosts $PLAYBOOK_TO_RUN'
