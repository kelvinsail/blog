title: SourceTree文件导出
tags:
  - sourcetree
  - shell
  - export
categories:
  - Shell
author: yifan
date: 2017-12-01 17:51:00
---
> 写了个Mac下SourceTree文件导出功能的shell脚本，用于自定义操作，可实现类似于TortoiseGit的导出文件功能

1. 脚本内容
<!-- more -->
```
#!/bin/bash
# yifan 2017-12-01

DATE=`date +%m%d`
INIT_PATH=${1%/}
FILE_PATH=${2%/}
#自定义保存的位置
BASE_PATH="/Users/yifan/FileZilla/copy/$DATE"
SAVE_PATH=""

function checksavepath() {
	#序号，保证每次都是新创建的“日期-[index]”的文件夹
    index=1
    path=${BASE_PATH}"-"$index
    while [ -d $path ]
    do
    	let "index+=1"
    	path=${BASE_PATH}"-"$index
    done
    SAVE_PATH=$path
#    echo "save path: ${SAVE_PATH}"

    mkdir ${SAVE_PATH}
#    touch $SAVE_PATH".log"
}

function getfilefromdir(){
    for file in ` ls $1`
    do
        if [ -d $1"/"$file ]
        then
        	mkdir ${SAVE_PATH}"/"$file
            getfilefromdir $1"/"$file ${SAVE_PATH}"/"$file
        else
            local path="$1"
            local name=$file
            if [ ! -f $SAVE_PATH"/"$name ]
            then
                #确认目录存在，路径不存在则创建
                parent=$(dirname $name)
                #应该补全的文件夹路径
                dirs="${parent#${INIT_PATH}}"
                #文件名
                filename="${var##*/}";
                #补全文件夹
                mkdir -p $2$dirs
                #输出语句
				echo "cp ${path} to $2${dirs}/${filename}"
                #复制文件
                cp ${path} "$2${dirs}/${filename}"
            else
                echo "${path} file already exists"
#                echo "${path}" >> $SAVE_PATH".log" 2>&1
            fi
        fi
    done
}
checksavepath
#遍历所有参数
for arg in $*
do
#判断并排除为项目路径的参数
if [ $arg != $INIT_PATH ]
then
	#复制文件
    getfilefromdir ${INIT_PATH}"/"$arg $SAVE_PATH
fi
done
```
2.修改导出文件的默认路径
BASE_PATH="/Users/yifan/FileZilla/copy/$DATE"
“/Users/yifan/FileZilla/copy/”是我mac上的路径，“/$DATE”是指copy文件下的自动以日期命名的文件，脚本中会自动判断日期命名的文件夹存在不，如果存在，则新建一个日期命名的文件夹并在后面加“-n”，n为自增序号，1-n；

3.添加为自定义操作export

![upload successful](/images/pasted-59.png)

4.选中要导出的文件，右键->自定义操作->export

![upload successful](/images/pasted-58.png)