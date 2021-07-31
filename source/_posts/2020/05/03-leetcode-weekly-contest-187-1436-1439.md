---
title:   LeetCode Weekly Contest 187 (1436 - 1439)
date:    2020-05-03 15:23:13
updated: 2020-05-03 15:23:13
categories:
    - A3 - LeetCode
    - B2 - LeetCode Weekly Contest
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
---

LeetCode 周赛专题每周随缘更新，点击类别 [LeetCode Weekly Contest](/categories/LeetCode-Weekly-Contest/) 查看更多。

本次比赛通过 `3` 题，时间为 `1:01:42`，排名为 `2281/12350`。

<!-- more -->

## [1436. Destination City](https://leetcode.com/contest/weekly-contest-187/problems/destination-city/) #Easy

### 题目解析

{% note info %}
问题转化：**在所有成对城市 `[cityA_i, cityB_i]` 中寻找只出现了一次的目的城市 `cityB_i`**。
{% endnote %}

使用 `map<string, int> m` 对城市进行标记，遍历所有的成对城市 `[cityA_i, cityB_i]`，出发城市 `cityA_i` 的标记值累加 `1`，目的城市 `cityB_i` 的标记值累加 `2`，那么在遍历结束之后，**标记值为 `1` 的为最初的城市，标记值为 `3` 的为路过的城市，标记值为 `2` 的为最后的城市。**

#### C++ 实现

```cpp
class Solution {
public:
    string destCity(vector<vector<string>>& paths) {
        map<string, int> m;
        for (auto vs : paths) {
            m[vs[0]] += 1;
            m[vs[1]] += 2;
        }
        for (auto p : m) {
            if (p.second == 2) return p.first;
        }
        return "";
    }
};
```

## [1437. Check If All 1's Are at Least Length K Places Away](https://leetcode.com/contest/weekly-contest-187/problems/check-if-all-1s-are-at-least-length-k-places-away/) #Medium

### 题目解析

实际上就是对 `1` 之间的 `0` 进行计数。

{% note warning %}
需要注意的是，开头和结尾出现的 `0` 没有夹在 `1` 之间，应该避开这些情况。
{% endnote %}

#### C++ 实现

```cpp
class Solution {
public:
    bool kLengthApart(vector<int>& nums, int k) {
        int idx = 0, n = nums.size();
        while (idx < n) {
            if (nums[idx] == 1) {
                int cnt = 0;
                while (++idx < n && nums[idx] == 0) ++cnt;
                if (idx < n && nums[idx] == 1 && cnt < k) return false;
            } else {
                ++idx;
            }
        }
        return true;
    }
};
```

## [1438. Longest Continuous Subarray With Absolute Diff Less Than or Equal to Limit](https://leetcode.com/contest/weekly-contest-187/problems/longest-continuous-subarray-with-absolute-diff-less-than-or-equal-to-limit) #Medium

### 题目解析

滑动窗口算法就可以解决。

使用 `map<int, int> m` 记录滑动窗口内出现的数字，**因为 `map` 是自动从小到大排序的，所以 `m.begin()` 指向的数字最小，`m.rbegin()` 指向的数字最大，**可以用函数 `bool func(int limit)` 检查滑动窗口内的数字是否满足题目要求，寻找滑动窗口的最大长度即可。

{% note info %}
滑动窗口算法可以参考这篇文章：[滑动窗口技巧](https://labuladong.gitbook.io/algo/suan-fa-si-wei-xi-lie/hua-dong-chuang-kou-ji-qiao)。
{% endnote %}

#### C++ 实现

```cpp
class Solution {
public:
    int longestSubarray(vector<int>& nums, int limit) {
        int res = 0, beg = 0, end = 0, n = nums.size();
        while (beg <= end && end < n) {
            while (end < n && func(limit)) {
                ++m[nums[end]];
                ++end;
            }
            if (end == n && func(limit)) res = max(res, end-beg);
            else res = max(res, end-beg-1);
            while (beg <= end && !func(limit)) {
                if (--m[nums[beg]] == 0) m.erase(nums[beg]);
                ++beg;
            }
        }
        return res;
    }
    bool func(int limit) {
        if (m.empty()) return true;
        else return m.rbegin()->first - m.begin()->first <= limit;
    }
private:
    map<int, int> m;
};
```

## [1439. Find the Kth Smallest Sum of a Matrix With Sorted Rows](https://leetcode.com/contest/weekly-contest-187/problems/find-the-kth-smallest-sum-of-a-matrix-with-sorted-rows/) #Hard

### 题目解析

参考：[simple solution with explanation [c++ code example]](https://leetcode.com/problems/find-the-kth-smallest-sum-of-a-matrix-with-sorted-rows/discuss/609707/simple-solution-with-explanation-c%2B%2B-code-example)

其实就是暴力累加，但是**在累加每一行之后，从小到大进行排序，只保留最多前 `k` 个数字，**因为后面的数字不可能参与到第 `k` 个最终数字的运算中。

#### C++ 实现

```cpp
class Solution {
public:
    int kthSmallest(vector<vector<int>>& mat, int k) {
        vector<int> vec = {0};
        for (int i = 0; i < mat.size(); ++i) {
            vector<int> tmp;
            for (int j = 0; j < mat[0].size(); ++j) {
                for (int t = 0; t < vec.size(); ++t) {
                    tmp.push_back(mat[i][j]+vec[t]);
                }
            }
            sort(tmp.begin(), tmp.end());
            int limit = min(k, static_cast<int>(tmp.size()));
            vec = vector<int>(tmp.begin(), tmp.begin()+limit);
        }
        return vec[k-1];
    }
};
```
