---
title:   LeetCode Weekly Contest 188 (1441 - 1444)
date:    2020-05-10 15:14:53
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

本次比赛通过 `3` 题，时间为 `1:14:56`，排名为 `2375/12715`。

<!-- more -->

## [1441. Build an Array With Stack Operations](https://leetcode.com/contest/weekly-contest-188/problems/build-an-array-with-stack-operations/) #Easy

### 题目解析

首先，遍历 `target`，在 `res` 中添加 `"Push"`。

其次，累加 `num`，如果遍历到的数字与 `num` 不同，那么在 `res` 中添加 `"Pop"`，同时将遍历下标 `i` 停在当前位置。

#### C++ 实现

```cpp
class Solution {
public:
    vector<string> buildArray(vector<int>& target, int n) {
        vector<string> res;
        int num = 1;
        for (int i = 0; i < target.size(); ++i) {
            res.push_back("Push");
            if (num != target[i]) {
                res.push_back("Pop");
                --i;
            }
            ++num;
        }
        return res;
    }
};
```

## [1442. Count Triplets That Can Form Two Arrays of Equal XOR](https://leetcode.com/contest/weekly-contest-188/problems/count-triplets-that-can-form-two-arrays-of-equal-xor) #Medium

### 题目解析

{% note info %}
需要明白的是，异或运算具备一个重要性质：如果　`a ^ b ^ c ^ d = e`，那么　`c ^ d = e ^ (a ^ b)`。
{% endnote %}

首先，使用 `vec` 存放每个数字与之前所有数字异或运算的结果。

其次，根据异或运算的性质，计算 `[i, j-1]` 之间数字异或运算的结果，只需计算 `vec[j-1] ^ vec[i-1]`。

同理，计算 `[j, k]` 之间数字异或运算的结果，只需计算 `vec[k] ^ vec[j-1]`。

#### C++ 实现

```cpp
class Solution {
public:
    int countTriplets(vector<int>& arr) {
        vector<int> vec = {0};
        for (int i = 0; i < arr.size(); ++i) {
            vec.push_back(vec.back() ^ arr[i]);
        }
        int res = 0;
        for (int i = 1; i < vec.size(); ++i) {
            for (int j = i+1; j < vec.size(); ++j) {
                for (int k = j; k < vec.size(); ++k) {
                    if ((vec[j-1] ^ vec[i-1]) == (vec[k] ^ vec[j-1])) {
                        ++res;
                    }
                }
            }
        }
        return res;
    }
};
```

## [1443. Minimum Time to Collect All Apples in a Tree](https://leetcode.com/contest/weekly-contest-188/problems/minimum-time-to-collect-all-apples-in-a-tree/) #Medium

### 题目解析

首先，使用 `map<int, vector<int>> m` 记录每个节点的所有子节点。

其次，使用深度优先搜索算法遍历所有的节点，返回到达某个节点及其之后节点所需要的时间步。其边界条件是遍历到叶子节点，如果叶子节点包含苹果，因为往返这个节点需要 `2` 个时间步，所以返回 `2`，否则返回 `0`。

然后，对于遍历到的节点，需要遍历其所有子节点，同时使用 `sum` 累加子节点返回的值，如果该节点不为根节点，而且其子节点之和不为 `0`（表明其子树包含苹果）或者节点本身包含苹果，那么必然需要往返该节点，`sum` 累加 `2`。

#### C++ 实现

```cpp
class Solution {
public:
    int minTime(int n, vector<vector<int>>& edges, vector<bool>& hasApple) {
        map<int, vector<int>> m;
        for (auto vi : edges) m[vi[0]].push_back(vi[1]);
        return func(0, m, hasApple);
    }
    int func(int idx, map<int, vector<int>> &m, vector<bool> &hasApple) {
        if (!m.count(idx)) {
            if (hasApple[idx]) return 2;
            else return 0;
        }
        int sum = 0;
        for (int i : m[idx]) sum += func(i, m, hasApple);
        if (idx != 0 && (sum != 0 || hasApple[idx])) sum += 2;
        return sum;
    }
};
```

## [1444. Number of Ways of Cutting a Pizza](https://leetcode.com/contest/weekly-contest-188/problems/number-of-ways-of-cutting-a-pizza/) #Hard

### 题目解析

参考：[[Java/C++] DP + PrefixSum in Matrix - Clean code](https://leetcode.com/problems/number-of-ways-of-cutting-a-pizza/discuss/623732/JavaC%2B%2B-DP-%2B-PrefixSum-in-Matrix-Clean-code)

放弃治疗系列，直接看大佬的解法吧。

#### C++ 实现

```cpp
class Solution {
public:
    int ways(vector<string>& pizza, int k) {
        int m = pizza.size(), n = pizza[0].size();
        vector<vector<vector<int>>> dp(k, vector(m, vector(n, -1)));
        vector<vector<int>> preSum(m+1, vector(n+1, 0));
        for (int r = m - 1; r >= 0; --r) {
            for (int c = n - 1; c >= 0; --c) {
                preSum[r][c] = preSum[r][c+1] + preSum[r+1][c] - preSum[r+1][c+1];
                preSum[r][c] += (pizza[r][c] == 'A');
            }
        }
        return dfs(m, n, k-1, 0, 0, dp, preSum);
    }
    int dfs(int m, int n, int k, int r, int c,
            vector<vector<vector<int>>> &dp, vector<vector<int>> &preSum) {
        if (preSum[r][c] == 0) return 0;
        if (k == 0) return 1;
        if (dp[k][r][c] != -1) return dp[k][r][c];
        int ans = 0, mod = 1e9 + 7;
        for (int nr = r + 1; nr < m; ++nr) {
            if (preSum[r][c] - preSum[nr][c] > 0) {
                ans = (ans + dfs(m, n, k-1, nr, c, dp, preSum)) % mod;
            }
        }
        for (int nc = c + 1; nc < n; ++nc) {
            if (preSum[r][c] - preSum[r][nc] > 0) {
                ans = (ans + dfs(m, n, k-1, r, nc, dp, preSum)) % mod;
            }
        }
        return dp[k][r][c] = ans;
    }
};
```
