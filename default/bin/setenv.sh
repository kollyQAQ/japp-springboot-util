#!/bin/sh

#必须设置APP_HOME或从startup.sh调用
if [ -z "$APP_HOME" ]; then
    echo "Your must set APP_HOME before run this script."
    exit 1
fi

#配置文件
if [ -r "$APP_HOME"/setting.sh ]; then
    . "$APP_HOME"/setting.sh
else
    echo "Can't find the setting file: setting.sh"
    exit 1 
fi

#默认的CLASSPATH
JAVA_CLASS_PATH=".:/usr/local/jlib/lib/*:$APP_HOME/lib/*:$APP_HOME/classes"
if [ -n "$APP_CLASS_PATH" ]; then
    JAVA_CLASS_PATH="$APP_CLASS_PATH:$JAVA_CLASS_PATH"
fi

#检查是否有重复的Jar文件
if [ "$CHK_DUP_JAR" -gt 0 ]; then
    if [ -r "$APP_HOME"/bin/chkdupjar.sh ]; then
        . "$APP_HOME"/bin/chkdupjar.sh
    else
        echo "Can't find bin/chkdupjar.sh file"
        exit 1
    fi
fi

if [ "$RUN_AS_DAEMON" -gt 0 ]; then
    RUN_AS_DAEMON="-server "
else
    RUN_AS_DAEMON=""
fi

JAVA_OPTS="${RUN_AS_DAEMON}${JAVA_MEMORY_OPTS} $JAVA_MONITOR_OPTS $JAVA_APP_OPTS $JAVA_GC_OPTS -DJAPP_FLAG=JAPP -Dlog_path=${LogPath}/app -Drunlog.dir=${LogPath}/app/runlog -Dbusilog.dir=${LogPath}/app/busilog -Dfile.encoding=utf8" 
