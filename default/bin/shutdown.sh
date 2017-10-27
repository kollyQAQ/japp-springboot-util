#!/bin/bash

# Java application shutdown script

MAX_SHUTDOWN_TIME=10

#Export PATH
PATH=/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:$PATH
export PATH
checkEnv=`env|grep MACHTYPE|wc -l`
if [ "$checkEnv" -lt 1 ]; then
    . /etc/profile
fi

#resolve links - $0 may be a softlink
PRG="$0"
while [ -h "$PRG" ]; do 
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

#Get standard environment variables
PRGDIR=`dirname "$PRG"`
#Only set APP_HOME if not already set
[ -z "$APP_HOME" ] && APP_HOME=`cd "$PRGDIR/.." ; pwd`
PID_FILE="$APP_HOME/run/app.pid"

#$1:pid
function chkJavaProcess {
    local pid="$1"
    local isRunning=0
    if [ -z "$pid" ]; then
        echo "Error: error pid."
    fi
    isRunning=`ps -p $pid --no-header -o comm|grep "java"|wc -l`
    if [ "$isRunning" -gt 0  ]; then
        return 0 
    else
        return 1
    fi    
}

#$1:pid
function stopJavaProcess {
    local pid="$1"
    if [ -z "$pid" ]; then
        echo "Error: error pid."
    fi
    kill $pid

    for ((i=0; i<MAX_SHUTDOWN_TIME*10; i++)); do
        chkJavaProcess $pid
        if [ "$?" -ne 0 ]; then
             return 0
        fi
        sleep 0.1
    done
    
    echo "Application don't shutdown within $MAX_SHUTDOWN_TIME seconds, sending SIGKILL..."
    kill -9 $pid
    for ((i=0; i<MAX_SHUTDOWN_TIME*10; i++)); do
        chkJavaProcess $pid
        if [ "$?" -ne 0 ]; then
             return 0
        fi
        sleep 0.1
    done
    echo "Fail to shutdown."
    return 1
}

if [ -f "$PID_FILE" ]; then
    APP_PID=`cat "$PID_FILE"`
    if [ ! -z "$APP_PID" ]; then
        chkJavaProcess $APP_PID
        if [ "$?" -eq 0  ]; then
            stopJavaProcess $APP_PID
        else
            echo "Warning: PID file is error."
        fi
    else
        echo "Warning: PID file is error."
    fi
else
    echo "Warning: This application is not running."
fi

#Delete pid file
rm -f "$PID_FILE"
exit 0
