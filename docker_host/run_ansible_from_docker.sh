#!/bin/bash

#
# Ansible playbook start script - using Dockerized Ansible
#

# A path where this playbook was checked out from GitHub...
export PLAYBOOK_DIR="/path/to/playbooks/docker_host"
# Fisrt, copy key file to the playbook directory!
export PRIVATE_KEY_FILE_NAME="private.key"
export PLAYBOOK_TO_RUN="azure_playbook.yml"

# Make key file accepable by Ansible
chmod 600 $PLAYBOOK_DIR/$PRIVATE_KEY_FILE_NAME

docker run -it \
-v $PLAYBOOK_DIR:/p \
-v $PLAYBOOK_DIR/$PRIVATE_KEY_FILE_NAME:/p/private.key \
-v $PLAYBOOK_DIR/$PLAYBOOK_TO_RUN:/p/playbook.yml \
cytopia/ansible:2.8-tools /bin/sh -c 'cd /p; ansible-playbook --private-key /p/private.key -i /p/hosts /p/playbook.yml'
