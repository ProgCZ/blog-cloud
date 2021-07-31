---
title:   LeetCode Biweekly Contest 25 (1431 - 1434)
date:    2020-05-08 11:34:43
updated: 2020-05-08 11:34:43
categories:
    - A3 - LeetCode
    - B3 - LeetCode Biweekly Contest
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
---

LeetCode 双周赛专题每双周随缘更新，点击类别 [LeetCode Biweekly Contest](/categories/LeetCode-Biweekly-Contest/) 查看更多。

<!-- more -->

## [1431. Kids With the Greatest Number of Candies](https://leetcode.com/contest/biweekly-contest-25/problems/kids-with-the-greatest-number-of-candies/) #Easy

### 题目解析

侮辱智商，不解释了。

#### C++ 实现

```cpp
class Solution {
public:
    vector<bool> kidsWithCandies(vector<int>& candies, int extraCandies) {
        int max_num = INT_MIN;
        for (auto candy : candies) {
            max_num = max(max_num, candy);
        }
        vector<bool> res;
        for (auto candy : candies) {
            res.push_back(candy + extraCandies >= max_num);
        }
        return res;
    }
};
```

## [1432. Max Difference You Can Get From Changing an Integer](https://leetcode.com/contest/biweekly-contest-25/problems/max-difference-you-can-get-from-changing-an-integer/) #Medium

### 题目解析

首先，对于 `a` 来说，从高位开始遍历，如果发现某位数字不为 `9`，那么将 `a` 中的所有该位数字替换为 `9`。

其次，对于 `b` 来说，如果发现第一位数字不为 `1`，那么将 `b` 中的所有该位数字替换为 `1`，否则从高位开始遍历，如果发现某位数字不为 `1` 且不为 `0`，那么将 `b` 中的所有该位数字替换为 `0`。

#### C++ 实现

```cpp
class Solution {
public:
    int maxDiff(int num) {
        int a = num, b = num, div = 1;
        while (num /= 10) div *= 10;
        int rep = -1, tdiv = div;
        while (tdiv) {
            if (rep == -1 && a / tdiv % 10 != 9) {
                rep = a / tdiv % 10;
            }
            if (a / tdiv % 10 == rep) {
                a = a + (9 - rep) * tdiv;
            }
            tdiv /= 10;
        }
        rep = -1, tdiv = div;
        bool f = false;
        if (b / div % 10 != 1) {
            rep = b / div % 10;
            f = true;
        }
        while (tdiv) {
            if (rep == -1 && b / tdiv % 10 != 1 && b / tdiv % 10 != 0) {
                rep = b / tdiv % 10;
            }
            if (b / tdiv % 10 == rep) {
                if (f) b = b + (1 - rep) * tdiv;
                else b = b + (0 - rep) * tdiv;
            }
            tdiv /= 10;
        }
        return a - b;
    }
};
```

## [1433. Check If a String Can Break Another String](https://leetcode.com/contest/biweekly-contest-25/problems/check-if-a-string-can-break-another-string/) #Medium

### 题目解析

再次侮辱智商，不解释了。

#### C++ 实现

```cpp
class Solution {
public:
    bool checkIfCanBreak(string s1, string s2) {
        sort(s1.begin(), s1.end());
        sort(s2.begin(), s2.end());
        const string &s3 = min(s1, s2);
        const string &s4 = max(s1, s2);
        int n = s3.size();
        for (int i = 0; i < n; ++i) {
            if (s3[i] > s4[i]) return false;
        }
        return true;
    }
};
```

## [1434. Number of Ways to Wear Different Hats to Each Other](https://leetcode.com/contest/biweekly-contest-25/problems/number-of-ways-to-wear-different-hats-to-each-other/) #Hard

### 题目解析

参考：[[C++] Bit-masks and Bottom-Up DP](https://leetcode.com/problems/number-of-ways-to-wear-different-hats-to-each-other/discuss/608686/C%2B%2B-Bit-masks-and-Bottom-Up-DP)

这种题目我已经放弃治疗了，直接看大佬的解法吧。

#### C++ 实现

```cpp
class Solution {
public:
    int numberWays(vector<vector<int>>& hats) {
        vector<vector<int>> persons(40);
        const int n = hats.size(), mod = 1e9 + 7;
        vector<int> masks(1 << n);
        masks[0] = 1;
        for (int i = 0; i < n; ++i) {
            for (const int &h: hats[i]) {
                persons[h - 1].emplace_back(i);
            }
        }
        for (int i = 0; i < 40; ++i) {
            for (int j = (1 << n) - 1; j >= 0; --j) {
                for (const int &p: persons[i]) {
                    if ((j & (1 << p)) == 0) {
                        masks[j | (1 << p)] += masks[j];
                        masks[j | (1 << p)] %= mod;
                    }
                }
            }
        }
        return masks[(1 << n) - 1];
    }
};
```
