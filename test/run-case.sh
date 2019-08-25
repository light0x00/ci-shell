source `dirname $0`/prepare.sh

repo_path=/Users/light/Desktop/my-workbench/blog

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

function run_case3(){

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
    --ssh-key=/Users/light/.ssh/id_rsa_light \
    --after-deploy=/Users/light/Desktop/my-workbench/shells/ci-shell/test/run-task.sh 
    # -y
}

# 测试从标准输入
function run_case4(){

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
    --ssh-key=/Users/light/.ssh/id_rsa_light \
    <<< 'echo "echo $remote_ip >> ~/test.txt"' \
    -y
}



run_case4
