---
title: Gradle 打包自动写入信息到apk的META-INF目录
tags:
  - Android
  - Gradle
categories:
  - Android
  - Gradle
toc: false
date: 2023-03-20 15:06:12
---

# Gradle自动写入打包分支、commitId、git账号信息到apk的META-INF目录
## 根目录创建`buildInfo.gradle`文件，编写task

<!-- more -->
```
/**
 * 获取当前git账号名、email
 **/
def builder = ""
task getGitBuilderName {
    def out = new ByteArrayOutputStream()
    def cmd = 'git config user.name && git config user.email'
    exec {
        ExecSpec execSpec ->
            executable 'bash'
            args '-c', cmd
            standardOutput = out
    }
    builder = "${out.toString().replaceFirst("\n","(").replaceFirst("\n",")")}"
}

/**
 * 获取原生项目分支名称+最后一次commit的id
 */
def gitBranchName = ""
task getGitBranchName {
    def out = new ByteArrayOutputStream()
    def cmd = 'git symbolic-ref --short -q HEAD && git rev-parse HEAD'
    exec {
        ExecSpec execSpec ->
            executable 'bash'
            args '-c', cmd
            standardOutput = out
    }
    gitBranchName = "${out.toString().replaceFirst("\n","(").replaceFirst("\n",")")}"
}

/**
 * 获取flutter项目分支名称+最后一次commit的id
 */
def gitFBranchName = ""
task getGitFBranchName {
    def out = new ByteArrayOutputStream()
    def targetPath = "-C ${project.rootDir.getParent().toString()}/flutter_moudle"
    def cmd1 = "git ${targetPath} symbolic-ref --short -q HEAD && git ${targetPath} rev-parse HEAD"
    println cmd1
    exec {
        ExecSpec execSpec2 ->
            executable 'bash'
            args '-c', cmd1
            standardOutput = out
    }
    gitFBranchName = "${out.toString().replaceFirst("\n","(").replaceFirst("\n",")")}"
}

/**
 * 写入文件
 **/
task writeInfo {
    String dirPath = "${project.projectDir.toString()}//src//main//resources//META-INF";
    println "打包信息目录：${dirPath}"
    File dir = new File(dirPath);
    if (!dir.exists()) {
        dir.mkdirs();
    }
    String filePath = "${project.projectDir.toString()}//src//main//resources//META-INF//packageInfo.json";
    println "打包信息文件路径：${filePath}"
    File infoFile = new File(filePath);
    if (!infoFile.exists()) {
        infoFile.createNewFile();
    }
    println filePath
    String totalContent = "{ \n  \"builder\": \"" + builder + "\", \n  \"buildTime\": \"" + releaseTime() + "\", \n  \"native\": \"" + gitBranchName + "\", \n  \"flutter\": \"" + gitFBranchName + "\" \n}";
    writeFile(filePath, totalContent);
}

/**
 * 获取时间
 **/
def releaseTime() {
    return new Date().format("yyyy-MM-dd HH:mm:ss", TimeZone.default)
}

/**
 * 覆写文件
 **/
def writeFile(String filePath, String content) {
    try {
        new File(filePath).withWriter('UTF-8') { writer -> writer.append(content) }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
```

## 进入项目app目录，在`build.gradle`加入引用
```
apply from: '../buildInfo.gradle'
```