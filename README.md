### 基于tomcat快速创建J2EE工程结构

### 创建工程
```
[root@localhost jweb-tomcat-util]# sh service.sh create testPrj
Please input the owner of this application:root
New application is created sucessfully!
Please change default settings!
```
此时会发现已经有了testPrj这个目录，进入看看
```
[root@localhost jweb-tomcat-util]# cd testPrj/
[root@localhost testPrj]# ll
total 20
drwxr-xr-x. 2 root root 4096 Oct 25 04:05 bin
drwxr-xr-x. 2 root root  184 Oct 25 04:05 conf
drwxr-xr-x. 2 root root 4096 Oct 25 04:05 lib
lrwxrwxrwx. 1 root root   21 Oct 25 04:05 logs -> /data/jweblog/testPrj
-rwxr-xr-x. 1 root root  595 Oct 25 04:05 monitorsetting.sh
-rw-r--r--. 1 root root    5 Oct 25 04:05 owner.txt
-rwxr-xr-x. 1 root root  595 Oct 25 04:05 setting.sh
drwxr-xr-x. 2 root root   99 Oct 25 04:05 temp
```
修改settint.sh来配置你的JAVA_MEMORY_OPTS、JAVA_GC_OPTS、JAVA_APP_OPTS也就是JVM参数tomcat变量
注意这里建立了一个软链接`logs -> /data/jweblog/testPrj`,所以请手动建立`/data/jweblog/testPrj`目录并保证目录中有catalina.out文件
此软链接的目的是有多个工程的情况下，日志统一集中在`/data/jweblog`目录管理，方便查看


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
