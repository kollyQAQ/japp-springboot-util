### 快速创建japp springboot工程结构
拷贝本项目的default目录和service.sh文件到你的服务器的准备存放java工程的workspace目录下，效果如下
```
[root@localhost workspace]# ll
total 0
drwxr-xr-x. 5 root root 83 Oct 25 04:05 default
-rwxr-xr-x. 5 root root 522 Oct 25 04:05 service.sh
```
### 创建工程
```
[root@localhost workspace]# sh service.sh create testPrj
Please input the owner of this application:root
New application is created sucessfully!
Please change default settings!
```
此时会发现已经有了testPrj这个目录，进入看看
```
[root@localhost workspace]# cd testPrj/
[root@localhost testPrj]# ll
total 20
drwxr-xr-x. 2 root root  80 Oct 26 22:41 bin
drwxr-xr-x. 2 root root   6 Oct 26 22:41 classes
drwxr-xr-x. 2 root root   6 Oct 26 22:41 etc
drwxr-xr-x. 2 root root   6 Oct 26 22:41 lib
lrwxrwxrwx. 1 root root  21 Oct 26 22:41 logs -> /data/japplog/testPrj
-rw-r--r--. 1 root root   5 Oct 26 22:41 owner.txt
drwxr-xr-x. 2 root root   6 Oct 26 22:41 run
-rwxr-xr-x. 1 root root 571 Oct 26 22:41 setting.sh
drwxr-xr-x. 2 root root   6 Oct 26 22:41 tmp
```
* 修改settint.sh来配置你的JAVA_MEMORY_OPTS、JAVA_GC_OPTS、JAVA_APP_OPTS也就是JVM参数和tomcat变量
* 务必修改settint.sh中的MAIN_CLASS_NAME变量为你的springboot最终的jar包名称
* 务必修改settint.sh中的LogPath为你的日志目录，这个例子中应该修改为`/data/japplog/testPrj`
* 注意这里建立了一个软链接`logs -> /data/japplog/testPrj`,所以请手动建立`/data/japplog/testPrj`目录并保证目录中有system.log文件
此软链接的目的是有多个工程的情况下，日志统一集中在`/data/japplog`目录管理，方便查看


### 启动、停止、重启工程
启动工程
```
sh service.sh start testPrj
```
停止工程
```
sh service.sh stop testPrj
```
重启工程
```
sh service.sh restart testPrj
```

### 其他命令
`sh service.sh start/stop/restart/show/status/create/check/monitor/cleanlog appName`
懂一点shell的可以看一下service.sh是实现便知道各个命令的作用了
