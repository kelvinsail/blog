title: CentOS 部署Gitlab
tags:
  - CentOS
  - Gitlab
categories:
  - CentOS
  - Gitlab
author: yifan
date: 2019-05-08 00:10:00
---
# 准备工作

> <span style="color:red">注意！需要4G+内存</span>，并不是说4G以下就无法安装....但是会容易出现无法预知的问题，比如经常出现502页面
## 安装所需要的依赖包
```
yum -y install policycoreutils-python openssh-server openssh-clients postfix
```

<!-- more -->

## 开启postfix 
```
[root@VM_0_5_centos ~]# systemctl enable postfix && systemctl start postfix
[root@VM_0_5_centos ~]# systemctl status postfix.service
```

- 如遇遇到报错，提示
```
Job for postfix.service failed because the control process exited with error code. See "systemctl status postfix.service" and "journalctl -xe" for details.
```

- 运行`systemctl status postfix.service`查看状态
```
[root@VM_0_5_centos vhost]# systemctl status postfix.service
● postfix.service - Postfix Mail Transport Agent
   Loaded: loaded (/usr/lib/systemd/system/postfix.service; enabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Wed 2019-05-15 17:40:25 CST; 8s ago
  Process: 2277 ExecStart=/usr/sbin/postfix start (code=exited, status=1/FAILURE)
  Process: 2274 ExecStartPre=/usr/libexec/postfix/chroot-update (code=exited, status=0/SUCCESS)
  Process: 2269 ExecStartPre=/usr/libexec/postfix/aliasesdb (code=exited, status=75)

May 15 17:40:23 VM_0_5_centos systemd[1]: Starting Postfix Mail Transport Agent...
May 15 17:40:23 VM_0_5_centos aliasesdb[2269]: /usr/sbin/postconf: fatal: parameter inet_interfaces: no local interface found for ::1
May 15 17:40:24 VM_0_5_centos aliasesdb[2269]: newaliases: fatal: parameter inet_interfaces: no local interface found for ::1
May 15 17:40:24 VM_0_5_centos postfix/sendmail[2272]: fatal: parameter inet_interfaces: no local interface found for ::1
May 15 17:40:24 VM_0_5_centos postfix[2277]: fatal: parameter inet_interfaces: no local interface found for ::1
May 15 17:40:25 VM_0_5_centos systemd[1]: postfix.service: control process exited, code=exited status=1
May 15 17:40:25 VM_0_5_centos systemd[1]: Failed to start Postfix Mail Transport Agent.
May 15 17:40:25 VM_0_5_centos systemd[1]: Unit postfix.service entered failed state.
May 15 17:40:25 VM_0_5_centos systemd[1]: postfix.service failed.
```

- 运行`more /var/log/maillog`检查日志
```
May 15 00:46:20 VM_0_5_centos postfix/sendmail[31716]: fatal: parameter inet_interfaces: no local interface found for ::1
May 15 17:40:24 VM_0_5_centos postfix/sendmail[2272]: fatal: parameter inet_interfaces: no local interface found for ::1
May 15 17:40:24 VM_0_5_centos postfix[2277]: fatal: parameter inet_interfaces: no local interface found for ::1
```

- 提示'parameter inet_interfaces: no local interface found for'，检查postfix的inet_interfaces配置


- 编辑`/etc/postfix/main.cf`，修改设置
```
//inet_interfaces = localhost
//inet_protocols = all
//改为
inet_interfaces = all
inet_protocols = all
```

- 开启postfix
```
[root@VM_0_5_centos vhost]# service postfix start
Redirecting to /bin/systemctl start postfix.service
[root@VM_0_5_centos vhost]# systemctl status postfix.service
● postfix.service - Postfix Mail Transport Agent
   Loaded: loaded (/usr/lib/systemd/system/postfix.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-05-15 17:45:36 CST; 4s ago
  Process: 3102 ExecStart=/usr/sbin/postfix start (code=exited, status=0/SUCCESS)
  Process: 3100 ExecStartPre=/usr/libexec/postfix/chroot-update (code=exited, status=0/SUCCESS)
  Process: 3096 ExecStartPre=/usr/libexec/postfix/aliasesdb (code=exited, status=0/SUCCESS)
 Main PID: 3181 (master)
   CGroup: /system.slice/postfix.service
           ├─3181 /usr/libexec/postfix/master -w
           ├─3182 pickup -l -t unix -u
           └─3183 qmgr -l -t unix -u

May 15 17:45:35 VM_0_5_centos systemd[1]: Starting Postfix Mail Transport Agent...
May 15 17:45:36 VM_0_5_centos postfix/master[3181]: daemon started -- version 2.10.1, configuration /etc/postfix
May 15 17:45:36 VM_0_5_centos systemd[1]: Started Postfix Mail Transport Agent.
```


# 下载安装包
> 访问 [中文镜像站点](https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/)查看最新的镜像版本，我选的是`11.10.4`
```
[root@VM_0_5_centos ~]# wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm
--2019-05-07 23:23:24--  https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm
Resolving mirrors.tuna.tsinghua.edu.cn (mirrors.tuna.tsinghua.edu.cn)... 101.6.8.193, 2402:f000:1:408:8100::1
Connecting to mirrors.tuna.tsinghua.edu.cn (mirrors.tuna.tsinghua.edu.cn)|101.6.8.193|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 619044408 (590M) [application/x-redhat-package-manager]
Saving to: ‘gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm’

100%[==================================================================================>] 619,044,408 10.4MB/s   in 61s

2019-05-07 23:24:48 (9.62 MB/s) - ‘gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm’ saved [619044408/619044408]

```
# 安装
```
[root@VM_0_5_centos ~]# rpm -ivh gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm
warning: gitlab-ce-11.10.4-ce.0.el7.x86_64.rpm: Header V4 RSA/SHA1 Signature, key ID f27eab47: NOKEY
Preparing...                          ################################# [100%]
Updating / installing...
   1:gitlab-ce-11.10.4-ce.0.el7       ################################# [100%]
It looks like GitLab has not been configured yet; skipping the upgrade script.

       *.                  *.
      ***                 ***
     *****               *****
    .******             *******
    ********            ********
   ,,,,,,,,,***********,,,,,,,,,
  ,,,,,,,,,,,*********,,,,,,,,,,,
  .,,,,,,,,,,,*******,,,,,,,,,,,,
      ,,,,,,,,,*****,,,,,,,,,.
         ,,,,,,,****,,,,,,
            .,,,***,,,,
                ,*,.



     _______ __  __          __
    / ____(_) /_/ /   ____ _/ /_
   / / __/ / __/ /   / __ `/ __ \
  / /_/ / / /_/ /___/ /_/ / /_/ /
  \____/_/\__/_____/\__,_/_.___/


Thank you for installing GitLab!
GitLab was unable to detect a valid hostname for your instance.
Please configure a URL for your GitLab instance by setting `external_url`
configuration in /etc/gitlab/gitlab.rb file.
Then, you can start your GitLab instance by running the following command:
  sudo gitlab-ctl reconfigure

For a comprehensive list of configuration options please see the Omnibus GitLab readme
https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md
```

# 配置
## 端口
```
vim /etc/gitlab/gitlab.rb
// external_url -> "http://gitlab.example.com"
// 改为自己的服务器 "http://ip:端口"
```
## 刷新应用配置(这一步需要比较长的时间执行)
```
gitlab-ctl reconfigure
```
## 重启
```
[root@VM_0_5_centos ~]# gitlab-ctl restart
ok: run: alertmanager: (pid 32598) 0s
ok: run: gitaly: (pid 32607) 1s
ok: run: gitlab-monitor: (pid 32626) 0s
ok: run: gitlab-workhorse: (pid 32631) 0s
ok: run: logrotate: (pid 32640) 1s
ok: run: nginx: (pid 32648) 0s
ok: run: node-exporter: (pid 32653) 1s
ok: run: postgres-exporter: (pid 32667) 0s
ok: run: postgresql: (pid 32681) 1s
ok: run: prometheus: (pid 32688) 0s
ok: run: redis: (pid 32702) 0s
ok: run: redis-exporter: (pid 32708) 0s
ok: run: sidekiq: (pid 341) 0s
ok: run: unicorn: (pid 373) 0s
```
## 第一次访问，设置密码

![upload successful](/images/image.png)


# 问题
## 访问站点出现502

![upload successful](/images/pasted-0.png)

> 第一次访问或者低内存情况下会出现，或是其他原因，比如文件权限、端口占用
## Nginx冲突
### 懒人方法，重命名nginx进程，参考 【[记一次 gitlab 与老的 nginx 冲突处理](https://www.52cik.com/2017/02/08/clash-of-nginx-and-gitlab.html)】
- 复制一份 gitlib 下的 nginx
```
mv /opt/gitlab/embedded/sbin/nginx /opt/gitlab/embedded/sbin/nginx2
```
- 修改启动脚本
```
vi /opt/gitlab/sv/nginx/run
```
- 修改如下内容：
```
exec chpst -P /opt/gitlab/embedded/sbin/nginx -p /var/opt/gitlab/nginx
// 改为
exec chpst -P /opt/gitlab/embedded/sbin/nginx2 -p /var/opt/gitlab/nginx
```
> reboot之后即可，但是如果执行`gitlab-ctl reconfigure`，该配置会被还原，切记不要随意reconfigure

### 使用非绑定的Nginx（兼容本机Nginx）

- 具体参考[官网教程](https://docs.gitlab.com/omnibus/settings/nginx.html#using-a-non-bundled-web-server)，Using a non-bundled web-server，以下只列出操作步骤
- 打开`vi /etc/gitlab/gitlab.rb`，也可以通过ftp打开文件编辑
- 停止使用绑定的Nginx服务
```
nginx['enable'] = false
```
- 设置web-server user用户名，这里我nginx使用的是`LNMP`，用户名为`www`，具体应以自己服务器配置而定
```
web_server['external_users'] = ['www']
```
- 将本机IP添加到gitlab的信任列表中
```
gitlab_rails['trusted_proxies'] = [ '127.0.0.1' ]
```
- 设置gitlab的监听端口，以8181端口为例，即访问使用的端口
```
gitlab_workhorse['listen_network'] = "tcp"
gitlab_workhorse['listen_addr'] = "127.0.0.1:8181" 
```
- 重载配置
```
gitlab-ctl reconfigure
gitlab-ctl restart
```
> 要注意的是，我配置过懒人方法，所以导致进程中有多个nginx，所以此时restart之后无法访问，还是需要`reboot`下，可以配置、使用nginx转发，就可以通过域名访问部署好的gitlab

## 汉化
> [补丁主页](https://gitlab.com/xhang/gitlab) ，目前最新的补丁是`11.10.2`，但是我安装的是`11.10.4`，但目前没有发现异常`；

- 下载补丁
```
wget https://gitlab.com/xhang/gitlab/-/archive/11-10-stable-zh/gitlab-11-10-stable-zh.tar.gz
tar -zxf gitlab-11-10-stable-zh.tar.gz
cp -rp /opt/gitlab/embedded/service/gitlab-rails{,.bak_$(date +%F)}    
```
- 覆盖源文件，这里需要使用`/bin/cp -rf`，进行强制覆盖，不然会需要一直确认是否覆盖
```
/bin/cp -rf gitlab-11-10-stable-zh/* /opt/gitlab/embedded/service/gitlab-rails/    
```
- 刷新配置、重启
```
gitlab-ctl reconfigure
gitlab-ctl restart
```
- 重启之后发现许多内容仍为英文，使用admin进入设置

![upload successful](/images/pasted-1.png)

选择`Language`为`简体中文`，保存、刷新页面后，内容基本汉化

## 关闭注册功能
> 进入管理中心 - 设置 - `取消`启用注册 - 保存
> ![upload successful](/images/pasted-2.png)