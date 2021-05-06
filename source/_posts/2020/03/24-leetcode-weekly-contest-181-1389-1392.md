---
title:   LeetCode Weekly Contest 181 (1389 - 1392)
date:    2020-03-24 10:24:00
updated: 2020-03-24 10:24:00
categories:
    - A03 - LeetCode
    - LeetCode Weekly Contest
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
    - String
---

LeetCode 周赛专题每周随缘更新，点击类别 [LeetCode Weekly Contest](/categories/LeetCode-Weekly-Contest/) 查看更多。

<!-- more -->

## [1389. Create Target Array in the Given Order](https://leetcode.com/contest/weekly-contest-181/problems/create-target-array-in-the-given-order/) #Easy

### 题目解析

不追求效率的话，直接使用标准库方法，在 `vector` 的对应下标插入对应元素即可。

#### C++ 实现

```cpp
class Solution {
public:
    vector<int> createTargetArray(vector<int>& nums, vector<int>& index) {
        int n = nums.size();
        vector<int> res;
        for (int i = 0; i < n; ++i) {
            res.insert(res.begin()+index[i], nums[i]);
        }
        return res;
    }
};
```

## [1390. Four Divisors](https://leetcode.com/contest/weekly-contest-181/problems/four-divisors/) #Medium

### 题目解析

寻找 `nums` 中每个数字的第一个因数，一旦出现第二个因数，则停止寻找并不计入结果。

如果找到的第一个因数刚好是数字的算术平方根，则也不计入结果。

#### C++ 实现

```cpp
class Solution {
public:
    int sumFourDivisors(vector<int>& nums) {
        int res = 0;
        for (int num : nums) {
            int fac = 0;
            for (int i = 2; i * i <= num; ++i) {
                if (num % i == 0) {
                    if (fac == 0) {
                        fac = i;
                    } else {
                        fac = 0;
                        break;
                    }
                }
            }
            if (fac != 0 && fac * fac != num) {
                res += 1 + fac + num/fac + num;
            }
        }
        return res;
    }
};
```

## [1391. Check if There is a Valid Path in a Grid](https://leetcode.com/contest/weekly-contest-181/problems/check-if-there-is-a-valid-path-in-a-grid/) #Medium

### 题目解析

深度优先搜索。

P.S. 搜索的时候用了暴力枚举，感觉可以用个固定的 `set` 来遍历判断，更优雅一点。

#### C++ 实现

```cpp
class Solution {
public:
    bool hasValidPath(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        vector<vector<bool>> visited(m, vector<bool>(n, false));
        return helper1(grid, visited, 0, 0);
    }
    bool helper1(vector<vector<int>> &grid,
                 vector<vector<bool>> &visited,
                 int i, int j) {
        int m = grid.size(), n = grid[0].size();
        if (i < 0 || i >= m || j < 0 || j >= n || visited[i][j]) {
            return false;
        }
        if (i == m - 1 && j == n - 1) return true;
        visited[i][j] = true;
        bool b = false;
        if ((grid[i][j] == 2 || grid[i][j] == 5 || grid[i][j] == 6) && (i-1 >= 0) &&
            (grid[i-1][j] == 2 || grid[i-1][j] == 3 || grid[i-1][j] == 4)) {
            b = b || helper1(grid, visited, i-1, j);
        }
        if ((grid[i][j] == 2 || grid[i][j] == 3 || grid[i][j] == 4) && (i+1 < m) &&
            (grid[i+1][j] == 2 || grid[i+1][j] == 5 || grid[i+1][j] == 6)) {
            b = b || helper1(grid, visited, i+1, j);
        }
        if ((grid[i][j] == 1 || grid[i][j] == 3 || grid[i][j] == 5) && (j-1 >= 0) &&
            (grid[i][j-1] == 1 || grid[i][j-1] == 4 || grid[i][j-1] == 6)) {
            b = b || helper1(grid, visited, i, j-1);
        }
        if ((grid[i][j] == 1 || grid[i][j] == 4 || grid[i][j] == 6) && (j+1 < n) &&
            (grid[i][j+1] == 1 || grid[i][j+1] == 3 || grid[i][j+1] == 5)) {
            b = b || helper1(grid, visited, i, j+1);
        }
        visited[i][j] = false;
        return b;
    }
};
```

## [1392. Longest Happy Prefix](https://leetcode.com/contest/weekly-contest-181/problems/longest-happy-prefix/) #Hard

### 题目解析

分别从头和尾遍历字符串的前缀和后缀，把遍历到的字符串看作是二十六进制的数字，将其转化为十进制的长整型，判断前缀和后缀是否相等，相等则记录当前下标。

{% note warning %}
需要注意的是，因为转化过程中可能产生较大的数字，所以应该对 `1e9+7` 取余。
{% endnote %}

#### C++ 实现

```cpp
class Solution {
public:
    string longestPrefix(string s) {
        long long h1 = 0, h2 = 0, mul = 1, len = 0, mod = 1e9+7;
        for (int i = 0, j = s.size()-1; j > 0; ++i, --j) {
            int first = s[i] - 'a', last = s[j] - 'a';
            h1 = (h1 * 26 + first) % mod;
            h2 = (h2 + last * mul) % mod;
            mul = mul * 26 % mod;
            if (h1 == h2) len = i + 1;
        }
        return s.substr(0, len);
    }
};
```
