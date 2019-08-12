#!/usr/local/bin/bash
function compile(){
    if [ ! -d "$repo_path" ];then
        echo "[ERROR] repo_path doesn't exists or not specified:$repo_path"
        return 1
    fi
    cd $repo_path
    echo "[INFO] Start compile"
    npm install && npm run prod
    if $?; then
        echo "[INFO] compile success"
    else
        echo "[ERROR] compile failed"
        return 1;
    fi
}