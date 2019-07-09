title: GentOS-Gitlab配置Pages
tags:
  - CentOS
  - Gitlab Pages
  - Gitlab-Runner
categories:
  - CentOS
  - Gitlab
date: 2019-05-13 17:13:15
---
# 安装Runner
> Runner常用于CI/CD持续集成，相当于一个服务端自动构建处理的进程，因为安全性以及占用资源的问题，runner经常也安装在gitlab服务器之外的其他子服务器，但这里以安装在gitlab本机为例

## CentOS环境
```
[root@VM_0_5_centos ~]# cat /etc/redhat-release 
CentOS Linux release 7.5.1804 (Core) 
```
<!-- more --->
## 添加源并使用`yum`安装
```
curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
yum install gitlab-runner -y
```

## 启动gitlab-runner
```
[root@VM_0_5_centos ~]# systemctl start gitlab-runner
[root@VM_0_5_centos ~]# systemctl status gitlab-runner
● gitlab-runner.service - GitLab Runner
   Loaded: loaded (/etc/systemd/system/gitlab-runner.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2019-05-13 17:17:40 CST; 13s ago
 Main PID: 24125 (gitlab-runner)
   CGroup: /system.slice/gitlab-runner.service
           └─24125 /usr/lib/gitlab-runner/gitlab-runner run --working-directory /home/gitlab-runner --config /etc/gitlab-runner/config.toml --service gitlab-runner --syslog --user gitlab-runner

May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]: Running in system-mode.                           
May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]: 
May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]: Configuration loaded                                builds=0
May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]: Running in system-mode.                           
May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]: listen_address not defined, metrics & debug endpoints disabled  builds=0
May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]: [session_server].listen_address not defined, session endpoints disabled  builds=0
May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]:                                                   
May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]: Configuration loaded                                builds=0
May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]: listen_address not defined, metrics & debug endpoints disabled  builds=0
May 13 17:17:40 VM_0_5_centos gitlab-runner[24125]: [session_server].listen_address not defined, session endpoints disabled  builds=0
```
## 查看Gitlab服务端的域名及Token

![](/images/WechatIMG237.png)

> token及域名url位于<span style="color:red">gitlab管理员账后登录后的</span>【控制面板】-【Runner】模块的右上角，记下后下一步将用到

## 向Gitlab服务端注册runner
```
[root@VM_0_5_centos ~]# gitlab-runner register
Runtime platform                                    arch=amd64 os=linux pid=24287 revision=1f513601 version=11.10.1
Running in system-mode.                            
                                                   
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://gitlab.kelvinsail.com/
Please enter the gitlab-ci token for this runner:
gRgu8G3pnzYvxryDU4ot
Please enter the gitlab-ci description for this runner:
[VM_0_5_centos]: kelvin-tencent
Please enter the gitlab-ci tags for this runner (comma separated):
tag-kelvin                
Registering runner... succeeded                     runner=gRgu8G3p
Please enter the executor: docker, docker-ssh, virtualbox, docker+machine, docker-ssh+machine, parallels, shell, ssh, kubernetes:
shell
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded! 
```

## 通过管理员的控制面板查看runner是否注册成功
![](/images/WechatIMG238.png)