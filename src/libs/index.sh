
# 对外提供辅助函数
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

function exec_script_remote(){

    echo "[INFO] Start exec remote script"
    local script="$@"
    echo "$script"
    if [ -r "$script" ] ;then
        ssh -o ConnectTimeout=5 "$remote_user@$remote_ip" 'bash' < "$script"
    elif [ -n "$script" ] ;then
        ssh -o ConnectTimeout=5 "$remote_user@$remote_ip" "ssh $script"
    fi
}

function deploy_to_remote(){
    echo "[INFO] Start deploy"

    if  [ ! -r "$assets_path" ] ;then
        echo "[ERROR] make sure the compile target \"$assets_path\" exists"
        return 1
    fi
    if  [ -z $remote_ip ] || [ -z $remote_user ] || [ -z $remote_path ] ;then
        echo "[ERROR] remote_ip,remote_user,remote_path is required"

        return 1;
    fi

    # 测试是否可以连接
    if ! ssh -o ConnectTimeout=10 "$remote_user@$remote_ip" 'ls &> /dev/null';then
         echo "[ERROR] ssh login failed, make sure your ssh-key is vaild"
        return 1
    fi

    # 如果远程已经存在该文件,询问是否删除
    if ssh "$remote_user@$remote_ip" "if [ -e $remote_path ] ;then exit 0 ;else exit 1; fi; " ;then
            # no ask
        if ! $yes ;then
            echo -n "远程主机上已经存在\"$remote_path\",是否删除?(y/n)"
            read del < /dev/tty
            if ! [[ "$del" =~ [yY] ]] ; then
                echo "[WARN] Deploy broken!"
                return 1
            fi
        fi

        # delete existing files of the same name
        if ! ssh "$remote_user@$remote_ip" "rm -rf $remote_path";then
            echo "[ERROR] delete failed"
            return 1
        fi
    fi
    # 确定from、to
    local from
    if [ -d "$assets_path" ] ;then
        from="$assets_path/."
    else
        from="$assets_path"
    fi
    local to="$remote_user@$remote_ip:$remote_path/"

    # 创建部署目录
    ssh "$remote_user@$remote_ip" "mkdir $remote_path"

    echo "[INFO] from \"$from\" to \"$to\""
    # 拷贝
    if scp -r "$from" "$to" ; then
        echo "[INFO] Deploy success"
    else
        echo "[ERROR] Deploy failed"
        return 1
    fi
}