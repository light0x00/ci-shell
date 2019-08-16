
#!/bin/bash

function help_info(){
    echo "-m,--mode    部署到本地或远程主机"
    echo "--compile-strategy   编译策略,可以指定自定义编译脚本的路径,该脚本需要定义一个名为\"compile\"的function"
    echo "--git-url    代码仓库url(required)"
    echo "--git-branch   分支(默认: master)"
    echo "--local-path,--repo_path   代码仓库保存在哪里(默认: 生成一个临时目录在/tmp)"
    echo "--compile-output-path   编译结果的路径(相对于代码仓库)"
    echo "--ssh-key   登录远程使用的的私钥路径"
    echo "--remote-ip   远程主机ip"
    echo "--remote-user   远程主机的用户名"
    echo "--remote-path   部署的远程主机路径(remote模式使用)"
    echo "--deploy-path     部署的路径(local模式使用)"
    echo "--skip-compile    跳过编译"
    echo "--skip-pull   不更新本地代码仓库"
    echo "--skip-deploy   不部署(凑数的)"
    echo "--backup-dir    指定后将会备份项目到此目录,备份名为:app_name+日期后缀(格式: yyyy-MM-DDThh:mm:ss+z)."
    echo "--app-name    指定app_name(默认: 代码仓库名称)"
}

mode=''
app_name=''
git_url=''
git_branch="master"
local_path=''
repo_path=''
deploy_path=''
compile_output_path=''
compile_strategy=''
ssh_key=''
remote_ip=''
remote_user=''
remote_path=''
skip_compile=false
skip_pull=false
skip_deploy=false
backup_dir=''
yes=false

set -- $(getopt -u -o yh --long '
mode:,
app-name:,
git-url:,
git-branch:,
local-path:,
repo-path:,
compile-strategy:,
compile-target-path:,
compile-output-path:,
ssh-key:,
remote-ip:,
remote-user:,
remote-path:,
deploy-path:,
skip-pull,
skip-compile,
skip-deploy,
backup-dir:,
yes,
help' -n "集成部署工具" -- $@)

while [ -n "$1" ]
do
    case "$1" in
        --mode)
            mode="$2"
            shift;;
        --app-name)
            app_name="$2"
            shift;;
        --git-url) 
            git_url="$2"
            shift;;
        --git-branch) 
            git_branch="$2"
            shift;;
        --local-path|--repo-path)
            local_path="$2"
            repo_path="$2"
            shift;;
        --compile-strategy)
            compile_strategy="$2"
            shift;;
        --compile-target-path)
            echo "[WARN] compile-target-path is deprecated"
            compile_output_path="$2"
            compile_output_path="$2"
            shift;;
        --compile-output-path)
            compile_output_path="$2"
            shift;;
        --ssh-key)
            ssh_key="$2"
            shift;;
        --remote-ip)
            remote_ip="$2"
            shift;;
        --remote-user)
            remote_user="$2"
            shift;;
        --remote-path|--deploy-path)
            remote_path="$2"
            deploy_path="$2"
            shift;;
        --backup-dir)
            backup_dir="$2"
            shift;;
        --skip-pull)
            skip_pull=true;;
        --skip-compile)
            skip_compile=true;;
        --skip-deploy)
            skip_deploy=true;;
        -y|--yes)
            yes=true;;
        -h|--help)
            help_info
            exit 0;;
        --)
            ;;
        *)
            echo "[ERROR] $1 is not an option"
            exit 1;
    esac
    shift
done



# ============================================================ 
if [ -z $app_name ] ; then
    if [ -z $git_url ] ; then
        echo "[ERROR] should specify at least one of git_url or app_name!"
        exit 1
    fi
    app_name=$(sed -n '1s/.*\/\([^\/\.]*\)\(.git\)*$/\1/1p' <<< $git_url)  # (sed这让人吐血的水货正则)
fi



# 得到运行时根路径
base_path=`dirname $(readlink "$0") &> /dev/null`
if [ -z $base_path ] ;then
    base_path=`dirname $0`
fi

set -o errexit

# ============================================================

source  "$base_path/common/strategies.sh"
# 1. pull
if ! $skip_pull ; then
    source "$base_path/common/pull.sh"
    pull
fi

# 2. compile
if ! $skip_compile ; then
    load_compile_strategy
    compile
fi

# 3. deploy
if ! $skip_deploy ; then
    load_deploy_strategy
    deploy
fi

# 4. backup
if [ -n "$backup_dir" ] ; then
    load_backup_strategy
    backup
fi
