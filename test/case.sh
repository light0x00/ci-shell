#!/bin/bash

repo_path=/Users/light/Desktop/my-workbench/blog

base_path=`dirname $(readlink "$0") &> /dev/null`
if [ -z $base_path ] ;then
    base_path=`dirname $0`
fi

src_base_path=`cd $base_path;cd ../src/ ; pwd`

# ===============================测试代码更新
function pull_case(){
    $src_base_path/index.sh \
    --mode=local \
    --git-url=https://github.com/light0x00/blog.git \
    --skip-compile \
    --skip-deploy
}

# pull_case

# ===============================测试编译
# 测试内置编译脚本
function compile_case0(){
    $src_base_path/index.sh \
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
    $src_base_path/index.sh \
    --skip-pull \
    --skip-deploy \
    --mode=remote \
    --app-name=blog \
    --repo-path=/tmp/blog.7N6KS8 \
    --compile-strategy='deploy/test/mvnw.sh'
}
# compile_case1



# ===============================测试备份

function backup_case0(){
    $src_base_path/index.sh \
    --app-name=blog\
    --skip-pull \
    --skip-compile \
    --mode=remote \
    --local-path=/tmp/blog.7N6KS8 \
    --compile-target-path=dist \
    --remote-ip=47.244.152.125 \
    --remote-user=light \
    --remote-path=/home/light/app/blog/ \
    --backup-dir=/home/light/app-backup
    # -y
}
# backup_case0


# ===============================测试远程执行脚本

function run_case0(){
    $src_base_path/index.sh \
    --mode=remote \
    --app-name=blog\
    --skip-pull \
    --skip-compile \
    --local-path=$repo_path \
    --compile-output-path=dist \
    --mode=remote \
    --remote-ip=47.244.152.125 \
    --remote-user=light \
    --remote-path=/home/light/app/blog \
    --ssh-key=/Users/light/.ssh/id_rsa_light \
    --after-deploy=/Users/light/Desktop/my-workbench/shells/ci-shell/test/test.sh 
}

function run_case1(){
    $src_base_path/index.sh \
    --mode=remote \
    --app-name=blog\
    --skip-pull \
    --skip-compile \
    --local-path=$repo_path \
    --compile-output-path=dist \
    --mode=remote \
    --remote-ip=47.244.152.125 \
    --remote-user=light \
    --remote-path=/home/light/app/blog \
    --ssh-key=/Users/light/.ssh/id_rsa_light \
    <<< "echo 'Bonjour'" \
    -n
}

# run_case1
