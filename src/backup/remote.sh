# required: backup_dir  repo_path  compile_output_path app_name
function backup(){
    echo "[INFO] Start backup"
    
    if [ ! -r "$repo_path" ] || [ ! -r "$compile_output_path" ];then
        echo "[ERROR] make sure the backup target(\"$compile_output_path/\") exits, and you have have read permission!"
        return 1
    fi
    if [ ! -w $backup_dir ] ;then
        echo "[ERROR] specify backup_dir,and make sure you have have write permission!"
        return 1
    fi

    if [ -z $app_name ] ; then
        echo "[ERROR] should specify app_name!"
        return 1
    fi

    local from="$compile_output_path/"
    local to="$backup_dir/$app_name-`date +%Y%m%d%H%M%S`"
    echo "[INFO] from: $from to: $to"
    if cp -r "$from/" "$to" ;then
        echo "[INFO] Backup success"
    else
        echo "[ERROR] Backup fialed"
        return 1
    fi
}
