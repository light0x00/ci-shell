#!/bin/bash


source `dirname $0`/prepare.sh


# ===============================测试部署
repo_path=/Users/light/Desktop/my-workbench/blog

# 部署到远程
function deploy_case0(){
    $src_base_path/index.sh \
    --app-name=blog\
    --skip-pull \
    --skip-compile \
    --mode=remote \
    --local-path=$repo_path \
    --compile-target-path=dist \
    --remote-ip=47.244.152.125 \
    --remote-user=light \
    --remote-path=/home/light/app/blog \
    --ssh-key=/Users/light/.ssh/id_rsa_light \
    <<< '/usr/sbin/service nginx reload'
    # -y
}
# deploy_case0

# 部署到本地
function deploy_case1(){
    $src_base_path/index.sh \
    --app-name=blog \
    --skip-pull \
    --skip-compile \
    --mode=local \
    --local-path=$repo_path \
    --compile-output-path=dist \
    --deploy-path=/Users/light/Desktop/tmp/blog \
    -y \
   <<< 'echo $USER'
}
# deploy_case1


function deploy_case2(){

    # compile_output_path='/Users/light/Desktop/my-workbench/java/projects/blog-api/blog-core/target/blog-core-0.0.1-SNAPSHOT.jar'
    compile_output_path='/Users/light/Desktop/FarBox_files'

    $src_base_path/index.sh \
    --app-name=blog \
    --skip-pull \
    --skip-compile \
    --mode=remote \
    --local-path=$repo_path \
    --compile-output-path=$compile_output_path \
    --remote-ip=47.244.152.125 \
    --remote-user=light \
    --remote-path=/home/light/app/farbox \
    --ssh-key=/Users/light/.ssh/id_rsa_light 
    # -y
}

deploy_case2