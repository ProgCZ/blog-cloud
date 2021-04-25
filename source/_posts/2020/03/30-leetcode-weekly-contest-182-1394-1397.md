---
title:   LeetCode Weekly Contest 182 (1394 - 1397)
date:    2020-03-30 10:24:00
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

## [1394. Find Lucky Integer in an Array](https://leetcode.com/contest/weekly-contest-182/problems/find-lucky-integer-in-an-array/) #Easy

### 题目解析

首先，遍历 `arr`，使用 `m` 记录每个数字出现的次数，因为 `map` 的有序特性，所以数字自然从小到大进行排序。

其次，逆向遍历 `m`，寻找数字与其出现次数相等的情况，直接返回即可。

#### C++ 实现

```cpp
class Solution {
public:
    int findLucky(vector<int>& arr) {
        map<int, int> m;
        for (const int &i : arr) ++m[i];
        for (auto iter = m.crbegin(); iter != m.crend(); ++iter) {
            if (iter->first == iter->second) return iter->first;
        }
        return -1;
    }
};
```

## [1395. Count Number of Teams](https://leetcode.com/contest/weekly-contest-182/problems/count-number-of-teams/) #Medium

### 题目解析

首先，遍历 `rating`，使用 `cnt` 记录每个数字之后比它大的数字个数 `cnt[i][0]` 和比它小的数字个数 `cnt[i][1]`。

其次，遍历 `rating`，`rating[i]` 作为队伍的第一个数字，`rating[j]` 作为队伍的第二个数字：

- 如果前者比后者小，则说明为升序序列，`res` 累加 `rating[j]` 之后比它大的数字个数。

- 如果前者比后者大，则说明为降序序列，`res` 累加 `rating[j]` 之后比它小的数字个数。

#### C++ 实现

```cpp
class Solution {
public:
    int numTeams(vector<int>& rating) {
        int n = rating.size();
        vector<vector<int>> cnt(n, vector<int>(2, 0));
        for (int i = 0; i < n; ++i) {
            for (int j = i+1; j < n; ++j) {
                if (rating[i] < rating[j]) ++cnt[i][0];
                else if (rating[i] > rating[j]) ++cnt[i][1];
            }
        }
        int res = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i+1; j < n; ++j) {
                if (rating[i] < rating[j]) res += cnt[j][0];
                else if (rating[i] > rating[j]) res += cnt[j][1];
            }
        }
        return res;
    }
};
```

## [1396. Design Underground System](https://leetcode.com/contest/weekly-contest-182/problems/design-underground-system/) #Medium

### 题目解析

没啥好说的，理清题目逻辑之后用 `unordered_map` 来记录信息即可。

#### C++ 实现

```cpp
class UndergroundSystem {
public:
    UndergroundSystem() { }
    
    void checkIn(int id, string stationName, int t) {
        um2[id] = {stationName, t};
    }
    
    void checkOut(int id, string stationName, int t) {
        um1[um2[id].first+stationName].first += 1;
        um1[um2[id].first+stationName].second += t - um2[id].second;
    }
    
    double getAverageTime(string startStation, string endStation) {
        return um1[startStation+endStation].second /
            static_cast<double>(um1[startStation+endStation].first);
    }
private:
    unordered_map<string, pair<int, long long>> um1;
    unordered_map<int, pair<string, int>> um2;
};

/**
 * Your UndergroundSystem object will be instantiated and called as such:
 * UndergroundSystem* obj = new UndergroundSystem();
 * obj->checkIn(id,stationName,t);
 * obj->checkOut(id,stationName,t);
 * double param_3 = obj->getAverageTime(startStation,endStation);
 */
```

## [1397. Find All Good Strings](https://leetcode.com/contest/weekly-contest-182/problems/find-all-good-strings/) #Hard

### 题目解析

> 参考：[[Java/C++] Memoization DFS & KMP - with Picture - Clean code](https://leetcode.com/problems/find-all-good-strings/discuss/555591/JavaC%2B%2B-Memoization-DFS-and-KMP-with-Picture-Clean-code)

说实话，我觉得这不是我目前能够理解的解法（涉及 KMP 算法），单纯放一下代码吧。

#### C++ 实现

```cpp
class Solution {
public:
    int findGoodStrings(int n, string s1, string s2, string evil) {
        vector<vector<vector<vector<int>>>> memo = vector(n+1, vector(evil.size()+1, vector(2, vector(2, -1)))); 
        return dfs(0, 0, true, true,
            n, s1, s2, evil, computeLPS(evil), memo);
    }
    int dfs(int i, int matchEvilLen, bool useBoundS1, bool useBoundS2,
            int n, string& s1, string& s2, string& evil, const vector<int>& lps, vector<vector<vector<vector<int>>>>& memo) {
        if (matchEvilLen == evil.size()) return 0;
        if (i == n) return 1;
        if (memo[i][matchEvilLen][useBoundS1][useBoundS2] != -1) return memo[i][matchEvilLen][useBoundS1][useBoundS2];
        char from = useBoundS1 ? s1[i] : 'a';
        char to = useBoundS2 ? s2[i] : 'z';
        int res = 0;
        long long mod = 1e9+7;
        for (char c = from; c <= to; c++) {
            int j = matchEvilLen;
            while (j > 0 && evil[j] != c) j = lps[j - 1];
            if (c == evil[j]) j++;
            res += dfs(i + 1, j, useBoundS1 && (c == from), useBoundS2 && (c == to),
                    n, s1, s2, evil, lps, memo);
            res %= mod;
        }
        return memo[i][matchEvilLen][useBoundS1][useBoundS2] = res;
    }
    vector<int> computeLPS(const string& str) {
        int n = str.size();
        vector<int> lps = vector<int>(n);
        for (int i = 1, j = 0; i < n; i++) {
            while (j > 0 && str[i] != str[j]) j = lps[j - 1];
            if (str[i] == str[j]) lps[i] = ++j;
        }
        return lps;
    }
};
```
