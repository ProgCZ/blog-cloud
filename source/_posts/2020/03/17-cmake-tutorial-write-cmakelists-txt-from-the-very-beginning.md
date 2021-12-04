---
title:   CMake 教程：从零开始编写 CMakeLists.txt
date:    2020-03-17 10:24:00
updated: 2020-03-17 10:24:00
categories:
    - A3 - 技术
    - B2 - 编程语言
    - C1 - CPP
tags:
    - 教程
    - CMake
    - CMakeLists.txt
    - CPP
    - Linux
---

CMake 是跨平台的开源工具，可以用于编译、测试和打包软件，本文从零开始编写一个比较基础的 `CMakeLists.txt`，记录其特有的语法。

<!-- more -->

CMake 官网：<https://cmake.org/>

CMake 源码地址（镜像）：<https://github.com/Kitware/CMake>

CMake 英文教程（最新版本）：<https://cmake.org/cmake/help/latest/guide/tutorial/index.html>

CMake 文档搜索（最新版本）：<https://cmake.org/cmake/help/latest/search.html>

{% note warning %}
本文使用 Ubuntu 当前版本为 `16.04`，使用 CMake 当前版本为 `3.17.20200315-ga6d95f5`，`CMakeLists.txt` 设置 CMake 最低版本为 `3.5`。因而，命令和语法可能与读者所用版本有所不同，望周知。
{% endnote %}

## 0 教程源码

GitHub 地址：<https://github.com/ProgCZ/code-cloud-a/tree/master/2020/03/cmake-tutorial>

读者可以下载整个仓库，进入指定目录查看源码：

```bash
$ git clone --depth=1 https://github.com/ProgCZ/code-cloud-a.git
$ cd code-cloud-a/2020/03/cmake-tutorial
```

## 1 创建基础模板

**根目录中的 `CMakeLists.txt` 文件一览：**

```cmake
cmake_minimum_required(VERSION 3.5)

# set the project name and version
project(Tutorial VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# configure a header file to pass some of the CMake settings
# to the source code
configure_file(TutorialConfig.h.in TutorialConfig.h)

# add the executable
add_executable(Tutorial main.cpp)

# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}")
```

### 1.1 设置 CMake 最低版本

```cmake
# Format
cmake_minimum_required(VERSION <min>[...<max>] [FATAL_ERROR])
# Example
cmake_minimum_required(VERSION 3.5)
```

> 参考：<https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html>

### 1.2 设置项目名称和版本

```cmake
# Format
project(<PROJECT-NAME> [<language-name>...])
project(<PROJECT-NAME>
        [VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]
        [DESCRIPTION <project-description-string>]
        [HOMEPAGE_URL <url-string>]
        [LANGUAGES <language-name>...])
# Example
project(Tutorial VERSION 1.0)
```

- 上述指令设置变量：

  - `PROJECT_NAME`

  - `PROJECT_SOURCE_DIR` 和 `<PROJECT-NAME>_SOURCE_DIR`

  - `PROJECT_BINARY_DIR` 和 `<PROJECT-NAME>_BINARY_DIR`

- 选项 `VERSION` 设置变量：

  - `PROJECT_VERSION` 和 `<PROJECT-NAME>_VERSION`

  - `PROJECT_VERSION_MAJOR` 和 `<PROJECT-NAME>_VERSION_MAJOR`

  - `PROJECT_VERSION_MINOR` 和 `<PROJECT-NAME>_VERSION_MINOR`

  - `PROJECT_VERSION_PATCH` 和 `<PROJECT-NAME>_VERSION_PATCH`

  - `PROJECT_VERSION_TWEAK` 和 `<PROJECT-NAME>_VERSION_TWEAK`

> 参考：<https://cmake.org/cmake/help/latest/command/project.html>

### 1.3 设置 C++ 标准

```cmake
# Example
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
```

### 1.4 传递 CMake 变量

```cmake
# Format
configure_file(<input> <output>
               [COPYONLY] [ESCAPE_QUOTES] [@ONLY]
               [NEWLINE_STYLE [UNIX|DOS|WIN32|LF|CRLF] ])
# Example
configure_file(TutorialConfig.h.in TutorialConfig.h)
```

可以将头文件模板 `TutorialConfig.h.in`：

```cpp
// TutorialConfig.h.in
// the configured options and settings for Tutorial
#define Tutorial_VERSION_MAJOR @Tutorial_VERSION_MAJOR@
#define Tutorial_VERSION_MINOR @Tutorial_VERSION_MINOR@
```

在预处理阶段改写为头文件 `TutorialConfig.h`：

```cpp
// TutorialConfig.h
// the configured options and settings for Tutorial
#define Tutorial_VERSION_MAJOR 1
#define Tutorial_VERSION_MINOR 0
```

> 参考：<https://cmake.org/cmake/help/latest/command/configure_file.html>

### 1.5 添加可执行文件

```cmake
# Format
add_executable(<name> [WIN32] [MACOSX_BUNDLE]
               [EXCLUDE_FROM_ALL]
               [source1] [source2 ...])
# Example
add_executable(Tutorial main.cpp)
```

上述指令从源代码 `main.cpp`：

```cpp
#include <cmath>
#include <string>
#include <iostream>
#include "TutorialConfig.h"

int main(int argc, char const *argv[]) {
    if (argc < 2) {
        std::cout << argv[0] << " Version: "
            << Tutorial_VERSION_MAJOR << "."
            << Tutorial_VERSION_MINOR << std::endl;
        std::cerr << "Usage: " << argv[0]
            << " number" << std::endl;
        return 1;
    }

    const double inputValue = std::stod(argv[1]);
    const double outputValue = sqrt(inputValue);
    std::cout << "The square root of " << inputValue
        << " is " << outputValue << std::endl;
    return 0;
}
```

编译产生可执行文件 `Tutorial`。

> 参考：<https://cmake.org/cmake/help/latest/command/add_executable.html>

### 1.6 添加 `include` 目录

```cmake
# Format
target_include_directories(<target> [SYSTEM] [BEFORE]
    <INTERFACE|PUBLIC|PRIVATE> [items1...]
    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])
# Example
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}")
```

上述指令添加 `include` 目录，使编译器能够找到头文件 `TutorialConfig.h`。

> 参考：<https://cmake.org/cmake/help/latest/command/target_include_directories.html>

### 1.7 编译项目

```bash
$ mkdir build && cd build
$ cmake .. && cmake --build .
-- The C compiler identification is GNU 5.4.0
-- The CXX compiler identification is GNU 5.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc - works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ - works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /home/peter/Projects/test_cmake_ws/build
Scanning dependencies of target Tutorial
[ 50%] Building CXX object CMakeFiles/Tutorial.dir/main.cpp.o
[100%] Linking CXX executable Tutorial
[100%] Built target Tutorial
```

### 1.8 运行项目

```bash
$ ./Tutorial 10
The square root of 10 is 3.16228
$ ./Tutorial
./Tutorial Version: 1.0
Usage: ./Tutorial number
```

## 2 加入自定义库

某些情况下，需要添加一个自定义库，比如 `MathFunctions` 库：

```bash
├── main.cpp
├── MathFunctions
│   ├── MathFunctions.h
│   └── mysqrt.cpp
```

---

**`MathFunctions` 目录中的 `CMakeLists.txt` 文件一览：**

```cmake
add_library(MathFunctions mysqrt.cpp)

# state that anybody linking to us needs to include the current source dir
# to find MathFunctions.h, while we don't.
target_include_directories(MathFunctions
    INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
```

### 2.1 为库的用户添加库

```cmake
# Format
add_library(<name> [STATIC | SHARED | MODULE]
            [EXCLUDE_FROM_ALL]
            [source1] [source2 ...])
# Example
add_library(MathFunctions mysqrt.cpp)
```

参考：<https://cmake.org/cmake/help/latest/command/add_library.html>

### 2.2 为库的用户添加 `include` 目录

```cmake
# Example
target_include_directories(MathFunctions
    INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
```

上述指令**为库的用户**添加 `include` 目录，使编译器能够找到头文件 `MathFunctions.h`。

---

**根目录中的`CMakeLists.txt` 文件一览：**

```cmake
cmake_minimum_required(VERSION 3.5)

# set the project name and version
project(Tutorial VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# should we use our own math functions
option(USE_MYMATH "Use tutorial provided math implementation" ON)

# configure a header file to pass some of the CMake settings
# to the source code
configure_file(TutorialConfig.h.in TutorialConfig.h)

# add the MathFunctions library
if(USE_MYMATH)
    add_subdirectory(MathFunctions)
    list(APPEND EXTRA_LIBS MathFunctions)
endif()

# add the executable
add_executable(Tutorial main.cpp)

target_link_libraries(Tutorial PUBLIC ${EXTRA_LIBS})

# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}")
```

### 2.3 传递 `USE_MYMATH` 选项

```cmake
# Format
option(<variable> "<help_text>" [value])
# Example
option(USE_MYMATH "Use tutorial provided math implementation" ON)
```

修改头文件模板 `TutorialConfig.h.in`：

```cpp
// the configured options and settings for Tutorial
#define Tutorial_VERSION_MAJOR @Tutorial_VERSION_MAJOR@
#define Tutorial_VERSION_MINOR @Tutorial_VERSION_MINOR@
#cmakedefine USE_MYMATH
```

根据 `USE_MYMATH` 选项判断使用哪个函数：

```cpp
#ifdef USE_MYMATH
    #include "MathFunctions.h"
#endif

int main(int argc, char const *argv[]) {
    // ...
    #ifdef USE_MYMATH
        const double outputValue = mysqrt(inputValue);
    #else
        const double outputValue = sqrt(inputValue);
    #endif
    std::cout << "The square root of " << inputValue
        << " is " << outputValue << std::endl;
    return 0;
}
```

### 2.4 添加 `MathFunctions` 目录

```cmake
# Format
add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
# Example
add_subdirectory(MathFunctions)
```

参考：<https://cmake.org/cmake/help/latest/command/add_subdirectory.html>

### 2.5 添加链接库

```cmake
# Format
list(APPEND <list> [<element>...])
# Example
list(APPEND EXTRA_LIBS MathFunctions)
```

参考：<https://cmake.org/cmake/help/latest/command/list.html>

```cmake
# Format
target_link_libraries(<target>
                      <PRIVATE|PUBLIC|INTERFACE> <item>...
                      [<PRIVATE|PUBLIC|INTERFACE> <item>...]...)
# Example
target_link_libraries(Tutorial PUBLIC ${EXTRA_LIBS})
```

参考：<https://cmake.org/cmake/help/latest/command/target_link_libraries.html>

### 2.6 编译项目

```bash
$ cd build
$ cmake -DUSE_MYMATH=ON .. && cmake --build .
$ cmake -DUSE_MYMATH=OFF .. && cmake --build .
```

## 3 安装和测试

### 3.1 设置安装目录

**在 `MathFunctions` 目录中的 `CMakeLists.txt` 文件最后添加：**

```cmake
install(TARGETS MathFunctions DESTINATION lib)
install(FILES MathFunctions.h DESTINATION include)
```

**在根目录中的 `CMakeLists.txt` 文件最后添加：**

```cmake
install(TARGETS Tutorial DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/TutorialConfig.h"
    DESTINATION include)
```

### 3.2 安装项目

CMake 的 `3.15` 以下版本只能使用：

```bash
$ cd build
$ sudo make install
```

CMake 的 `3.15` 及以上版本可以使用：

```bash
$ cd build
$ sudo cmake --install .
```

上述指令默认将项目安装在 `/usr/local/` 路径下，可以指定安装路径：

```bash
$ sudo cmake --install . --prefix /tmp/
```

安装之后就可以直接调用 `Tutorial`，而不是 `./Tutorial`。

### 3.3 设置测试样例

**在根目录中的 `CMakeLists.txt` 文件最后添加：**

```cmake
enable_testing()

# does the application run
add_test(NAME Runs COMMAND Tutorial 25)

# does the usage message work?
add_test(NAME Usage COMMAND Tutorial)
set_tests_properties(Usage
    PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number")

# define a function to simplify adding tests
function(do_test target arg result)
    add_test(NAME Comp${arg} COMMAND ${target} ${arg})
    set_tests_properties(Comp${arg}
        PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endfunction(do_test)

# do a bunch of result based tests
do_test(Tutorial 5 "5 is 2.236")
do_test(Tutorial -25 "-25 is [-nan|nan|0]")
```

#### 3.3.1 简单测试

```cmake
# Format
add_test(NAME <name> COMMAND <command> [<arg>...]
         [CONFIGURATIONS <config>...]
         [WORKING_DIRECTORY <dir>]
         [COMMAND_EXPAND_LISTS])
# Example
add_test(NAME Runs COMMAND Tutorial 25)
```

上述指令简单测试项目是否能够运行，通过则表示未报错、未崩溃、返回 `0`。

> 参考：<https://cmake.org/cmake/help/latest/command/add_test.html>

#### 3.3.2 对比测试

```cmake
# Format
add_test(NAME <name> COMMAND <command> [<arg>...]
         [CONFIGURATIONS <config>...]
         [WORKING_DIRECTORY <dir>]
         [COMMAND_EXPAND_LISTS])
set_tests_properties(test1 [test2...] PROPERTIES prop1 value1 prop2 value2)
# Example
add_test(NAME Usage COMMAND Tutorial)
set_tests_properties(Usage
    PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number")
```

上述指令对比测试项目的输出与正则表达式是否匹配，可以将其封装为函数：

```cmake
# Example
function(do_test target arg result)
    add_test(NAME Comp${arg} COMMAND ${target} ${arg})
    set_tests_properties(Comp${arg}
        PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endfunction(do_test)
```

### 3.4 测试项目

```bash
$ cd build
$ ctest -VV
UpdateCTestConfiguration  from :/home/peter/Projects/test_cmake_ws/build/DartConfiguration.tcl
UpdateCTestConfiguration  from :/home/peter/Projects/test_cmake_ws/build/DartConfiguration.tcl
Test project /home/peter/Projects/test_cmake_ws/build
Constructing a list of tests
Done constructing a list of tests
Updating test list for fixtures
Added 0 tests to meet fixture requirements
Checking test dependency graph...
Checking test dependency graph end
test 1
    Start 1: Runs

1: Test command: /home/peter/Projects/test_cmake_ws/build/Tutorial "25"
1: Test timeout computed to be: 10000000
1: The square root of 25 is 5
1/4 Test #1: Runs .............................   Passed    0.03 sec
test 2
    Start 2: Usage

2: Test command: /home/peter/Projects/test_cmake_ws/build/Tutorial
2: Test timeout computed to be: 10000000
2: /home/peter/Projects/test_cmake_ws/build/Tutorial Version: 1.0
2: Usage: /home/peter/Projects/test_cmake_ws/build/Tutorial number
2/4 Test #2: Usage ............................   Passed    0.00 sec
test 3
    Start 3: Comp5

3: Test command: /home/peter/Projects/test_cmake_ws/build/Tutorial "5"
3: Test timeout computed to be: 10000000
3: The square root of 5 is 2.23607
3/4 Test #3: Comp5 ............................   Passed    0.00 sec
test 4
    Start 4: Comp-25

4: Test command: /home/peter/Projects/test_cmake_ws/build/Tutorial "-25"
4: Test timeout computed to be: 10000000
4: The square root of -25 is -nan
4/4 Test #4: Comp-25 ..........................   Passed    0.01 sec

100% tests passed, 0 tests failed out of 4

Total Test time (real) =   0.12 sec
```

## 4 写在最后

未来一段时间可能会找一些优秀的 C++ 项目源码来阅读，学习编码技巧的同时也能进一步了解如何编写项目的 `CMakeLists.txt`。
