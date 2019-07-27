#!/bin/bash

statu=$(cat is_install)
if [ "$statu" = "false" ];then
# 将已部署状态设置为true
echo true > is_install

# 重新生成静态文件
cd /home/wwwroot/temp/hexo.source
hexo clean && hexo g

# 删除原有的站点文件夹中的文件
rm -rf /home/wwwroot/blog.kelvinsail.com/*
# 复制新的文件到站点目录中
/bin/cp -rf public/* /home/wwwroot/blog.kelvinsail.com

#mkdir /home/wwwroot/blog.old
#chown jenkins:jenkins /home/wwwroot/blog.old
#mkdir /home/wwwroot/blog.kelvinsail.com.new
#/bin/cp -rf public/* /home/wwwroot/blog.kelvinsail.com.new
#mv /home/wwwroot/blog.kelvinsail.com /home/wwwroot/blog.old/blog.kelvinsail.com."$(date '+%Y%m%d%H%M%S')"
#mv /home/wwwroot/blog.kelvinsail.com.new /home/wwwroot/blog.kelvinsail.com

fi




