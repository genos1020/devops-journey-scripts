#!/bin/bash
# Start jenkins server

# remove old one first
docker rm -f jenkins 2>/dev/null

docker run --name jenkins \
-p 8080:8080 \
-p 50000:50000 \
-d -v jenkins_home:/var/jenkins_home \
jenkins/jenkins:lts

