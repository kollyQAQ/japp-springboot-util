#!/bin/sh

#
# Java Application Startup Setting
#

#Java main class (must set)
MAIN_CLASS_NAME="configcenter-0.0.1-SNAPSHOT.jar"

#Java memory 
JAVA_MEMORY_OPTS="-Xms128m -Xmx256m -XX:PermSize=128m -XX:MaxNewSize=256m -XX:MaxPermSize=128m -XX:+HeapDumpOnOutOfMemoryError"

JAVA_APP_OPTS="-jar -Dcfg.env=idc"
#Java gc
JAVA_GC_OPTS="-XX:+UseParallelGC -XX:+UseParallelOldGC"

#Language
export LC_ALL="zh_CN.utf8"

#Log path
LogPath="/data/japplog/japp_tuan_configcenter"

#Run mode
RUN_AS_DAEMON=1

#Check duplicate
CHK_DUP_JAR=0

#IP (Don't set)
LOCAL_IP=""

RUN_BY_JAR=1
