#
# Sample Dockerfile
#
FROM sebp/elk

ADD ./03-gelf-input.conf /etc/logstash/conf.d/03-gelf-input.conf
# TODO: add ADD directive to overwrite 30-output.conf as needed

# expose GELF's default UDP port (12201)
EXPOSE 12201/udp
