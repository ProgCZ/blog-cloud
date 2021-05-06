---
title:   LeetCode Weekly Contest 186 (1422 - 1425)
date:    2020-04-26 16:16:29
updated: 2020-04-26 16:16:29
categories:
    - A03 - LeetCode
    - LeetCode Weekly Contest
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
---

LeetCode 周赛专题每周随缘更新，点击类别 [LeetCode Weekly Contest](/categories/LeetCode-Weekly-Contest/) 查看更多。

本次比赛通过 `3` 题，时间为 `1:03:11`，排名为 `1553/11684`。

<!-- more -->

## [1422. Maximum Score After Splitting a String](https://leetcode.com/contest/weekly-contest-186/problems/maximum-score-after-splitting-a-string/) #Easy

### 题目解析

`cnt_zero` 和 `cnt_one` 分别用于统计左子串中 `0` 的个数和右子串中 `1` 的个数。

统计字符串 `s` 中共有多少个 `1` 之后，从左向右遍历的同时累加 `cnt_zero` 和 `cnt_one`，寻找遍历过程中两者和的最大值即可。

#### C++ 实现

```cpp
class Solution {
public:
    int maxScore(string s) {
        int cnt_zero = 0, cnt_one = 0, res = 0;
        for (auto ch : s) {
            if (ch == '1') ++cnt_one;
        }
        for (int i = 0; i < s.size()-1; ++i) {
            if (s[i] == '0') ++cnt_zero;
            else --cnt_one;
            res = max(res, cnt_zero+cnt_one);
        }
        return res;
    }
};
```

## [1423. Maximum Points You Can Obtain from Cards](https://leetcode.com/contest/weekly-contest-186/problems/maximum-points-you-can-obtain-from-cards/) #Medium

### 题目解析

实际上就是从左抽取 `x` 张牌，从右抽取 `k-x` 张牌，遍历寻找和的最大值即可。

#### C++ 实现

```cpp
class Solution {
public:
    int maxScore(vector<int>& cardPoints, int k) {
        int sum = 0, n = cardPoints.size();
        for (int i = 0; i < k; ++i) {
            sum += cardPoints[i];
        }
        int res = sum;
        for (int i = 0; i < k; ++i) {
            sum += cardPoints[n-i-1] - cardPoints[k-i-1];
            res = max(res, sum);
        }
        return res;
    }
};
```

## [1424. Diagonal Traverse II](https://leetcode.com/contest/weekly-contest-186/problems/diagonal-traverse-ii/) #Medium

### 题目解析

P.S. 一开始还使用了遍历整个矩阵（包括空白区域）的方法，但是题目提醒行、列都可能是 `10^5` 的量级，`O(n^2)` 的时间复杂度必然超时，还好题目提醒 `nums` 中元素个数不可能超过 `10^5`，那么就可以放心地遍历整个矩阵（不包括空白区域）。

{% note info %}
需要明白的是，同一斜线上的元素，其行号与列号的和是不变的，而且行号较大的元素排在前面。
{% endnote %}

首先，使用 `vec` 存放 `nums` 中每个元素的行号、列号和值。

其次，将 `vec` 进行自定义规则的排序，使得行号与列号的和较小的元素排在前面（也就是不同斜线之间的排序），如果和相等，则使得行号较大的元素排在前面（也就是同一斜线内部的排序）。

最后，按序提取出元素的值即可。

#### C++ 实现

```cpp
class Solution {
public:
    vector<int> findDiagonalOrder(vector<vector<int>>& nums) {
        vector<array<int, 3>> vec;
        for (int i = 0; i < nums.size(); ++i) {
            for (int j = 0; j < nums[i].size(); ++j) {
                vec.push_back({i, j, nums[i][j]});
            }
        }
        sort(vec.begin(), vec.end(), [](auto a, auto b) {
            int sa = a[0] + a[1], sb = b[0] + b[1];
            if (sa != sb) return sa < sb;
            else return a[0] > b[0];
        });
        vector<int> res;
        for (auto arr : vec) res.push_back(arr[2]);
        return res;
    }
};
```

## [1425. Constrained Subset Sum](https://leetcode.com/contest/weekly-contest-186/problems/constrained-subset-sum/) #Hard

### 题目解析

参考：[[Java/C++/Python] O(N) Decreasing Deque](https://leetcode.com/problems/constrained-subset-sum/discuss/597751/JavaC%2B%2BPython-O(N)-Decreasing-Deque)

首先，维护一个非上升队列 `q`（即保证 `q` 的队首元素是 `q` 中最大的元素），其中每个元素表示 `nums` 中以当前位置为结尾的子数组按照题目要求所能达到的最大值。

其次，遍历 `nums`，累加队首元素，寻找遍历过程中的最大值。

然后，如果 `nums[i]` 大于 `0`，那么舍弃 `q` 的队尾中比 `nums[i]` 小的元素（这些元素不可能再参与到运算当中了），并将 `nums[i]` 添加至队尾。

最后，如果 `q` 的队首元素刚好是 `nums[i]` 往前数第 `k` 个元素，那么根据题目要求舍弃 `q` 的队首元素。

#### C++ 实现

```cpp
class Solution {
public:
    int constrainedSubsetSum(vector<int>& nums, int k) {
        deque<int> q;
        int res = nums[0];
        for (int i = 0; i < nums.size(); ++i) {
            nums[i] += q.size() ? q.front() : 0;
            res = max(res, nums[i]);
            while (q.size() && nums[i] > q.back()) {
                q.pop_back();
            }
            if (nums[i] > 0) q.push_back(nums[i]);
            if (i >= k && q.size() && q.front() == nums[i-k]) {
                q.pop_front();
            }
        }
        return res;
    }
};
```
