➡️[english](README.en.md)

一个自动化部署工具,基本上你只需要指定几个路径(如:源码路径、部署路径)即可实现部署的自动化, 可以搭配ci工具,如jekins、travis等一起使用.

---

# 环境要求:

1. bash版本>`3.2.57`
2. 有gnu版本的getopts(cent-os自带)

---

# 安装:

```bash
git clone [path]
chmod u+x [path]/deploy/src/index.sh
# 如果经常使用建议使用别名
alias ci-shell=[path]/deploy/src/index.sh
# 或者使用软连接
ln -s
```

---

# 使用

## 命令格式

下面是两种常见场景下的配置参数格式:

部署到远程

```bash
./deploy/src/index.sh
    --mode=remote
    --git-url=[仓库]
    --git-branch=[分支]
    --local-path=[保存仓库的路径]
    --compile-strategy=[编译策略]   # 可以指定用于编译你的项目的自定义脚本,详见下文.
    --compile-target-path=[编译结果路径]  # 相对于保存仓库的路径,比如java项目一般是target(聚合项目输入子模块的路径),前端一般为dist
    --remote-ip=[目标服务器ip] 
    --remote-user=[登录服务器用户] 
    --remote-path=[部署在服务器的路径]
```

部署到本地

```bash
./src/index.sh 
    --mode=local 
    --git-url=[仓库]
    --git-branch=[分支]
    --local-path=[保存仓库的路径]
    --deploy-path=[部署在当前主机的路径]
    --compile-strategy=[编译策略]
    --compile-target-path=[编译结果路径] 

```


## 定义编译策略

每个项目的编译过程是不可预知的,内置编译脚本并不现实. 所以,编译是由你自定义的编译脚本来完成的. 

下面是一个npm项目的编译例子,你的脚本中只需要定义一个名为compile的方法,在这个方法中你可以使用所有你在执行`ci-shell`时所设置的参数

1. 定义的你编译脚本

    ```bash
    function compile(){
        # 1. 进入项目的本地仓库
        cd $repo_path
        # 2. 执行编译
        npm install && npm run prod
    }
    ```

2. 执行`ci-shell`

    ```
    ./src/index.sh 
        --compile-strategy=[你的脚本路径]
        ...其他参数
    ```

## 备份部署文件

如果你有备份每一次部署(的项目)的需求,就像下面这样.

```txt
app-backup/
├── app-20190812142558
├── app-20190812143608
├── app-20190812143918
└── app-20190812144607
```

只需要附加如下参数即可:

```txt
./src/index.sh 
    --backup-dir=[用于存放备份的目录]
    ...其他参数
```

`ci-shell`会在每一次部署成功后,复制部署文件到备份目录,命令为`[app_name]-yyyyMMDDhhmmss`

