#!/bin/bash
#
# Sample GHOST Build script
#
cd {{ ghost_dir }} 
#
#docker build -t wfelk . 

docker run -d -p {{ ghost_port }}:2368 -v {{ ghost_data_dir }}:/var/lib/ghost/content ghost:1-alpine

#