---
title: Gitlab 配置邮件服务
tags:
  - Gitlab
categories:
  - Gitlab
toc: false
date: 2020-07-16 11:12:15
---

# 配置
## 修改配置文件（建议先备份！！！）
- 打开文件
```
vim /etc/gitlab/gitlab.rb
```
<!-- more -->
- 修改配置项
```
#启用邮件
gitlab_rails['gitlab_email_enabled'] = true
# 必须和SMTP定义的邮件地址一致
gitlab_rails['gitlab_email_from'] = 'xxx@163.com'
gitlab_rails['gitlab_email_display_name'] = 'Gitlab'

#启用SMTP，邮件发送服务器必开
gitlab_rails['smtp_enable'] = true			
#发件人地址
gitlab_rails['smtp_address'] = "smtp.163.com"
#启用的端口
gitlab_rails['smtp_port'] = 465 
#发件人账号
gitlab_rails['smtp_user_name'] = "xxx@163.com"
#用户登录密码
gitlab_rails['smtp_password'] = "xxpassword"
#SMTP 服务器主域名
gitlab_rails['smtp_domain'] = "163.com"
#验证方式，登录
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true

#修改gitlab配置的发信人
#gitlab 默认的email 用户，必须和SMTP定义的邮件地址一致
user["git_user_email"] = "xxx@163.com"
```
## 保存退出vim
## 刷新gitlab配置
```
# gitlab-ctl reconfigure
Starting Chef Client, version 13.6.4
resolving cookbooks for run list: ["gitlab"]
Synchronizing Cookbooks:
  - postgresql (0.1.0)
  - redis (0.1.0)
  - registry (0.1.0)
  - mattermost (0.1.0)
  - consul (0.1.0)
  - gitaly (0.1.0)
  - nginx (0.1.0)
  - package (0.1.0)
  - crond (0.1.0)
  - gitlab (0.0.1)
  - letsencrypt (0.1.0)
  - acme (3.1.0)
  - runit (4.3.0)
  - 
// 省略...

Running handlers:
Running handlers complete
Chef Client finished, 2/609 resources updated in 11 seconds
gitlab Reconfigured!
```
## 打开gitlab控制台测试发送邮件
```
# gitlab-rails console
-------------------------------------------------------------------------------------
 GitLab:       11.10.4 (62c464651d2)
 GitLab Shell: 9.0.0
 PostgreSQL:   9.6.11
-------------------------------------------------------------------------------------
Loading production environment (Rails 5.0.7.2)
irb(main):001:0> Notify.test_email('xxx@qq.com', '邮件标题', '邮件正文').deliver_now
Notify#test_email: processed outbound mail in 241.6ms
Sent mail to 89214508@qq.com (1798.4ms)
Date: Thu, 16 Jul 2020 10:59:35 +0800
From: yifan <kelvinsail@163.com>
Reply-To: yifan <noreply@gitlab.kelvinsail.com>
To: xxx@qq.com
Message-ID: <5f0fc297f1813_43933ff2af5d65ec550dd@iZwz9batmxqsal9i1o2m6mZ.mail>
Subject: =?UTF-8?Q?=E9=82=AE=E4=BB=B6=E6=A0=87=E9=A2=98?=
Mime-Version: 1.0
Content-Type: text/html;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Auto-Submitted: auto-generated
X-Auto-Response-Suppress: All

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><body><p>&#37038;&#20214;&#27491;&#25991;</p></body></html>

=> #<Mail::Message:70311234607120, Multipart: false, Headers: <Date: Thu, 16 Jul 2020 10:59:35 +0800>, <From: yifan <kelvinsail@163.com>>, <Reply-To: yifan <noreply@gitlab.kelvinsail.com>>, <To: xxx@qq.com>, <Message-ID: <5f0fc297f1813_43933ff2af5d65ec550dd@iZwz9batmxqsal9i1o2m6mZ.mail>>, <Subject: 邮件标题>, <Mime-Version: 1.0>, <Content-Type: text/html; charset=UTF-8>, <Content-Transfer-Encoding: 7bit>, <Auto-Submitted: auto-generated>, <X-Auto-Response-Suppress: All>>

```

# 注意

## 控制台测试报错
```
Traceback (most recent call last):
       16: from /opt/gitlab/embedded/lib/ruby/gems/2.5.0/gems/actionmailer-5.0.7.2/lib/action_mailer/base.rb:541:in `deliver_mail'
       15: from /opt/gitlab/embedded/lib/ruby/gems/2.5.0/gems/activesupport-5.0.7.2/lib/active_support/notifications.rb:164:in `instrument'
       14: from /opt/gitlab/embedded/lib/ruby/gems/2.5.0/gems/activesupport-5.0.7.2/lib/active_support/notifications/instrumenter.rb:21:in `instrument'
       13: from /opt/gitlab/embedded/lib/ruby/gems/2.5.0/gems/activesupport-5.0.7.2/lib/active_support/notifications.rb:164:in `block in instrument'
       12: from /opt/gitlab/embedded/lib/ruby/gems/2.5.0/gems/actionmailer-5.0.7.2/lib/action_mailer/base.rb:543:in `block in deliver_mail'
       11: from /opt/gitlab/embedded/lib/ruby/gems/2.5.0/gems/mail-2.7.1/lib/mail/message.rb:260:in `block in deliver'
       10: from /opt/gitlab/embedded/lib/ruby/gems/2.5.0/gems/mail-2.7.1/lib/mail/message.rb:2159:in `do_delivery'
        9: from /opt/gitlab/embedded/lib/ruby/gems/2.5.0/gems/mail-2.7.1/lib/mail/network/delivery_methods/smtp.rb:100:in `deliver!'
        8: from /opt/gitlab/embedded/lib/ruby/gems/2.5.0/gems/mail-2.7.1/lib/mail/network/delivery_methods/smtp.rb:109:in `start_smtp_session'
        7: from /opt/gitlab/embedded/lib/ruby/2.5.0/net/smtp.rb:518:in `start'
        6: from /opt/gitlab/embedded/lib/ruby/2.5.0/net/smtp.rb:548:in `do_start'
        5: from /opt/gitlab/embedded/lib/ruby/2.5.0/timeout.rb:103:in `timeout'
        4: from /opt/gitlab/embedded/lib/ruby/2.5.0/net/smtp.rb:549:in `block in do_start'
        3: from /opt/gitlab/embedded/lib/ruby/2.5.0/net/smtp.rb:539:in `tcp_socket'
        2: from /opt/gitlab/embedded/lib/ruby/2.5.0/net/smtp.rb:539:in `open'
        1: from /opt/gitlab/embedded/lib/ruby/2.5.0/net/smtp.rb:539:in `initialize'
Net::OpenTimeout (execution expired)
```
> 阿里云、腾讯服务器疑似屏蔽了25端口，需要改为465、打开SSL