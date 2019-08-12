#!/bin/bash
# ===============================测试代码更新
function pull_case(){
    ./deploy/src/index.sh \
    --mode=local \
    --git-url=https://github.com/light0x00/blog.git \
    --skip-compile \
    --skip-deploy
}

# pull_case

# ===============================测试编译
# 测试内置编译脚本
function compile_case0(){
    ./deploy/src/index.sh \
    --repo-path=/tmp/blog.7N6KS8 \
    --skip-pull \
    --skip-deploy \
    --mode=remote \
    --app-name=blog \
    --compile-strategy=npm
}
# compile_case0
# 测试使用外部编译脚本
function compile_case1(){
    ./deploy/src/index.sh \
    --skip-pull \
    --skip-deploy \
    --mode=remote \
    --app-name=blog \
    --repo-path=/tmp/blog.7N6KS8 \
    --compile-strategy='deploy/test/mvnw.sh'
}
# compile_case1

# ===============================测试部署

# 部署到远程
function deploy_case0(){
    ./deploy/src/index.sh \
    --app-name=blog\
    --skip-pull \
    --skip-compile \
    --mode=remote \
    --local-path=/tmp/blog.7N6KS8 \
    --compile-target-path=dist \
    --remote-ip=47.244.152.125 \
    --remote-user=light \
    --remote-path=/home/light/app/blog
    # -y
}
# deploy_case0

# 部署到本地
function deploy_case1(){
    ./deploy/src/index.sh \
    --app-name=blog\
    --skip-pull \
    --skip-compile \
    --mode=local \
    --local-path=/tmp/blog.7N6KS8 \
    --deploy-path=/Users/light/Desktop/tmp/blog \
    --compile-target-path=dist
    # -y
}
# deploy_case1

# ===============================测试备份

function backup_case0(){
    ./deploy/src/index.sh \
    --app-name=blog\
    --skip-pull \
    --skip-compile \
    --mode=remote \
    --local-path=/tmp/blog.7N6KS8 \
    --compile-target-path=dist \
    --remote-ip=47.244.152.125 \
    --remote-user=light \
    --remote-path=/home/light/app/blog \
    --backup-dir=/home/light/app-backup
    # -y
}
backup_case0

