#!/bin/bash

#
#����ظ���jar��
#

#����Path
PATH=/usr/local/bin:/usr/bin:/bin:$PATH
export PATH

#��סԭ����Ŀ¼
srcInPath=`pwd`

#��������APP_HOME���startup.sh����
if [ -z "$APP_HOME" ]; then
  echo "Your must set APP_HOME before run this script."
  exit 1
fi

#׼����ʱ����Ŀ¼
tmpWorkPath="$APP_HOME/tmp/chkjar"
if [ ! -d "$tmpWorkPath" ]; then
  mkdir -p "$tmpWorkPath"
  if [ "$?" -ne "0" ]; then
    echo "Can't create temp directory: $tmpWorkPath"
    exit 1
  fi
fi

#����Ƿ���Ȩ��
touch "$tmpWorkPath/jarDir.list"
if [ "$?" -ne "0" ]; then
  echo "Can't create temp file: $tmpWorkPath/jarDir.list"
  exit 1
fi

#�ҳ���Ҫ����Ŀ¼
#echo "/usr/local/javalib/lib" > "$tmpWorkPath/jarDir.list"
#echo "/usr/local/javalib/th3rdlib" >> "$tmpWorkPath/jarDir.list"
echo "$APP_HOME/lib" >> "$tmpWorkPath/jarDir.list"

#����APP_CLASS_PATH�е�·��
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

#jar.list ���е�jar�ļ��б�
echo "" > "$tmpWorkPath/jar.list"
for line in `cat $tmpWorkPath/jarDir.list`
do
  if [ -d "$line" ]; then
    cd $line
    find ./ -type f -name "*.jar" >> "$tmpWorkPath/jar.list"
  fi
done


#ȥ�����еİ汾���
less "$tmpWorkPath/jar.list"|sed 's/[-0-9\.\/_]//g'|sort|uniq -d > "$tmpWorkPath/dupjar.list"

#�ж��Ƿ����ظ�
dupJarNum=`less "$tmpWorkPath/dupjar.list"|wc -l`
if [ "$dupJarNum" -gt 0  ]; then
  echo "Can't startup Japp, here is dupliate jar file:"
  #��ʾ�ļ���
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


#����ԭ����Ŀ¼
cd "$srcInPath"
