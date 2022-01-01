---
title:   Git Cookbook
date:    2019-11-02 10:24:00
updated: 2020-06-26 16:01:07
categories:
    - A3 - 技术
    - B3 - 开发基础
tags:
    - Cookbook
    - Git
    - GitHub
    - Linux
---

本文介绍一些使用 `Git` 的过程中经常遇到的问题及解决方法。

<!-- more -->

## 1 如何在新设备上配置 Git

### 1.1 本地配置

```bash
$ git config --global user.name "NAME"
$ git config --global user.email "NAME@EXAMPLE.COM"
```

### 1.2 GitHub 远程配置

生成公钥和私钥：

```bash
$ ssh-keygen -t rsa -C "NAME@EXAMPLE.COM"
```

查看公钥的内容：

```bash
$ cat .ssh/id_rsa.pub
```

将公钥的内容复制到 GitHub 的[设置](https://github.com/settings/keys)中即可。

### 1.3 下拉 Repo

```bash
$ git init
$ git remote add origin git@github.com:ProgCZ/xxx.git
$ git pull origin master
```

### 1.4 上推 Repo

```bash
$ git add -A
$ git commit -m "xxx"
$ git push origin master
```

## 2 如何查看和丢弃某一文件未 `commit` 的修改

查看 `README.md` 文件未 `commit` 的修改：

```bash
$ git diff README.md
```

丢弃暂存区的修改：

```bash
$ git restore --staged README.md
```

丢弃工作区的修改：

```bash
$ git restore README.md
```

## 3 如何查看、合并和删除分支

查看本地的所有分支：

```bash
$ git branch
```

查看本地和远程的所有分支：

```bash
$ git branch -a
```

创建分支：

```bash
$ git branch dev
```

切换分支：

```bash
# Pre code
$ git checkout dev
# New code
$ git switch dev
```

创建并切换分支：

```bash
# Pre code
$ git checkout -b dev
# New code
$ git switch -c dev
```

使用 Fast forward 模式合并某分支到当前分支：

```bash
$ git merge dev
```

效果如图：

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/03/00.png" style="zoom:80%"/>

禁用 Fast forward 模式合并某分支到当前分支，提交一次新的 `commit`：

```bash
$ git merge --no-ff -m "merge with no-ff" dev
```

效果如图：

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/03/01.png" style="zoom:80%"/>

查看分支的合并情况：

```bash
$ git log --graph --pretty=oneline --abbrev-commit
```

删除已合并的分支：

```bash
$ git branch -d dev
```

删除未合并的分支：

```bash
$ git branch -D dev
```
