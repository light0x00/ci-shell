
function open_ssh_agent(){
    echo "[INFO] open ssh-agent"
    # !允许手动指定证书
    if [ -z $ssh_key ] ;then
        echo "[WARN] No ssh_key specified, use default ~/.ssh/id_rsa"
        ssh_key="$HOME/.ssh/id_rsa"
    fi
    if ! [ -r $ssh_key ] ; then
        echo "[ERROR] make sure the ssh_key($ssh_key) exists,and you have permission"
        return 1;
    fi
    eval `ssh-agent`
    ssh-add $ssh_key
}

function close_ssh_agent(){
    echo "[INFO] close ssh-agent"
    kill $SSH_AGENT_PID
}

function exec_script(){
    local script=$1
    if [ -r "$script" ] ;then
        script=`cat $script`
    fi

    if [ -n "$script" ] ;then
        case "$mode" in
        local)
            echo "[INFO] exec local script"
            eval $script
            shift;;
        remote)
            echo "[INFO] exec remote script"
            ssh -o ConnectTimeout=5 "$remote_user@$remote_ip" "$script"
            shift;;
        *)
            echo "[ERROR] unknown mode: $mode" 
            return 1;
        esac
    fi

}

# 在远程执行shell
function rpc(){
    if [ -z $0 ] ; then
        echo "[WARN] 要执行的脚本为空!"
    fi
    ssh $remote_user@$remote_ip "$0"
}

function random_file_path(){
    `mktemp /tmp/$app_name.XXXXXX`
}

function random_dir_path(){
    `mktemp -d /tmp/$app_name.XXXXXX`
}

# 拉取代码
function pull(){
    echo "[INFO] Start pull"
    # check args
    if [ -z $git_url ]; then
        echo "[ERROR] git url is required!"
        return 1
    fi

    # # extract repo name from git_url (sed这让人吐血的水货正则)
    # if [ -z $app_name ] ; then
    #     app_name=$(sed -n '1s/.*\/\([^\/\.]*\)\(.git\)*$/\1/1p' <<< $git_url)
    # fi

    # ensure repo_path
    if [ -z $repo_path ];then
        repo_path=`mktemp -d /tmp/$app_name.XXXXXX`
        echo "[INFO] repo path is not specified,use tmp path: $repo_path"
    elif [ ! -d $repo_path ];then
        echo "[ERROR] the specifed repo_path \"$repo_path\" doesn't exist or is not a dir"
        return 1
    fi

    cd $repo_path

    # clone or pull
    if git status &> /dev/null ;then
        # pull
        echo "[INFO] Start pull..."
        git reset --hard
        git pull $git_url $git_branch
        git checkout $git_branch
    else
        # clone
        echo "[INFO] Start cloning repo..."
        if ! git clone $git_url -b $git_branch $repo_path --depth 1; then
            echo "[ERROR] An error occurred during cloning!"
            return 1
        fi
        git checkout $gitBranch
    fi
}
