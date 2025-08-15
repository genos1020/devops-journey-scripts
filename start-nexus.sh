#!/bin/bash
# Start Nexus docker container

# 可以省略 因為 docker run 如果找不到該 volume 會自動建立
#docker volume create nexus-data

# remove old one first
docker rm -f nexus 2>/dev/null


docker run -d -p 8081:8081 \
--name nexus \
--restart unless-stopped \
-v nexus-data:/nexus-data \
sonatype/nexus3


