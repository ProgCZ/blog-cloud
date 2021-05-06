---
title:   LeetCode Weekly Contest 189 (1450 - 1453)
date:    2020-05-17 14:53:16
updated: 2020-05-17 14:53:16
categories:
    - A03 - LeetCode
    - LeetCode Weekly Contest
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
---

LeetCode 周赛专题每周随缘更新，点击类别 [LeetCode Weekly Contest](/categories/LeetCode-Weekly-Contest/) 查看更多。

本次比赛通过 `3` 题，时间为 `0:48:25`，排名为 `2708/13036`。

<!-- more -->

## [1450. Number of Students Doing Homework at a Given Time](https://leetcode.com/contest/weekly-contest-189/problems/number-of-students-doing-homework-at-a-given-time/) #Easy

### 题目解析

侮辱智商，不解释了。

#### C++ 实现

```cpp
class Solution {
public:
    int busyStudent(vector<int>& startTime, vector<int>& endTime, int queryTime) {
        int n = startTime.size(), res = 0;
        for (int i = 0; i < n; ++i) {
            if (startTime[i] <= queryTime && endTime[i] >= queryTime) {
                ++res;
            }
        }
        return res;
    }
};
```

## [1451. Rearrange Words in a Sentence](https://leetcode.com/contest/weekly-contest-189/problems/rearrange-words-in-a-sentence) #Medium

### 题目解析

使用 `vector<pair<vector<int>, string>> vec` 存放分割后的子字符串，**其中 `vector<int>` 包含两个数字，第一个为字符串的长度，第二个为字符串的序号，**从而在之后的 `sort` 中按照字符串的长度排序，如果长度相等，则按照字符串的原顺序排序。

#### C++ 实现

```cpp
class Solution {
public:
    string arrangeWords(string text) {
        text[0] -= 'A' - 'a';
        text.push_back(' ');
        int pre = 0, cur = 0, cnt = 0;
        vector<pair<vector<int>, string>> vec;
        while ((cur = text.find(" ", pre)) != string::npos) {
            vec.push_back(make_pair(vector<int>{cur-pre, cnt++},
                                    text.substr(pre, cur-pre)));
            pre = cur+1;
        }
        sort(vec.begin(), vec.end());
        string res;
        for (auto p : vec) res += p.second + " ";
        res.pop_back();
        res[0] += 'A' - 'a';
        return res;
    }
};
```

## [1452. People Whose List of Favorite Companies Is Not a Subset of Another List](https://leetcode.com/contest/weekly-contest-189/problems/people-whose-list-of-favorite-companies-is-not-a-subset-of-another-list/) #Medium

### 题目解析

首先，**将每组公司从 `vector<string>` 重新组织为 `set<string>`，**从而方便后续查找。

其次，嵌套遍历，**其中 `b1` 用于标记 `vec[i]` 是否包含于其他任何组，`b2` 用于标记 `vec[i]` 是否包含于 `vec[j]`。**

#### C++ 实现

```cpp
class Solution {
public:
    vector<int> peopleIndexes(vector<vector<string>>& favoriteCompanies) {
        vector<set<string>> vec;
        for (auto vs : favoriteCompanies) {
            vec.push_back(set<string>(vs.begin(), vs.end()));
        }
        int n = vec.size();
        vector<int> res;
        for (int i = 0; i < n; ++i) {
            bool b1 = false;
            for (int j = 0; j < n; ++j) {
                if (vec[i].size() >= vec[j].size()) continue;
                bool b2 = true;
                for (auto s : vec[i]) {
                    if (vec[j].find(s) == vec[j].end()) {
                        b2 = false;
                        break;
                    }
                }
                if (b2) b1 = true;
            }
            if (!b1) res.push_back(i);
        }
        return res;
    }
};
```

## [1453. Maximum Number of Darts Inside of a Circular Dartboard](https://leetcode.com/contest/weekly-contest-189/problems/maximum-number-of-darts-inside-of-a-circular-dartboard/) #Hard

### 题目解析

参考：[[c++] O(n^2logn), angular sweep (with picture)](https://leetcode.com/problems/maximum-number-of-darts-inside-of-a-circular-dartboard/discuss/636416/c%2B%2B-O(n2logn)-angular-sweep-(with-picture))

又是放弃治疗系列，直接看大佬的解法吧。

#### C++ 实现

```cpp
class Solution {
public:
    int numPoints(vector<vector<int>>& points, int r) {
        int n = points.size();
        vector<vector<double>> dist(n, vector<double>(n));
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                dist[i][j] = dist[j][i] = sqrt((points[i][0] - points[j][0]) * (points[i][0] - points[j][0]) +
                                               (points[i][1] - points[j][1]) * (points[i][1] - points[j][1]));
            }
        }
        int res = 1;
        for (int i = 0; i < n; ++i) {
            vector<pair<double, bool>> angles;
            for (int j = 0; j < n; ++j) {
                if (j != i && dist[i][j] <= 2 * r) {
                    double A = atan2(points[j][1] - points[i][1], points[j][0] - points[i][0]);
                    double B = acos(dist[i][j] / (2.0 * r));
                    double alpha = A - B;
                    double beta = A + B;
                    angles.push_back(make_pair(alpha, false));
                    angles.push_back(make_pair(beta, true));
                }
            }
            sort(angles.begin(), angles.end());
            int cnt = 1;
            for (auto it = angles.begin(); it != angles.end(); ++it) {
                if ((*it).second == false) ++cnt;
                else --cnt;
                res = max(res, cnt);
            }
        }
        return res;
    }
};
```
