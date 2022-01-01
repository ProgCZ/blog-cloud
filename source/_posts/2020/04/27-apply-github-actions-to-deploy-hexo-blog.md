---
title:   使用 GitHub Actions 实现 Hexo 博客的自动部署
date:    2020-04-27 13:09:33
updated: 2020-04-27 13:09:33
categories:
    - A1 - 生活
    - B2 - 折腾
tags:
    - 教程
    - GitHub
    - GitHub Actions
    - Hexo
    - 博客
---

GitHub Actions 是 GitHub 推出的持续集成服务，可以用于自动执行「代码测试」、「项目部署」等重复劳动，自然也可以用于 Hexo 等静态博客的生成、部署过程，从而不依赖于本地环境，便于迁移。

<!-- more -->

GitHub Actions 官方介绍：<https://github.com/features/actions>

GitHub Actions 入门教程：<https://p3terx.com/archives/github-actions-started-tutorial.html>

## 1 分支设计

[ProgCZ/progcz.github.io](https://github.com/ProgCZ/progcz.github.io) 包含两个分支：

- `master` 分支：用于存放**解析后的静态文件**，也就是托管于 GitHub Pages 的静态网页，无需在本地保存。

- `source` 分支：用于存放**解析前的源文件**，需要与本地同步。

也就是说，我们希望达成的效果如下：**在本地撰写文章后，将其手动提交至 `source` 分支，从而触发 GitHub Actions 生成静态文件，将其自动部署至 `master` 分支。**

## 2 工作流设计

### 2.1 详细描述

1. **工作流由 `source` 分支的 `push` 操作触发。**

    {% note warning %}
    之前我把工作流文件放在 `master` 分支下，希望通过

    ```yaml
    on:
      push:
        branches:
          - source
    ```

    来触发工作流，但是一直没能成功，所以这里建议将工作流文件放在 `source` 分支下。
    {% endnote %}

2. **配置工作流环境（与本地保持一致）：系统为 Ubuntu 16.04，Node.js 版本为 12.x。**

3. **下拉 `source` 分支至 `blog-source-ws` 文件夹中。**

4. **安装 `hexo-cli` 工具，版本为 3.1.0（与本地保持一致）。**

5. **安装插件，依赖文件为 `blog-source-ws/package.json`。**

    {% note warning %}
    为了使插件保持稳定，我把所有版本号前的 `^` 全部删除，因为 `^` 表示将插件更新到当前 major version（也就是第一位数字）中的最新版本。

    完整依赖文件如下所示：

    ```json code https://github.com/ProgCZ/progcz.github.io/blob/source/package.json package.json
    {
      "name": "hexo-site",
      "version": "0.0.0",
      "private": true,
      "scripts": {
        "build": "hexo generate",
        "clean": "hexo clean",
        "deploy": "hexo deploy",
        "server": "hexo server"
      },
      "hexo": {
        "version": "4.2.0"
      },
      "dependencies": {
        "hexo": "4.2.0",
        "hexo-generator-archive": "1.0.0",
        "hexo-generator-category": "1.0.0",
        "hexo-generator-index": "1.0.0",
        "hexo-generator-feed": "2.2.0",
        "hexo-generator-sitemap": "2.0.0",
        "hexo-generator-searchdb": "1.3.0",
        "hexo-generator-tag": "1.0.0",
        "hexo-html-minifier": "1.0.0",
        "hexo-renderer-ejs": "1.0.0",
        "hexo-renderer-stylus": "1.1.0",
        "hexo-renderer-marked": "2.0.0",
        "hexo-server": "1.0.0"
      }
    }
    ```

    细心的读者可能看到，除了默认插件以外，我额外添加了四个插件，分别是：

    - `hexo-generator-feed` 用于生成 RSS 文件。

    - `hexo-generator-sitemap` 用于生成站点地图文件，提交给 Google 之后可以提高网页收录效率。

    - `hexo-generator-searchdb` 用于生成搜索文件。

    - `hexo-html-minifier` 用于压缩 html 文件（删除大量空白和换行），可以加快网页加载速度。
    {% endnote %}

6. **下拉 `master` 分支至 `blog-source-ws/pubic` 文件夹中。**

7. **配置时区和用户信息后，通过**

    ```bash
    $ ls -a | egrep -v '^\.{1,2}$' | egrep -v .git | xargs rm -rf
    ```

    **清空 `blog-source-ws/pubic` 文件夹（相当于 `hexo clean`），再通过**

    ```bash
    $ hexo g
    ```

    **在 `blog-source-ws/pubic` 文件夹中生成静态文件，再通过**

    ```bash
    $ git add -A
    $ git commit -m "Update blog: `date '+%Y-%m-%d %H:%M:%S'`"
    $ git push origin master
    ```

    **将静态文件手动提交至 `master` 分支。**

### 2.2 完整代码

```yaml code https://github.com/ProgCZ/progcz.github.io/blob/source/.github/workflows/auto-hexo.yml auto-hexo.yml
name: Auto Hexo
on: push
jobs:
  Worker:
    runs-on: ubuntu-16.04
    steps:
    - name: Setup Node
      uses: actions/setup-node@v1
      with:
        node-version: '12.x'

    - name: Checkout source
      uses: actions/checkout@v2
      with:
        ref: source
        path: 'blog-source-ws'

    - name: Setup Hexo
      run: |
        npm install -g hexo-cli@3.1.0
        cd blog-source-ws
        npm install

    - name: Checkout master
      uses: actions/checkout@v2
      with:
        ref: master
        path: 'blog-source-ws/public'

    - name: Regenerate and Deploy
      run: |
        export TZ='Asia/Shanghai'
        cd blog-source-ws/public
        ls -a | egrep -v '^\.{1,2}$' | egrep -v .git | xargs rm -rf
        cd ..
        hexo g
        cd public
        git config --local user.name "NAME"
        git config --local user.email "NAME@EXAMPLE.COM"
        git add -A
        git commit -m "Update blog: `date '+%Y-%m-%d %H:%M:%S'`"
        git push origin master
```

需要注意以下几点：

- **`ls -a | egrep -v '^\.{1,2}$' | egrep -v .git | xargs rm -rf` 相当于 `hexo clean`，**但是该命令只是删除 `blog-source-ws/public` 文件夹内除了以 `.git` 为前缀的文件或文件夹以外的所有文件或文件夹，而 `hexo clean` 直接删除 `blog-source-ws/public` 文件夹。

- 两个分支属于同一仓库，**使用 `actions/checkout`（相当于 `git pull`）之后可以直接 `git push`，**而不需要配置其他教程（比如[这篇文章](https://mystryl.com/2019/10/github-actions/)）中出现的秘钥。

## 3 自动部署效果

可以在[这里](https://github.com/ProgCZ/progcz.github.io/actions?query=branch%3Asource)看到，部署时间大概在 40 秒左右，随着文章数量不断增多，部署时间也会不断增加，但是总不可能超过 6 小时的限制（GitHub Actions 的使用限制可以在[这里](https://help.github.com/en/actions/getting-started-with-github-actions/about-github-actions#usage-limits)查看）。

只要 GitHub 没有警告版本过期，上述方案就可以一直使用下去，即使 GitHub 警告版本过期，也可以尝试更改版本号，一般都会向下兼容，所以目测支撑个四五年应该没有问题。
