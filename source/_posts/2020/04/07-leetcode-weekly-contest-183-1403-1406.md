---
title:   LeetCode Weekly Contest 183 (1403 - 1406)
date:    2020-04-07 10:24:00
updated:
categories:
    - A03 - LeetCode
    - LeetCode Weekly Contest
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
---

LeetCode 周赛专题每周随缘更新，点击类别 [LeetCode Weekly Contest](/categories/LeetCode-Weekly-Contest/) 查看更多。

<!-- more -->

## [1403. Minimum Subsequence in Non-Increasing Order](https://leetcode.com/contest/weekly-contest-183/problems/minimum-subsequence-in-non-increasing-order/) #Easy

### 题目解析

将 `nums` 从大到小进行排序，遍历求和直到 `sum` 达到总和 `total` 的一半即可。

#### C++ 实现

```cpp
class Solution {
public:
    vector<int> minSubsequence(vector<int>& nums) {
        sort(nums.rbegin(), nums.rend());
        int total = 0, sum = 0;
        for (int num : nums) total += num;
        vector<int> res;
        for (int i = 0; i < nums.size() && sum < total/2+1; ++i) {
            res.push_back(nums[i]);
            sum += nums[i];
        }
        return res;
    }
};
```

## [1404. Number of Steps to Reduce a Number in Binary Representation to One](https://leetcode.com/contest/weekly-contest-183/problems/number-of-steps-to-reduce-a-number-in-binary-representation-to-one/) #Medium

### 题目解析

不断弹出字符串的末尾字符：

- 如果末尾字符为 `'0'`，则原数直接除 `2`，`res` 累加 `1`。

- 如果末尾字符为 `'1'`，则原数需要加 `1` 后除 `2`，`res` 累加 `2`。

  关于如何实现进位：向前遍历其紧邻的所有 `'1'`，修改为 `'0'`；遍历结束后判断下标是否在字符串内，是则说明遍历到了 `'0'`，修改为 `'1'`，否则说明遍历到了字符串开头，添加上 `'1'`。

#### C++ 实现

```cpp
class Solution {
public:
    int numSteps(string s) {
        int res = 0;
        for (int i = s.size()-1; i >= 0; --i) {
            if (s == "1") break;
            if (s[i] == '0') {
                ++res;
            } else {
                res += 2;
                int j = i-1;
                for (; j >= 0 && s[j] == '1'; --j) {
                    s[j] = '0';
                }
                if (j >= 0) {
                    s[j] = '1';
                } else {
                    s = '1' + s;
                    ++i;
                }
            }
            s.pop_back();
        }
        return res;
    }
};
```

## [1405. Longest Happy String](https://leetcode.com/contest/weekly-contest-183/problems/longest-happy-string/) #Medium

### 题目解析

首先，使用最小堆 `pq` 对三个字符的剩余个数进行排序。

其次，迭代取出堆顶即剩余个数最多的字符，判断当前 `res` 的末尾字符与其是否相同，是则说明该字符为上次迭代过程中的「间隔字符」，为了不出现 `3` 个重复的字符，`res` 累加 `1` 个该字符，否则 `res` 累加 `2` 个该字符。

{% note warning %}
需要注意的是，如果此时 `pq` 为空，说明没有字符能够作为「间隔字符」了，跳出循环即可。
{% endnote %}

然后，迭代取出堆顶即剩余个数次多的字符，将其作为「间隔字符」累加至 `res` 的末尾。

最后，如果字符还有剩余，则将其重新添加至 `pq` 即可。

#### C++ 实现

```cpp
class Solution {
public:
    string longestDiverseString(int a, int b, int c) {
        string res = "";
        priority_queue<pair<int, char>> pq;
        if (a) pq.push(make_pair(a, 'a'));
        if (b) pq.push(make_pair(b, 'b'));
        if (c) pq.push(make_pair(c, 'c'));
        while (!pq.empty()) {
            int mi = pq.top().first;
            char mc = pq.top().second;
            pq.pop();
            int add = (!res.empty() && res.back() == mc) ? 1 : min(2, mi);
            res += string(add, mc);
            mi -= add;
            if (pq.empty()) break;
            int smi = pq.top().first;
            char smc = pq.top().second;
            pq.pop();
            res += smc;
            smi -= 1;
            if (mi) pq.push(make_pair(mi, mc));
            if (smi) pq.push(make_pair(smi, smc));
        }
        return res;
    }
};
```

## [1406. Stone Game III](https://leetcode.com/contest/weekly-contest-183/problems/stone-game-iii/) #Hard

### 题目解析

> 参考：[[Java/C++/Python] DP, O(1) Space](https://leetcode.com/problems/stone-game-iii/discuss/564260/JavaC%2B%2BPython-DP-O(1)-Space)

不想班门弄斧，直接看大佬的解法吧。

#### C++ 实现

```cpp
class Solution {
public:
    string stoneGameIII(vector<int>& stoneValue) {
        int n = stoneValue.size();
        vector<int> dp(n, INT_MIN);
        for (int i = n - 1; i >= 0; --i) {
            for (int j = 0, take = 0; j < 3 && i + j < n; ++j) {
                take += stoneValue[i + j];
                dp[i] = max(dp[i], take - (i + j + 1 < n ? dp[i + j + 1] : 0));
            }
        }
        if (dp[0] > 0) return "Alice";
        if (dp[0] < 0) return "Bob";
        return "Tie";
    }
};
```
