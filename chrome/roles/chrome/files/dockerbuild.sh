#!/bin/bash
#
# Build ELK/GELF Docker Image 
#
cd /opt
#
git clone https://github.com/divlv/rendertron.git
#
#
cd /opt/rendertron
#
docker build -t rendertron . --no-cache=true
#