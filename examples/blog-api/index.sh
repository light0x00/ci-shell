#!/bin/bash

app_base_path=/Users/light/Desktop/my-workbench/java/projects/blog-api 
ci_base_path=/Users/light/Desktop/my-workbench/shells/ci-shell/

# 项目名
name=blog-api
# 仓库路径(文件)
repo=$app_base_path
# 被部署目标
assets=$app_base_path/blog-web/target/blog-api.jar
# 部署路径
to=/home/light/app/blog-api
# 登录
to_ip=47.244.152.125
to_user=light
# 私钥路径
to_key='/Users/light/.ssh/id_rsa_light'
# 部署后在远程执行的脚本
run_script=$ci_base_path/examples/blog-api/run.sh

$ci_base_path/src/index.sh \
--mode=remote \
--skip-pull \
--skip-compile \
--app-name=$name \
--local-path=$repo \
--compile-output-path=$assets \
--remote-ip=$to_ip \
--remote-user=$to_user \
--remote-path=$to \
--ssh-key=$to_key \
--after-deploy=$run_script \
-y


