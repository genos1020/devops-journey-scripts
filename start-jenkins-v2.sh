#!/bin/bash
# Start Jenkins container safely
# - 如果容器不存在 → 建立並啟動 (--restart always)
# - 如果容器存在但沒在跑 → 啟動
# - 如果容器已在跑 → 顯示狀態

CONTAINER_NAME="jenkins"
IMAGE="jenkins/jenkins:lts"
VOLUME="jenkins_home"

# 檢查容器是否已存在
if [ "$(docker ps -aq -f name=^${CONTAINER_NAME}$)" ]; then
    if [ "$(docker ps -q -f name=^${CONTAINER_NAME}$)" ]; then
        echo "✅ Jenkins container is already running."
    else
        echo "🔄 Starting existing Jenkins container..."
        docker start "$CONTAINER_NAME"
    fi
else
    echo "🚀 Creating and starting new Jenkins container..."
    docker run --name "$CONTAINER_NAME" \
        -p 8080:8080 \
        -p 50000:50000 \
        -d \
        -v ${VOLUME}:/var/jenkins_home \
        --restart always \
        "$IMAGE"
fi

# 顯示狀態
docker ps -a | grep "$CONTAINER_NAME"
