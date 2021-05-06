---
title:   LeetCode Biweekly Contest 23 (1399 - 1402)
date:    2020-04-06 10:24:00
updated: 2020-04-06 10:24:00
categories:
    - A03 - LeetCode
    - LeetCode Biweekly Contest
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
---

LeetCode 双周赛专题每双周随缘更新，点击类别 [LeetCode Biweekly Contest](/categories/LeetCode-Biweekly-Contest/) 查看更多。

<!-- more -->

## [1399. Count Largest Group](https://leetcode.com/contest/biweekly-contest-23/problems/count-largest-group/) #Easy

### 题目解析

根据给出的数据范围 `1 <= n <= 10^4`，可以判断数字的每位之和一定不超过 `36`，所以可以用 `arr` 记录每种情况出现的次数，排序后找出并列最多的次数有多少即可。

#### C++ 实现

```cpp
class Solution {
public:
    int countLargestGroup(int n) {
        array<int, 37> arr = {};
        for (int i = 1; i <= n; ++i) {
            int t = i, sum = 0;
            while (t) {
                sum += t % 10;
                t /= 10;
            }
            ++arr[sum];
        }
        sort(arr.rbegin(), arr.rend());
        int m = arr[0], idx = 0;
        while (idx < 37 && arr[idx] == m) {
            ++idx;
        }
        return idx;
    }
};
```

## [1400. Construct K Palindrome Strings](https://leetcode.com/contest/biweekly-contest-23/problems/construct-k-palindrome-strings/) #Medium

### 题目解析

其实，只有两种情况不能将 `s` 拆分为 `k` 个回文子串：

- `s` 中字符不足 `k` 个。

  显而易见，不需要多加说明。

- `s` 中出现次数为奇数的字符超过 `k` 个。

  出现次数为奇数的字符如果出现在回文子串中，那么必然出现在最中间的位置，所以这样的字符有多少个，拆分的子串也至少有多少个。

#### C++ 实现

```cpp
class Solution {
public:
    bool canConstruct(string s, int k) {
        if (s.size() < k) return false;
        array<int, 26> arr = {};
        for (char ch : s) ++arr[ch-'a'];
        int odd = 0;
        for (int i : arr) {
            if (i & 0x1) ++odd;
        }
        return odd <= k;
    }
};
```

## [1401. Circle and Rectangle Overlapping](https://leetcode.com/contest/biweekly-contest-23/problems/circle-and-rectangle-overlapping/) #Medium

### 题目解析

首先，判断圆心是否在矩形内，是则必然重叠。

其次，遍历矩形四条边上的点，判断其与圆心的距离是否小于半径，是则必然重叠。

#### C++ 实现

```cpp
class Solution {
public:
    bool checkOverlap(int radius, int x_center, int y_center, int x1, int y1, int x2, int y2) {
        if (x_center >= x1 && x_center <= x2 && y_center >= y1 && y_center <= y2) {
            return true;
        }
        for (int x = x1; x <= x2; ++x) {
            long long dx = (x - x_center) * (x - x_center);
            long long dy1 = (y1 - y_center) * (y1 - y_center);
            long long dy2 = (y2 - y_center) * (y2 - y_center);
            if (dx + dy1 <= radius * radius || dx + dy2 <= radius * radius) {
                return true;
            }
        }
        for (int y = y1; y <= y2; ++y) {
            long long dx1 = (x1 - x_center) * (x1 - x_center);
            long long dx2 = (x2 - x_center) * (x2 - x_center);
            long long dy = (y - y_center) * (y - y_center);
            if (dx1 + dy <= radius * radius || dx2 + dy <= radius * radius) {
                return true;
            }
        }
        return false;
    }
};
```

## [1402. Reducing Dishes](https://leetcode.com/contest/biweekly-contest-23/problems/reducing-dishes/) #Hard

### 题目解析

首先，将 `satisfaction` 从大到小进行排序，优先处理满意度高的菜品。

其次，声明 `res` 用于表示总体满意度，声明 `total` 用于表示累加满意度，也就是随着时间增加，之前处理菜品的满意度不断增长的部分。

然后，如果某个菜品的满意度为负，不一定需要放弃这个菜品，因为之前处理菜品增长的满意度可能可以覆盖这个菜品的满意度，从而使得总体满意度还是增长的，所以需要满足某个菜品的满意度将累加满意度拖累为负，那么就需要放弃这个菜品。

#### C++ 实现

```cpp
class Solution {
public:
    int maxSatisfaction(vector<int>& satisfaction) {
        sort(satisfaction.rbegin(), satisfaction.rend());
        int res = 0, total = 0;
        for (int i = 0; i < satisfaction.size() && satisfaction[i] > -total; ++i) {
            total += satisfaction[i];
            res += total;
        }
        return res;
    }
};
```
