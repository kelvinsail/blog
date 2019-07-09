title: Gitlab 迁移
author: yifan
tags:
  - Gitlab
  - Gitlab迁移
categories:
  - CentOS
  - Gitlab
  - ''
  - ''
date: 2019-05-15 10:10:00
---
# 备份Gitlab
> 虽然不停止gitlab链接也能够正常备份，但最好关闭gitlab（主要保持postgresql、redis运行状态）之后再进行备份，以防备份迁移期间有同事或其他人提交了代码；
## 查看版本
```
[root@localhost /]# head -1 /opt/gitlab/version-manifest.txt
gitlab-ce 8.16.4
```

## 停止gitlab部分进程
```
gitlab-ctl stop unicorn
gitlab-ctl stop sidekiq
gitlab-ctl stop nginx
```
<!-- more --->

## 备份
```
[root@localhost wwwroot]# gitlab-rake gitlab:backup:create
Dumping database ... 
Dumping PostgreSQL database gitlabhq_production ... [DONE]
done
Dumping repositories ...
 * xxx/xxx ... [DONE]
done
Dumping uploads ... 
done
Dumping builds ... 
done
Dumping artifacts ... 
done
Dumping lfs objects ... 
done
Dumping container registry images ... 
[DISABLED]
Creating backup archive: 1557887510_2019_05_15_gitlab_backup.tar ... done
Uploading backup archive to remote storage  ... skipped
Deleting tmp directories ... done
done
done
done
done
done
done
Deleting old backups ... skipping
```
## 打包配置文件
```
[root@localhost  /]# zip -r gitlab_config.zip /etc/gitlab
```


# 配置新服务器

## 安装Gitlab

> 安装与旧服务器同一版本的Gitlab，具体参考 [GitLab安装](http://blog.kelvinsail.com/2019/05/08/CentOS/CentOS-%E9%83%A8%E7%BD%B2Gitlab/) 

## 将备份与配置文件复制到新服务器上
> 将gitlab.rb还原到 `/etc/gitlab/gitlab.rb` 后，运行配置命令
```
gitlab-ctl reconfigure
```

## 将tar备份文件复制到新服务器备份目录
```
mv 1519617101_2018_02_26_gitlab_backup.tar  /var/opt/gitlab/backups/1519617101_2018_02_26_gitlab_backup.tar
```
## 开始还原
```
gitlab-rake gitlab:backup:restore BACKUP=1519617101_2018_02_26
```
> 注意：‘BACKUP=’后面的标签内容，即为`1519617101_2018_02_26_gitlab_backup.tar`文件名的前半部分时间戳名称，根据备份文件名称自行定义，并且还原会清空原有的Gitlab数据库、仓库代码、以及授权key，过程会有交互提示需要输入yes/no。

```
[root@localhost /]# gitlab-rake gitlab:backup:restore BACKUP=1519617101_2018_02_26
Unpacking backup ... done
Before restoring the database we recommend removing all existing
tables to avoid future upgrade problems. Be aware that if you have
custom tables in the GitLab database these tables and all data will be
removed.

Do you want to continue (yes/no)? yes
Removing all tables. Press `Ctrl-C` within 5 seconds to abort
Cleaning the database ... 
done
Restoring database ... 
Restoring PostgreSQL database gitlabhq_production ... SET
SET
SET
SET

·····

Restoring lfs objects ... 
done
This will rebuild an authorized_keys file.
You will lose any data stored in authorized_keys file.
Do you want to continue (yes/no)? yes

............
Deleting tmp directories ... done
done
done
done
done
done
done
[root@localhost /]# 
```

## 运行Gitlab
```
[root@localhost /]# gitlab-ctl start
[root@localhost /]# gitlab-ctl status
run: gitlab-workhorse: (pid 8855) 404s; run: log: (pid 8821) 417s
run: logrotate: (pid 8829) 415s; run: log: (pid 8828) 415s
run: postgresql: (pid 8679) 445s; run: log: (pid 8678) 445s
run: redis: (pid 8596) 452s; run: log: (pid 8595) 452s
run: sidekiq: (pid 8812) 418s; run: log: (pid 8811) 418s
run: unicorn: (pid 8781) 419s; run: log: (pid 8780) 419s
```

## 如果使用了非绑定的Nginx，还需要配置vhost等

# 其他问题

## Gitlab迁移之后鉴权失败
提示
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@       WARNING: POSSIBLE DNS SPOOFING DETECTED!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
The ECDSA host key for gitlab.test.com has changed,
and the key for the corresponding IP address 192.168.3.100
is unknown. This could either mean that
DNS SPOOFING is happening or the IP address for the host
and its host key have changed at the same time.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:1wbCn2WwirSciFlc/1EVuN669qselyrBa+bqiNqjvRY.
Please contact your system administrator.
Add correct host key in /Users/Admin/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /Users/Admin/.ssh/known_hosts:19
ECDSA host key for gitlab.test.com has changed and you have requested strict checking.
Host key verification failed.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@       WARNING: POSSIBLE DNS SPOOFING DETECTED!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
The ECDSA host key for gitlab.test.com has changed,
and the key for the corresponding IP address 192.168.3.100
is unknown. This could either mean that
DNS SPOOFING is happening or the IP address for the host
and its host key have changed at the same time.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:1wbCn2WwirSciFlc/1EVuN669qselyrBa+bqiNqjvRY.
Please contact your system administrator.
Add correct host key in /Users/Admin/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /Users/Admin/.ssh/known_hosts:19
ECDSA host key for gitlab.test.com has changed and you have requested strict checking.
Host key verification failed.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@       WARNING: POSSIBLE DNS SPOOFING DETECTED!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
The ECDSA host key for gitlab.test.com has changed,
and the key for the corresponding IP address 192.168.3.100
is unknown. This could either mean that
DNS SPOOFING is happening or the IP address for the host
and its host key have changed at the same time.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:1wbCn2WwirSciFlc/1EVuN669qselyrBa+bqiNqjvRY.
Please contact your system administrator.
Add correct host key in /Users/Admin/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /Users/Admin/.ssh/known_hosts:19
ECDSA host key for gitlab.test.com has changed and you have requested strict checking.
Host key verification failed.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

```
> 因为`/Users/Admin/.ssh/known_hosts`文件中绑定了gitlab.test.com域名ip与ECDSA key，移除`gitlab.test.com`对应的key之后，再次请求git操作即可

可以使用命令删除：
```
ssh-keygen -R 域名或IP
```

或直接编辑文件，手动删除
```
vim /Users/Admin/.ssh/known_hosts
```