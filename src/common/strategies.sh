function load_compile_strategy(){
    case "$compile_strategy" in
    npm)
        source "$base_path/compile/npm.sh"
        ;;
    *)
        if [ ! -x "$compile_strategy" ] ;then
            echo "[ERROR] 编译策略没有指定或无效"
            exit 1;
        fi
        echo "[INFO]将使用自定编译脚本:$compile_strategy"
        source $compile_strategy
        ;;
    esac
}

function load_deploy_strategy(){
    case "$mode" in
    local)
        source "$base_path/deploy/local.sh" 
        ;;
    remote)
        source "$base_path/deploy/remote.sh" 
        ;;
    *)
        echo "[ERROR] have not specified valid mode: $mode" 
        exit 1 ;;
    esac
}

function load_backup_strategy(){
    echo '$mode'
    case "$mode" in
    local)
        source "$base_path/backup/local.sh" 
        ;;
    remote)
        source "$base_path/backup/remote.sh" 
        ;;
    *)
        echo "[ERROR] have not specified valid mode: $mode" 
        exit 1 ;;
    esac
}

