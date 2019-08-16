function deploy(){
    echo "[INFO] Start deploy"

    if  [ ! -r "$repo_path/$compile_output_path" ] ;then
        echo "[ERROR] make sure the compile target \"$repo_path/$compile_output_path\" exists"
        return 1
    fi
    if  [ -z $remote_ip ] || [ -z $remote_user ] || [ -z $remote_path ] ;then
        echo "[ERROR] remote_ip,remote_user,remote_path is required"
        return 1;
    fi

    # 检查远程是否已经存在该文件
    # !允许手动指定证书
    if [ -z $ssh_key ] ;then
        echo "[WARN] does not specified ssh_key, use default ~/.ssh/id_rsa"
        ssh_key="~/.ssh/id_rsa"
    fi
    if ssh -i $ssh_key -o ConnectTimeout=5 "$remote_user@$remote_ip" "ls $remote_path" &> /dev/null;then
        # no ask
        if ! $yes ;then
            read -p "远程主机上已经存在\"$remote_path\",是否删除?(y/n)" del
            if ! [[ "$del" =~ [yY] ]] ; then
                echo "[WARN] Deploy broken!" 
                return 1
            fi
        fi
        # delete existing files of the same name
        if ! ssh "$remote_user@$remote_ip" "rm -rf $remote_path";then
            echo "[ERROR] delete failed"
        fi
    else    
        echo "[ERROR] ssh login failed, make sure your ssh-key is vaild"
        return 1
    fi
    local from="$repo_path/$compile_output_path/."
    local to="$remote_user@$remote_ip:$remote_path"
    echo "[INFO] from \"$from\" to \"$to\""
    if scp -r "$from" "$to" ; then
        echo "[INFO] Deploy success"
    else 
        echo "[ERROR] Deploy failed"
        return 1
    fi
}