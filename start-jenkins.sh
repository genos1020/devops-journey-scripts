#!/bin/bash
# Start jenkins server

# remove old one first
docker rm -f jenkins 2>/dev/null

docker run --name jenkins \
-p 8080:8080 \
-p 50000:50000 \
-d -v jenkins_home:/var/jenkins_home \
--restart unless-stopped \
jenkins/jenkins:lts

# port 50000 是jenkins master node與worker node溝通的port
# 但現階段還沒有建立jenkins cluster, 所以此port還不會被用到
