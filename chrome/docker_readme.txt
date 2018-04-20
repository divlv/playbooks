#
# Docker commands
#
# Pull the Docker Image:
docker pull sebp/elk
#
# Start the ELK stack:
#docker run -p 80:5601 -p 9200:9200 -p 9300:9300  -p 9999:9999/udp 29fb3da4f590

************************************************************************************
docker run -p 80:5601 -p 9200:9200 -p 9300:9300 -p 12201:12201/udp --name elk1 wfelk
************************************************************************************


docker run -p 80:5601 -p 9200:9200 -p 9300:9300 -p 12201:12201/udp 8846b24311d1

#docker run -p 80:5601 -p 9200:9200 -p 9300:9300  -p 9999:9999/udp -p 5044:5044/udp 29fb3da4f590
#####################################

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


