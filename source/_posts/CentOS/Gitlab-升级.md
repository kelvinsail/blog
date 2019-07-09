title: Gitlab 升级
author: yifan
tags:
  - Gitlab
categories:
  - CentOS
  - Gitlab
date: 2019-05-15 11:50:00
---
# 确认当前Gitlab版本
```
[root@localhost ~]# head -1 /opt/gitlab/version-manifest.txt
gitlab-ce 8.16.4
```


# 开始升级

## 大版本升级限制
<!-- more -->
```
[root@localhost ~]# rpm -Uvh gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm 
警告：gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm: 头V4 RSA/SHA1 Signature, 密钥 ID f27eab47: NOKEY
准备中...                          ################################# [100%]
gitlab preinstall: It seems you are upgrading from 8.x version series
gitlab preinstall: to 11.x series. It is recommended to upgrade
gitlab preinstall: to the last minor version in a major version series first before
gitlab preinstall: jumping to the next major version.
gitlab preinstall: Please follow the upgrade documentation at https://docs.gitlab.com/ee/policy/maintenance.html#upgrade-recommendations
gitlab preinstall: and upgrade to 10.8 first.
```
> 因为当前的版本是`8.16.4`，与最新版本相差太远，所以在gitlab中进行大版本升级时
会失败，提示中建议先升级到`10.8.*`版本，查看 [官方升级文档](https://docs.gitlab.com/ee/policy/maintenance.html#upgrade-recommendations) ，其中有推荐升级路径

![upload successful](/images/pasted-63.png)

## 开始进行分步升级
```
[root@localhost ~]# wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-8.17.7-ce.0.el7.x86_64.rpm
[root@localhost ~]# rpm -Uvh gitlab-ce-8.17.7-ce.0.el7.x86_64.rpm
·····
unning handlers:
Running handlers complete
Chef Client finished, 27/304 resources updated in 32 seconds
gitlab Reconfigured!
Restarting previously running GitLab services
ok: run: gitlab-workhorse: (pid 10858) 0s
ok: run: logrotate: (pid 10865) 1s
ok: run: postgresql: (pid 10737) 29s
ok: run: redis: (pid 10316) 35s
ok: run: sidekiq: (pid 10850) 1s
ok: run: unicorn: (pid 10874) 0s

Upgrade complete! If your GitLab server is misbehaving try running

   sudo gitlab-ctl restart

before anything else. If you need to roll back to the previous version you can
use the database backup made during the upgrade (scroll up for the filename).
```

> 以升级到8.17.7为例，官方文档给出的推荐升级路径中的版本，均为每个大版本中的最新版本，只有最后一个v11的版本我们可以选择更新的版本，整体升级路线：8.13.4 -> 8.17.7 -> 9.5.10 -> 10.8.7 -> 11.10.4

## 继续分批次下载包、安装升级
```
//升级到9.5.10
wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-9.5.10-ce.0.el7.x86_64.rpm
rpm -Uvh gitlab-ce-9.5.10-ce.0.el7.x86_64.rpm

//升级到10.8.7
wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-10.8.7-ce.0.el7.x86_64.rpm
rpm -Uvh gitlab-ce-10.8.7-ce.0.el7.x86_64.rpm

//升级到11.10.4
wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm
rpm -Uvh gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm
```

## 升级完成

```
····
Warnings:
The version of the running postgresql service is different than what is installed.
Please restart postgresql to start the new version.

sudo gitlab-ctl restart postgresql

gitlab Reconfigured!
Checking for an omnibus managed postgresql: OK
Checking for a newer version of PostgreSQL to install
No new version of PostgreSQL installed, nothing to upgrade to
Ensuring PostgreSQL is updated: OK
Restarting previously running GitLab services
ok: run: alertmanager: (pid 17033) 1s
ok: run: gitaly: (pid 16900) 3s
ok: run: gitlab-monitor: (pid 16898) 3s
ok: run: gitlab-workhorse: (pid 16860) 4s
ok: run: logrotate: (pid 17069) 1s
ok: run: node-exporter: (pid 16886) 5s
ok: run: postgres-exporter: (pid 17049) 2s
ok: run: postgresql: (pid 14704) 317s
ok: run: prometheus: (pid 17005) 3s
ok: run: redis: (pid 16481) 45s
ok: run: redis-exporter: (pid 16951) 4s
ok: run: sidekiq: (pid 17081) 0s
ok: run: unicorn: (pid 17088) 0s

     _______ __  __          __
    / ____(_) /_/ /   ____ _/ /_
   / / __/ / __/ /   / __ `/ __ \
  / /_/ / / /_/ /___/ /_/ / /_/ /
  \____/_/\__/_____/\__,_/_.___/
  

Upgrade complete! If your GitLab server is misbehaving try running
  sudo gitlab-ctl restart
before anything else.
If you need to roll back to the previous version you can use the database
backup made during the upgrade (scroll up for the filename).
```

## 检查进程及Gitlab版本
```
[root@localhost ~]# gitlab-ctl status
run: alertmanager: (pid 17033) 73s; run: log: (pid 14937) 343s
run: gitaly: (pid 16900) 75s; run: log: (pid 12045) 742s
run: gitlab-monitor: (pid 16898) 75s; run: log: (pid 12122) 735s
run: gitlab-workhorse: (pid 16860) 76s; run: log: (pid 6078) 3000s
run: logrotate: (pid 17069) 72s; run: log: (pid 6072) 3000s
run: node-exporter: (pid 16886) 76s; run: log: (pid 12116) 736s
run: postgres-exporter: (pid 17049) 73s; run: log: (pid 12141) 730s
run: postgresql: (pid 14704) 388s; run: log: (pid 6082) 3000s
run: prometheus: (pid 17005) 74s; run: log: (pid 12132) 732s
run: redis: (pid 16481) 116s; run: log: (pid 6067) 3000s
run: redis-exporter: (pid 16951) 75s; run: log: (pid 12126) 734s
run: sidekiq: (pid 17081) 71s; run: log: (pid 6080) 3000s
run: unicorn: (pid 17088) 71s; run: log: (pid 6070) 3000s
[root@localhost ~]# head -1 /opt/gitlab/version-manifest.txt
gitlab-ce 11.10.4
```