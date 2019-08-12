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
