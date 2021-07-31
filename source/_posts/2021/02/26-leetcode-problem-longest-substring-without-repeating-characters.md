---
title:   LeetCode Problem 3 - Longest Substring Without Repeating Characters
date:    2021-02-26 09:08:46
updated: 2021-03-03 08:07:21
categories:
    - A3 - LeetCode
    - B1 - LeetCode Problems
tags:
    - LeetCode
    - CPP
    - Hash Table
    - Two Pointers
    - String
    - Sliding Window
---

## 题目

<https://leetcode.com/problems/longest-substring-without-repeating-characters/>

### 大意

给定字符串，输出最长不重复子串的长度。

<!-- more -->

## 解法一：滑动窗口

借助 `hash_map`，建立起**子串中**字符和出现次数的映射，如果 `hash_map` 中所有字符的出现次数均不大于 `1`，那么就说明当前子串为不重复子串。

滑动窗口的左右边界分别为 `beg` 和 `end`（均初始化为 `0`），

1. 在遍历 `hash_map` 后判断当前子串为不重复子串的情况下，`end` 不断右移，同时将 `hash_map` 中对应字符的出现次数 `+1`。

2. 上述 `end` 的右移停止，说明 `end` 到达字符串末尾或者当前子串为重复子串，则记录不重复子串的最大长度。

3. 在遍历 `hash_map` 后判断当前子串为重复子串的情况下，`beg` 不断右移，同时将 `hash_map` 中对应字符的出现次数 `-1`。

4. 上述 `beg` 的右移停止，说明 `beg` 到达 `end` 或者当前子串不为重复子串，则重复整个流程。

### 复杂度分析

- 空间：`O(n)`（不太确定）

- 时间：`O(n)`

### C++ 实现

```cpp
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        unordered_map<char, int> um;
        int n = s.size(), res = 0;
        int beg = 0, end = 0;
        while (end < n) {
            while (end < n && helper(um)) {
                um[s[end++]-'a'] += 1;
            }
            int len = (end == n && helper(um)) ?
                (end - beg) : (end - beg - 1);
            res = max(res, len);
            while (beg <= end && !helper(um)) {
                um[s[beg++]-'a'] -= 1;
            }
        }
        return res;
    }
    bool helper(const unordered_map<char, int>& um) {
        auto iter = um.begin();
        while (iter != um.end()) {
            if (iter->second > 1) {
                return false;
            }
            ++iter;
        }
        return true;
    }
};
```

## 解法二：记旧账

对于当前字符来说，往前一个一个地推字符，如果某个字符出现了两次，那么该字符前一次出现的下标，一定是最长不重复子串起点的下标减一。

### 复杂度分析

- 空间复杂度：`O(1)`

- 时间复杂度：`O(n)`

### C++ 实现

> 参考：<https://leetcode.com/problems/longest-substring-without-repeating-characters/discuss/1730/Shortest-O(n)-DP-solution-with-explanations>

{% note info %}
因为 `char` 类型是 8 位，枚举值共有 256 种，所以可以使用 `array<int, 256>` 代替 `unordered_map<char, int>` 来实现字符和下标之间的映射。
{% endnote %}

```cpp
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        array<int, 256> arr; arr.fill(-1);
        int res = 0, loc = -1;
        for (int i = 0; i < s.size(); ++i) {
            // 等号右边的 `loc`，就是解法中提到的「前一次出现的下标」
            // 等号右边的 `arr[s[i]]`，就是当前字符的「前一次出现的下标」
            // 两者取最大，更新 `loc`，同时 `loc` 也就是：
            // 对于当前字符来说的，最长不重复子串起点的下标减一
            loc = max(loc, arr[s[i]]);
            // 计算：对于当前字符来说的，最长不重复子串的长度
            res = max(res, i-loc);
            // 更新 `arr[s[i]]`
            arr[s[i]] = i;
        }
        return res;
    }
};
```
