---
title:   记录使用 IFTTT + Telegram 订阅 RSS 的推送模板
date:    2020-05-24 18:30:11
updated: 2020-05-24 18:30:11
categories:
    - A1 - 生活随笔
    - B2 - 折腾
tags:
    - IFTTT
    - Telegram
    - RSS
---

对于大部分使用 RSS 的人来说，RSS 最大的优势便是能够提供**「聚合阅读」**的功能，也就是在一个地方阅读多篇不同来源的文章，而且可以自主选择订阅源，拒绝推荐引擎的「投喂」。然而对于我来说，RSS 还有一个重要的作用在于能够提供**「即时通知」**的功能，也就是**「一旦发生了什么，请立刻通知我」**。

所以，为了实现**「即时通知」**的功能，**可以使用 IFTTT 将 RSS 订阅内容推送至 Telegram 的对话、群组或公开频道，形成属于自己的「信息流」。**

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/05/10.png" style="zoom:100%"/>

<!-- more -->

## 0 写在前面

本文不介绍具体教程，只记录其中使用的推送模板，留作以后参考。

**如果你想了解具体教程，推荐参考[这篇文章](https://sword.studio/157.html)。**

另外，**如果你也使用 [RSSHub](https://docs.rsshub.app/)，推荐参考[官方文档](https://docs.rsshub.app/install/#bu-shu-dao-vercel-zeit-now)将其部署至 [Vercel](https://vercel.com/)，**从而搭建属于自己的订阅引擎。

## 1 应用场景

在 Telegram 中，我创建了两个公开频道，分别是：

- **[ProgCZ's Blog - Channel](https://t.me/ProgCZChannel) 用于同步本博客更新的文章。**

- **[ProgCZ's Flow](https://t.me/ProgCZFlow) 用于建立专属于自己的信息流。**

## 2 推送模板

在 IFTTT 中，需要设置推送模板，分为两种情况：

- **对于内容较多的订阅源（比如博客文章），只是推送其标题、链接和来源，**模板如下：

  ```
  标题：<b>{{EntryTitle}}</b><br>
  <br>
  链接：<b>{{EntryUrl}}</b><br>
  <br>
  来自：<a href="{{FeedUrl}}">{{FeedTitle}}</a><br>
  ```

  同时，**开启「网页预览」功能。**

- **对于内容较少的订阅源（比如购物优惠），推送其标题、内容、链接和来源，**模板如下：

  ```
  标题：<b>{{EntryTitle}}</b><br>
  <br>
  {{EntryContent}}<br>
  <br>
  链接：<b>{{EntryUrl}}</b><br>
  <br>
  来自：<a href="{{FeedUrl}}">{{FeedTitle}}</a><br>
  ```

  同时，**关闭「网页预览」功能。**

## 3 预览效果

如果你想预览效果，可以在科学环境中访问 [ProgCZ's Blog - Channel](https://t.me/s/ProgCZChannel) 和 [ProgCZ's Flow](https://t.me/s/ProgCZFlow)。
