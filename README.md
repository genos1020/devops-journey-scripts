# devops-journey-scripts
Scripts from my DevOps self-study journey.

## Scripts List
<!-- SCRIPTS-LIST:START -->
- [update_readme.sh](./update_readme.sh)
  自動更新新的script到README
- [start-nexus.sh](./start-nexus.sh)
  Start Nexus docker container
- [start-jenkins.sh](./start-jenkins.sh)
  Start jenkins server  
  因為開機時序問題 --restart unless-stopped 會啟動失敗 → 改成 always
  - Droplet 開機時序 → Jenkins 嘗試啟動太早，某些資源(volume、網路)還沒 ready 就掛掉。
  - Docker 自動拉起容器，但 Jenkins 當時啟動失敗 → 就直接變成 Exited，之後就不會再 retry。
- [start-jenkins-v2.sh](./start-jenkins-v2.sh)
  判斷 Jenkins 容器是否已存在：
  - 如果 還沒建立過 → 用 docker run 建立（帶 --restart always)
  - 如果 已存在 → 就用 docker start 直接啟動，不會重複建立
- [start-jenkins-compose.yaml](./start-jenkins-compose.yaml)
  - 改用docker compose，會等 daemon 準備好才拉容器，所以更可靠
  - /var/run/docker.sock:/var/run/docker.sock 
    - 將宿主機的docker socket mount進容器中，如此在容器中就能操作宿主機的docker
<!-- SCRIPTS-LIST:END -->
