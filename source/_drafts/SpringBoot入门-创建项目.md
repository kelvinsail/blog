---
title: SpringBoot入门 创建项目
tags:
  - JAVA
  - SpringBoot
categories:
  - JAVA
  - SpringBoot
toc: false
---

# IDEA点击“create New Project”
![image.png](/images/2020/01/31/332e3db0-4412-11ea-a184-eb793a5501ba.png)

# 编辑项目信息
- 包名Group
- 项目名Artiface
- 描述
![image.png](/images/2020/01/31/7102f220-4412-11ea-a184-eb793a5501ba.png)

# 选择“Web-Spring Web”
![image.png](/images/2020/01/31/34188130-4413-11ea-a184-eb793a5501ba.png)

# 选择保存路径
![image.png](/images/2020/01/31/5551c0f0-4413-11ea-a184-eb793a5501ba.png)

# 运行
## Application
- 程序的启动类，包含程序的入口函数；
- @SpringBootApplication是SpringBoot的核心注解，主要是为了启动自动配置；
- main()java应用的标准启动函数，作为程序的启动入口；

# 添加基本响应函数
- application类添加@RestController注解
- 创建函数，添加注解@RequestMapping("/")，注解参数字符串为接口路径
```
    @RequestMapping("/")
    public String index(){
        return "{\"app\":\"Hello SpringBoot!!!\"}";
    }
```

# 运行
- application类右键“run DemoApplication” ；
- 命令行运行`mvn spring-boot:run`；
- 通过“maven package”打包成jar包到项目根目录`target`文件夹中，再通过`java -jar demo-0.0.1-SNAPSHOT.jar`运行起来（再次编译最好clean一下）； 
![image.png](/images/2020/01/31/bd423cb0-443d-11ea-a184-eb793a5501ba.png)

# 运行结果
![image.png](/images/2020/01/31/5ffa57c0-4417-11ea-a184-eb793a5501ba.png)
