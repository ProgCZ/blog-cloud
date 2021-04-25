---
title:   LeetCode Biweekly Contest 22 (1385 - 1388)
date:    2020-03-29 10:24:00
updated:
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

## [1385. Find the Distance Value Between Two Arrays](https://leetcode.com/contest/biweekly-contest-22/problems/find-the-distance-value-between-two-arrays/) #Easy

### 题目解析

没啥好说的，暴力遍历判断即可。

#### C++ 实现

```cpp
class Solution {
public:
    int findTheDistanceValue(vector<int>& arr1, vector<int>& arr2, int d) {
        int n1 = arr1.size(), n2 = arr2.size(), cnt = 0;
        for (int i = 0; i < n1; ++i) {
            bool b = true;
            for (int j = 0; j < n2; ++j) {
                if (abs(arr1[i]-arr2[j]) <= d) {
                    b = false;
                    break;
                }
            }
            if (b) ++cnt;
        }
        return cnt;
    }
};
```

## [1386. Cinema Seat Allocation](https://leetcode.com/contest/biweekly-contest-22/problems/cinema-seat-allocation/) #Medium

### 题目解析

首先，假定每行都是空的，那么就可以有 `n*2` 个四连座。

其次，将每一行被占座位记录到 `um` 中。

然后，判断每一行被占座位的区间：

- 如果在 `[2, 5]` 中，那么说明左侧不存在四连座，标记 `le`。

- 如果在 `[6, 9]` 中，那么说明右侧不存在四连座，标记 `ri`。

- 如果在 `[4, 7]` 中，那么说明中间不存在四连座，标记 `mi`。

最后，如果左侧和右侧都不存在四连座，则 `res` 累减，但是如果此时中间存在四连座，则 `res` 累加。

#### C++ 实现

```cpp
class Solution {
public:
    int maxNumberOfFamilies(int n, vector<vector<int>>& reservedSeats) {
        unordered_map<int, vector<int>> um;
        int res = n * 2;
        for (auto &ivec : reservedSeats) {
            um[ivec[0]].push_back(ivec[1]);
        }
        for (auto &p : um) {
            int le = false, ri = false, mi = false;
            for (auto &i : p.second) {
                if (1 < i && i < 6) le = true;
                if (5 < i && i < 10) ri = true;
                if (3 < i && i < 8) mi = true;
            }
            if (le) --res;
            if (ri) --res;
            if (le && ri && !mi) ++res;
        }
        return res;
    }
};
```

## [1387. Sort Integers by The Power Value](https://leetcode.com/contest/biweekly-contest-22/problems/sort-integers-by-the-power-value) #Medium

### 题目解析

重点在于需要重写排序规则：根据数字的能量值从小到大进行排序，如果能量值相等，则根据数字本身从小到大进行排序。

而在计算能量值的过程中，显然有大量的重复运算，则采用动态规划思想，将计算过的能量值存入 `um` 中，如果后续的数字存在于 `um` 中，则直接返回其对应的结果，避免重复运算。

#### C++ 实现

```cpp
class Solution {
public:
    int getKth(int lo, int hi, int k) {
        unordered_map<int, int> um;
        um[1] = 0;
        vector<int> ivec;
        for (int i = lo; i <= hi; ++i) {
            ivec.push_back(i);
        }
        sort(ivec.begin(), ivec.end(), [&um, this](const int &a, const int &b){
            return helper1(um, a) < helper1(um, b) ||
                (helper1(um, a) == helper1(um, b) && a < b);
        });
        return ivec[k-1];
    }
    int helper1(unordered_map<int, int> &um, int num) {
        if (um.find(num) != um.end()) return um[num];
        if (num & 0x01) um[num] = helper1(um, num*3+1)+1;
        else um[num] = helper1(um, num/2)+1;
        return um[num];
    }
};
```

## [1388. Pizza With 3n Slices](https://leetcode.com/contest/biweekly-contest-22/problems/pizza-with-3n-slices/) #Hard

### 题目解析

> 参考：[[Python/C++] O(n) space, Easy DP with explanation](https://leetcode.com/problems/pizza-with-3n-slices/discuss/546442/PythonC%2B%2B-O(n)-space-Easy-DP-with-explanation)

说实话，看了半天都没看懂大神的解法，单纯放一下代码吧。

#### C++ 实现

```cpp
class Solution {
public:
    int maxSizeSlices(vector<int>& slices) {
        return max(helper1(slices, 0), helper1(slices, 1));
    }
    int helper1(vector<int>& slices, int start) {
        int n = slices.size();
        vector<vector<int>> dp(n+2, vector<int>(n/3+1, 0));
        for (int i = 2; i <= n; ++i) {
            for (int j = 1; j <= n/3; ++j) {
                dp[i][j] = max(dp[i-1][j], dp[i-2][j-1]+slices[i-2+start]);
            }
        }
        return dp[n][n/3];
    }
};
```
