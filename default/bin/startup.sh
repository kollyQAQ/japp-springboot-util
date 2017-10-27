#!/bin/bash

# Java application startup script

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

JAVA_PATH=`which java 2>/dev/null`
if [ -z "$JAVA_PATH" ]; then
    echo "Error: Can't find java"
    exit 1
fi

#Load application setting.
if [ -r "$APP_HOME"/bin/setenv.sh ]; then
  . "$APP_HOME"/bin/setenv.sh
else
    echo "Error: Can't find the bin/setenv.sh file."
    exit 1
fi
#
if [ -z "$MAIN_CLASS_NAME" ]; then
    echo "Error: Please set MAIN_CLASS_NAME in bin/setting.sh"
    exit 1
fi 

#When no TTY is available, don't output to console
have_tty=0
if [ "`tty`" != "not a tty" ]; then
    have_tty=1
fi
#Show setting
if [ $have_tty -eq 1 ]; then
    echo "========================================= "
    echo "Using APP_HOME:     $APP_HOME"
    echo "Using JAVA_PATH:    $JAVA_PATH"
    echo "Using MAIN_CLASS:   $MAIN_CLASS_NAME"
    echo "Using PID_FILE:     $PID_FILE"
    echo "Run By Jar:         $RUN_BY_JAR"
    echo "========================================= "
fi

if [ -f "$PID_FILE" ]; then
    APP_PID=`cat "$PID_FILE"`
    if [ ! -z "$APP_PID" ]; then
        isRunning=`ps -p $APP_PID --no-header -o comm|grep "java"|wc -l`
        if [ "$isRunning" -gt 0  ]; then
            echo "Error: Application is running."
            exit 1
        else
            echo "Warring: PID file is error."
        fi
    fi
fi

#Run application
if [ "$RUN_BY_JAR" -gt 0  ]; then
    nohup "$JAVA_PATH" $JAVA_OPTS -classpath "$JAVA_CLASS_PATH" -jar "$APP_HOME/lib/$MAIN_CLASS_NAME" $APP_ARG > $LogPath/system.log 2>&1 &
else
    "$JAVA_PATH" $JAVA_OPTS -classpath "$JAVA_CLASS_PATH" "$MAIN_CLASS_NAME" $APP_ARG 2> $LogPath/system.log &
fi
#get java application pid
/bin/ps -ef|/bin/grep "JAPP_FLAG=JAPP"|/bin/grep "$MAIN_CLASS_NAME"|/bin/grep "$APP_HOME/lib"|/bin/grep -v "/bin/grep"
APP_PID=`/bin/ps -ef|/bin/grep "JAPP_FLAG=JAPP"|/bin/grep "$MAIN_CLASS_NAME"|/bin/grep "$APP_HOME/lib"|/bin/grep -v "/bin/grep"|/bin/awk '{print $2}'`

echo $APP_PID > $PID_FILE
