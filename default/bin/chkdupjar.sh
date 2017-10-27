#!/bin/bash

#
#检查重复的jar包
#

#设置Path
PATH=/usr/local/bin:/usr/bin:/bin:$PATH
export PATH

#记住原来的目录
srcInPath=`pwd`

#必须设置APP_HOME或从startup.sh调用
if [ -z "$APP_HOME" ]; then
  echo "Your must set APP_HOME before run this script."
  exit 1
fi

#准备临时工作目录
tmpWorkPath="$APP_HOME/tmp/chkjar"
if [ ! -d "$tmpWorkPath" ]; then
  mkdir -p "$tmpWorkPath"
  if [ "$?" -ne "0" ]; then
    echo "Can't create temp directory: $tmpWorkPath"
    exit 1
  fi
fi

#检查是否有权限
touch "$tmpWorkPath/jarDir.list"
if [ "$?" -ne "0" ]; then
  echo "Can't create temp file: $tmpWorkPath/jarDir.list"
  exit 1
fi

#找出需要检查的目录
#echo "/usr/local/javalib/lib" > "$tmpWorkPath/jarDir.list"
#echo "/usr/local/javalib/th3rdlib" >> "$tmpWorkPath/jarDir.list"
echo "$APP_HOME/lib" >> "$tmpWorkPath/jarDir.list"

#处理APP_CLASS_PATH中的路径
if [ -n "$APP_CLASS_PATH" ]; then
    TMP_JAR_PATH=`echo $APP_CLASS_PATH|tr "*" " "|tr ":" " "`
    for T_P in $TMP_JAR_PATH
    do
        if [ -z "$T_P" ]; then
            continue
        fi
        echo $T_P >> "$tmpWorkPath/jarDir.list"
    done
fi

#jar.list 所有的jar文件列表
echo "" > "$tmpWorkPath/jar.list"
for line in `cat $tmpWorkPath/jarDir.list`
do
  if [ -d "$line" ]; then
    cd $line
    find ./ -type f -name "*.jar" >> "$tmpWorkPath/jar.list"
  fi
done


#去掉所有的版本编号
less "$tmpWorkPath/jar.list"|sed 's/[-0-9\.\/_]//g'|sort|uniq -d > "$tmpWorkPath/dupjar.list"

#判断是否有重复
dupJarNum=`less "$tmpWorkPath/dupjar.list"|wc -l`
if [ "$dupJarNum" -gt 0  ]; then
  echo "Can't startup Japp, here is dupliate jar file:"
  #显示文件名
  for jarFile in `cat "$tmpWorkPath/jar.list"`
  do
    tempJarFileName=`echo "$jarFile"|sed 's/[-0-9\.\/_]//g'`
    inDupJarFile=`grep "$tempJarFileName" "$tmpWorkPath/dupjar.list"|wc -l`
    if [ "$inDupJarFile" -gt 0 ]; then
      echo "$jarFile"
    fi
  done
  exit 1
fi


#进入原来的目录
cd "$srcInPath"
