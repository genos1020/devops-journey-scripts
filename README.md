# devops-journey-scripts
Scripts from my DevOps self-study journey.

## Scripts List
<!-- SCRIPTS-LIST:START -->
- [update_readme.sh](./update_readme.sh) 自動更新新的script到README
- [start-nexus.sh](./start-nexus.sh) Start Nexus docker container
- [start-jenkins.sh](./start-jenkins.sh) Start jenkins server
- [start-jenkins-v2.sh](./start-jenkins-v2.sh)
    判斷 Jenkins 容器是否已存在：
    - 如果 還沒建立過 → 用 docker run 建立（帶 --restart always）
    - 如果 已存在 → 就用 docker start 直接啟動，不會重複建立
<!-- SCRIPTS-LIST:END -->
