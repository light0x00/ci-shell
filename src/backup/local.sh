function backup(){
    echo "[INFO] Start backup"

    # 目标文件是否存在
    if [ ! -r "$repo_path" ] || [ ! -r "$compile_output_path" ];then
        echo "[ERROR] make sure the backup target(\"$repo_path/$compile_output_path/\") exits, and you have have read permission!"
        return 1
    fi
    # 字段是否缺少
     if  [ -z $remote_ip ] || [ -z $remote_user ] || [ -z $remote_path ] ;then
        echo "[ERROR] remote_ip,remote_user,remote_path is required"
        return 1;
    fi
    # 检查备份目录是否存在于远程主机
    if ! ssh "$remote_user@$remote_ip" "ls $backup_dir" >> /dev/null ;then
        echo "[ERROR] $backup_dir doesn't exits in remote server($remote_ip)"
        return 1
    fi

    if [ -z $app_name ] ; then
        echo "[ERROR] should specify app_name!"
        return 1
    fi

    local backup_path="$backup_dir/$app_name-`date +%Y%m%d%H%M%S`"
    if ! $skip_deploy ; then
        # copy from remote to remote
        echo "[INFO] from: $remote_path to: $ $backup_path"
        if ssh "$remote_user@$remote_ip" "cp -r $remote_path $backup_path" ; then
            echo "[INFO] Backup success"
        else 
            echo "[ERROR] backup failed"
            return 1
        fi
    else
        # copy from local to remote 
        local from="$repo_path/$compile_output_path/"
        local to="$remote_user@$remote_ip:$backup_path"
        echo "[INFO] from: $from to: $ $to"
        if scp -r "$from/." "$to" ;then
            echo "[INFO] Backup success"
        else
            echo "[ERROR] Backup fialed"
            return 1
        fi
    fi
}