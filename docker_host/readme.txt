#
# Useful Docker commands
#
# Delete every Docker containers
# Must be run first because images are attached to containers
docker rm -f $(docker ps -a -q)

# Delete every Docker image
docker rmi -f $(docker images -q)

#########
stop all containers:
docker kill $(docker ps -q)

remove all containers
docker rm $(docker ps -a -q)

remove all docker images
docker rmi $(docker images -q)

#############
#Remove unused data

docker system prune --all

