---
title:   2020 May LeetCoding Challenge - Week 2
date:    2020-05-08 16:07:28
updated: 2020-05-14 17:26:13
categories:
    - A3 - LeetCode
    - B4 - LeetCoding Challenge
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
    - Challenge
---

LeetCode 五月挑战专题每日随缘更新，点击类别 [2020 May LeetCoding Challenge](/categories/2020-May-LeetCoding-Challenge/) 查看更多。

<!-- more -->

## May 8th: [Check If It Is a Straight Line](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/535/week-2-may-8th-may-14th/3323/)

You are given an array `coordinates`, `coordinates[i] = [x, y]`, where `[x, y]` represents the coordinate of a point. Check if these points make a straight line in the XY plane.

**Example 1:**

```
Input: coordinates = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,7]]
Output: true
```

**Example 2:**

```
Input: coordinates = [[1,1],[2,2],[3,4],[4,5],[5,6],[7,7]]
Output: false
```

**Constraints:**

- `2 <= coordinates.length <= 1000`

- `coordinates[i].length == 2`

- `-10^4 <= coordinates[i][0], coordinates[i][1] <= 10^4`

- `coordinates` contains no duplicate point.

### 题目解析

遍历所有点，每两点 `[x1, y1]` 和 `[x2, y2]` 之间计算斜率 `k`，判断其是否在遍历过程中保持不变。

实际上就是首先计算开头两点的斜率，然后判断后面的斜率是否与其相等。

{% note warning %}
需要注意的是，如果 `x1` 和 `x2` 相等，则无法通过除法计算斜率 `k`，此时将 `k` 赋值为 `DBL_MAX`，用来表示无穷大的斜率。
{% endnote %}

#### C++ 实现

```cpp
class Solution {
public:
    bool checkStraightLine(vector<vector<int>>& coordinates) {
        int n = coordinates.size();
        double k = DBL_MIN;
        for (int i = 1; i < n; ++i) {
            double x1 = coordinates[i-1][0];
            double y1 = coordinates[i-1][1];
            double x2 = coordinates[i][0];
            double y2 = coordinates[i][1];
            if (k == DBL_MIN) {
                if (x1 == x2) k = DBL_MAX;
                else k = (y2 - y1) / (x2 - x1);
            }
            if ((x1 == x2 && k != DBL_MAX) ||
                (x1 != x2 && (y2 - y1) / (x2 - x1) != k)) {
                return false;
            }
        }
        return true;
    }
};
```

## May 9th: [Valid Perfect Square](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/535/week-2-may-8th-may-14th/3324/)

Given a positive integer `num`, write a function which returns True if `num` is a perfect square else False.

**Note:** Do not use any built-in library function such as `sqrt`.

**Example 1:**

```
Input: 16
Output: true
```

**Example 2:**

```
Input: 14
Output: false
```

### 题目解析

侮辱智商，不解释了。

#### C++ 实现

```cpp
class Solution {
public:
    bool isPerfectSquare(int num) {
        double t = 1;
        while (t * t < num) ++t;
        return t * t == num;
    }
};
```

## May 10th: [Find the Town Judge](https://leetcode.com/explore/featured/card/may-leetcoding-challenge/535/week-2-may-8th-may-14th/3325/)

In a town, there are `N` people labelled from `1` to `N`. There is a rumor that one of these people is secretly the town judge.

If the town judge exists, then:

1. The town judge trusts nobody.

2. Everybody (except for the town judge) trusts the town judge.

3. There is exactly one person that satisfies properties 1 and 2.

You are given `trust`, an array of pairs `trust[i] = [a, b]` representing that the person labelled `a` trusts the person labelled `b`.

If the town judge exists and can be identified, return the label of the town judge. Otherwise, return `-1`.

**Example 1:**

```
Input: N = 2, trust = [[1,2]]
Output: 2
```

**Example 2:**

```
Input: N = 3, trust = [[1,3],[2,3]]
Output: 3
```

**Example 3:**

```
Input: N = 3, trust = [[1,3],[2,3],[3,1]]
Output: -1
```

**Example 4:**

```
Input: N = 3, trust = [[1,2],[2,3]]
Output: -1
```

**Example 5:**

```
Input: N = 4, trust = [[1,3],[1,4],[2,3],[2,4],[4,3]]
Output: 3
```

**Note:**

- `1 <= N <= 1000`

- `trust.length <= 10000`

- `trust[i]` are all different

- `trust[i][0] != trust[i][1]`

- `1 <= trust[i][0], trust[i][1] <= N`

### 题目解析

首先，使用 `map<int, set<int>> m` 存放某个人的受信任列表，即信任某个人的所有人。

其次，遍历 `m`，**如果信任这个人 `p.first` 的所有人 `p.second` 共有 `N-1` 个，那么说明 `p.first` 受其他所有人的信任。**

然后，对于这个人 `p.first`，遍历其他人 `p.second`，**如果 `p.first` 不存在于任何人的受信任列表 `m[t]` 中，那么说明 `p.first` 不信任其他所有人。**

#### C++ 实现

```cpp
class Solution {
public:
    int findJudge(int N, vector<vector<int>>& trust) {
        if (N == 1) return 1;
        map<int, set<int>> m;
        for (auto vi : trust) m[vi[1]].insert(vi[0]);
        for (auto p : m) {
            if (p.second.size() == N-1) {
                bool b = true;
                for (auto t : p.second) {
                    if (m[t].count(p.first)) {
                        b = false;
                        break;
                    }
                }
                if (b) return p.first;
            }
        }
        return -1;
    }
};
```

## May 11th: [Flood Fill](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/535/week-2-may-8th-may-14th/3326/)

An `image` is represented by a 2-D array of integers, each integer representing the pixel value of the image (from 0 to 65535).

Given a coordinate `(sr, sc)` representing the starting pixel (row and column) of the flood fill, and a pixel value `newColor`, "flood fill" the image.

To perform a "flood fill", consider the starting pixel, plus any pixels connected 4-directionally to the starting pixel of the same color as the starting pixel, plus any pixels connected 4-directionally to those pixels (also with the same color as the starting pixel), and so on. Replace the color of all of the aforementioned pixels with the newColor.

At the end, return the modified image.

**Example 1:**

```
Input: 
image = [[1,1,1],[1,1,0],[1,0,1]]
sr = 1, sc = 1, newColor = 2
Output: [[2,2,2],[2,2,0],[2,0,1]]
Explanation: 
From the center of the image (with position (sr, sc) = (1, 1)), all pixels connected
by a path of the same color as the starting pixel are colored with the new color.
Note the bottom corner is not colored 2, because it is not 4-directionally connected
to the starting pixel.
```

**Note:**

- The length of `image` and `image[0]` will be in the range `[1, 50]`.

- The given starting pixel will satisfy `0 <= sr < image.length` and `0 <= sc < image[0].length`.

- The value of each color in `image[i][j]` and `newColor` will be an integer in `[0, 65535]`.

### 题目解析

典型的深度优先搜索算法就可以解决。

#### C++ 实现

```cpp
class Solution {
public:
    vector<vector<int>> floodFill(vector<vector<int>>& image, int sr, int sc, int newColor) {
        int m = image.size(), n = image[0].size();
        vector<vector<bool>> visited(m, vector<bool>(n, false));
        func(image, visited, sr, sc, image[sr][sc], newColor);
        return image;
    }
    void func(vector<vector<int>> &image, vector<vector<bool>> &visited,
              int x, int y, int startColor, int newColor) {
        int m = image.size(), n = image[0].size();
        if (x < 0 || x >= m || y < 0 || y >= n ||
            visited[x][y] || image[x][y] != startColor) return;
        visited[x][y] = true;
        image[x][y] = newColor;
        func(image, visited, x-1, y, startColor, newColor);
        func(image, visited, x+1, y, startColor, newColor);
        func(image, visited, x, y-1, startColor, newColor);
        func(image, visited, x, y+1, startColor, newColor);
    }
};
```

## May 12th: [Single Element in a Sorted Array](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/535/week-2-may-8th-may-14th/3327/)

You are given a sorted array consisting of only integers where every element appears exactly twice, except for one element which appears exactly once. Find this single element that appears only once.

**Example 1:**

```
Input: [1,1,2,3,3,4,4,8,8]
Output: 2
```

**Example 2:**

```
Input: [3,3,7,7,10,11,11]
Output: 10
```

**Note:** Your solution should run in O(log n) time and O(1) space.

### 题目解析

{% note info %}
需要明白的是，异或运算具备两个重要性质：

- 对于数字 `num` 来说，`num ^ num == 0`。

- 对于数字 `num` 来说，`num ^ 0 == num`。
{% endnote %}

对于出现两次的数字来说，遍历过程中的异或运算必然使其自身抵消，最终剩下出现一次的数字作为计算结果。

#### C++ 实现

```cpp
class Solution {
public:
    int singleNonDuplicate(vector<int>& nums) {
        int res = 0;
        for (auto num : nums) res ^= num;
        return res;
    }
};
```

## May 13th: [Remove K Digits](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/535/week-2-may-8th-may-14th/3328/)

Given a non-negative integer `num` represented as a string, remove `k` digits from the number so that the new number is the smallest possible.

**Note:**

- The length of `num` is less than 10002 and will be ≥ `k`.

- The given `num` does not contain any leading zero.

**Example 1:**

```
Input: num = "1432219", k = 3
Output: "1219"
Explanation: Remove the three digits 4, 3, and 2 to form the new number 1219 which is the smallest.
```

**Example 2:**

```
Input: num = "10200", k = 1
Output: "200"
Explanation: Remove the leading 1 and the number is 200. Note that the output must not contain leading zeroes.
```

**Example 3:**

```
Input: num = "10", k = 2
Output: "0"
Explanation: Remove all the digits from the number and it is left with nothing which is 0.
```

### 题目解析

参考：[[LeetCode] 402. Remove K Digits 去掉 K 位数字 - 刷尽天下](https://www.cnblogs.com/grandyang/p/5883736.html)

将 `num` 中的字符逐个添加到 `res` 中，为了保证高位上的数字尽可能地小，在添加过程中需要去除 `res` 中比当前字符大的字符，从而保证 `res` 是非递减的。

#### C++ 实现

```cpp
class Solution {
public:
    string removeKdigits(string num, int k) {
        string res = "";
        int n = num.size(), keep = n - k;
        for (char c : num) {
            while (k && res.size() && res.back() > c) {
                res.pop_back();
                --k;
            }
            res.push_back(c);
        }
        res.resize(keep);
        while (!res.empty() && res[0] == '0') {
            res.erase(res.begin());
        }
        return res.empty() ? "0" : res;
    }
};
```

## May 14th: [Implement Trie (Prefix Tree)](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/535/week-2-may-8th-may-14th/3329/)

Implement a trie with `insert`, `search`, and `startsWith` methods.

**Example:**

```
Trie trie = new Trie();

trie.insert("apple");
trie.search("apple");   // returns true
trie.search("app");     // returns false
trie.startsWith("app"); // returns true
trie.insert("app");
trie.search("app");     // returns true
```

**Note:**

- You may assume that all inputs are consist of lowercase letters `a-z`.

- All inputs are guaranteed to be non-empty strings.

### 题目解析

对于 `insert` 和 `search` 方法，可以使用 `set<string> s` 的 `insert` 和 `count` 方法实现。

对于 `startsWith` 方法，因为 `set` 自动对元素（此处为字符串）进行排序，所以可以遍历找到**第一个大于等于 `prefix` 的字符串**，如果该字符串是以 `prefix` 开头的，那么返回 `true`，否则返回 `false`。

#### C++ 实现

```cpp
class Trie {
private:
    set<string> s;
public:
    /** Initialize your data structure here. */
    Trie() { }

    /** Inserts a word into the trie. */
    void insert(string word) {
        s.insert(word);
    }

    /** Returns if the word is in the trie. */
    bool search(string word) {
        return s.count(word);
    }

    /** Returns if there is any word in the trie that starts with the given prefix. */
    bool startsWith(string prefix) {
        auto iter = s.begin();
        while (iter != s.end() && *iter < prefix) ++iter;
        return iter != s.end() && prefix == iter->substr(0, prefix.size());
    }
};

/**
 * Your Trie object will be instantiated and called as such:
 * Trie* obj = new Trie();
 * obj->insert(word);
 * bool param_2 = obj->search(word);
 * bool param_3 = obj->startsWith(prefix);
 */
```
