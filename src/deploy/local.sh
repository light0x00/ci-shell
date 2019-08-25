function deploy(){
    echo "[INFO] Start deploy"

    if [ ! -w $deploy_path ];then
        echo "[ERROR] make sure the deploy_path \"$deploy_path\" exits,and you have write permission!"
        return 1;
    fi

    if  [ ! -r "$compile_output_path" ];then
        echo "[ERROR] make sure the compile target \"$compile_output_path\" exists"
        return 1;
    fi

    local from="$compile_output_path"
    local to=$deploy_path
    
    if [ -e $deploy_path ] ;then
        if ! $yes ;then
            read -p "部署路径已经存在:$deploy_path,是否删除旧文件?(y/n)" del
            if [[ $del != [yY] ]] ; then
                echo "[WARN] Deploy broken"
                return 1
            fi
            rm -rf $deploy_path
        fi
    fi

    echo "[INFO] from $from to $to"

    if cp -a "$compile_output_path/." $deploy_path ; then
        echo "[INFO] Deploy success"
    else 
        echo "[ERROR] Deploy failed"
        return 1
    fi
}