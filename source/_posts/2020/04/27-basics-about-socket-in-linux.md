---
title:   Linux 系统中 socket 编程的入门必知
date:    2020-04-27 15:01:49
updated: 2020-04-27 15:01:49
categories:
    - A2 - 学习笔记
    - B3 - 开发基础
tags:
    - Linux
    - Network Programming
    - CPP
---

在计算机通信领域，socket 被译为「套接字」，是计算机之间进行通信的一种约定，本文介绍 socket 编程的入门必知，可以作为基础手册进行查阅。

<!-- more -->

> 【迁移】旧文日期：2019-09-05

## 1 socket 编程基础

### 1.1 socket 的不同类型

- `SOCK_STREAM`：流格式套接字，使用 TCP 协议进行数据传输。

- `SOCK_DGRAM`：数据报格式套接字，使用 UDP 协议进行数据传输。

### 1.2 socket 的不同函数

#### 1.2.1 `socket()`

用于创建套接字，确定套接字的各项属性：

```cpp
int socket(int af, int type, int protocol);
```

- `af` 为地址族，也就是IP地址类型，常用的有 `AF_INET` 和 `AF_INET6`，前者表示 IPv4 地址，后者表示 IPv6 地址。

- `type` 为数据传输方式，也就是套接字类型，常用的有 `SOCK_STREAM` 和 `SOCK_DGRAM`。

- `protocol` 为传输协议，常用的有 `IPPROTO_TCP` 和 `IPPTOTO_UDP`，前者表示 TCP 传输协议，后者表示 UDP 传输协议。

#### 1.2.2 `bind()` 和 `connect()`

服务端使用 `bind()` 将套接字和特定的 IP 地址、端口绑定起来：

```cpp
int bind(int sock, struct sockaddr *addr, socklen_t addrlen);
```

客户端使用 `connect()` 将套接字和特定的 IP 地址、端口绑定起来：

```cpp
int connect(int sock, struct sockaddr *serv_addr, socklen_t addrlen);
```

- `sock` 为套接字文件描述符。

- `addr` 为 `sockaddr` 结构体变量的指针。

- `addrlen` 为 `addr` 变量的大小，可以由 `sizeof()` 计算得到。

#### 1.2.3 `listen()` 和 `accept()`

服务端使用 `listen()` 使套接字进入被动监听状态：

```cpp
int listen(int sock, inr backlog);
```

- `sock` 为需要进入监听状态的套接字文件描述符。

- `backlog` 为请求队列的最大长度。其中，请求队列也就是请求的接收缓冲区，可以设置为 `SOMAXCONN`，由系统决定请求队列长度。当请求队列已满时，不再接收新的请求，客户端会收到 `ECONNREFUSED` 错误。

之后调用 `accept()` 函数，使进程处于阻塞状态，直到接收到客户端的请求：

```cpp
int accept(int sock, struct sockaddr *addr, socklen_t *addrlen);
```

需要注意的是，`accept()` 返回一个新的套接字用于和客户端通信。

#### 1.2.4 `write()` 和 `read()`

服务端使用 `write()` 向套接字写入数据，传送给客户端：

```cpp
ssize_t write(int fd, const void *buf, size_t nbytes);
```

- `fd` 为需要写入的文件描述符，此处即套接字文件描述符。

- `buf` 为需要写入的数据的缓冲区地址。

- `nbytes` 为需要写入的数据的字节数。

需要注意的是，写入成功则返回写入的字节数，失败则返回 `-1`。

客户端使用 `read()` 从套接字读入数据：

```cpp
ssize_t read(int fd, void *buf, size_t nbytes);
```

需要注意的是，读取成功则返回读取的字节数（在文件结尾返回 `0`），失败则返回 `-1`。

## 2 socket 编程样例

### 2.1 服务端代码 `server.cpp`

```cpp
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main() {
    // 创建套接字
    int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	
    // 将套接字与 IP、端口绑定
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serv_addr.sin_port = htons(1234);
    bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
	
    // 进入监听状态，等待用户发起请求
    listen(serv_sock, 20);
	
    // 接收客户端请求
    struct sockaddr_in clnt_addr;
    socklen_t clnt_addr_size = sizeof(clnt_addr);
    int clnt_sock = accept(serv_sock, (struct sockaddr*)&clnt_addr, &clnt_addr_size);
	
    // 向客户端发送数据
    char str[] = "Hello, World!";
    write(clnt_sock, str, sizeof(str));
	
    // 关闭套接字
    close(clnt_sock);
    close(serv_sock);

    return 0;
}
```

### 2.2 客户端代码 `client.cpp`

```cpp
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

int main() {
    // 创建套接字
    int sock = socket(AF_INET, SOCK_STREAM, 0);
	
    // 向服务端发送请求
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serv_addr.sin_port = htons(1234);
    connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
	
    // 读取服务端传回的数据
    char buffer[40];
    read(sock, buffer, sizeof(buffer)-1);
    printf("Massage: %s\n", buffer);
	
    // 关闭套接字
    close(sock);

    return 0;
}
```
