---
title:   2020 May LeetCoding Challenge - Week 4
date:    2020-05-22 19:55:57
updated: 2020-05-28 19:24:36
categories:
    - A03 - LeetCode
    - 2020 LeetCoding Challenge
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
    - Challenge
---

LeetCode 五月挑战专题每日随缘更新，点击类别 [2020 May LeetCoding Challenge](/categories/2020-May-LeetCoding-Challenge/) 查看更多。

<!-- more -->

## May 22nd: [Sort Characters By Frequency](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/537/week-4-may-22nd-may-28th/3337/)

Given a string, sort it in decreasing order based on the frequency of characters.

**Example 1:**

```
Input:
"tree"

Output:
"eert"

Explanation:
'e' appears twice while 'r' and 't' both appear once.
So 'e' must appear before both 'r' and 't'. Therefore "eetr" is also a valid answer.
```

**Example 2:**

```
Input:
"cccaaa"

Output:
"cccaaa"

Explanation:
Both 'c' and 'a' appear three times, so "aaaccc" is also a valid answer.
Note that "cacaca" is incorrect, as the same characters must be together.
```

**Example 3:**

```
Input:
"Aabb"

Output:
"bbAa"

Explanation:
"bbaA" is also a valid answer, but "Aabb" is incorrect.
Note that 'A' and 'a' are treated as two different characters.
```

### 题目解析

使用 `vector<pair<int, char>> vec(256)` 保存字符串 `s` 中**每个字符出现的次数**及**字符本身**。从大到小进行排序之后，重新拼接成新的字符串 `res` 即可。

#### C++ 实现

```cpp
class Solution {
public:
    string frequencySort(string s) {
        vector<pair<int, char>> vec(256);
        for (auto ch : s) {
            if (vec[ch].first++ == 0) {
                vec[ch].second = ch;
            }
        }
        sort(vec.rbegin(), vec.rend());
        string res = "";
        for (auto p : vec) {
            res += string(p.first, p.second);
        }
        return res;
    }
};
```

## May 23rd: [Interval List Intersections](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/537/week-4-may-22nd-may-28th/3338/)

Given two lists of **closed** intervals, each list of intervals is pairwise disjoint and in sorted order.

Return the intersection of these two interval lists.

*(Formally, a closed interval `[a, b]` (with `a <= b`) denotes the set of real numbers `x` with `a <= x <= b`. The intersection of two closed intervals is a set of real numbers that is either empty, or can be represented as a closed interval. For example, the intersection of [1, 3] and [2, 4] is [2, 3].)*

**Example 1:**

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/05/05.png" style="zoom:80%"/>

```
Input: A = [[0,2],[5,10],[13,23],[24,25]], B = [[1,5],[8,12],[15,24],[25,26]]
Output: [[1,2],[5,5],[8,10],[15,23],[24,24],[25,25]]
Reminder: The inputs and the desired output are lists of Interval objects, and not arrays or lists.
```

**Note:**

- `0 <= A.length < 1000`

- `0 <= B.length < 1000`

- `0 <= A[i].start, A[i].end, B[i].start, B[i].end < 10^9`

### 题目解析

因为 `A` 和 `B` 的数据量都不大，所以可以嵌套遍历。在遍历过程中：

- **如果 `a` 的右界小于 `b` 的左界，说明两者不相交，而且因为 `B` 有序，所以 `b` 之后的区间也不可能与 `a` 相交，跳出小循环。**

- **如果 `a` 的左界大于 `b` 的右界，说明两者不相交，进入下一次小循环。**

如果两者相交，那么两者**左界的最大值和右界的最小值之间就是相交的区间。**

#### C++ 实现

```cpp
class Solution {
public:
    vector<vector<int>> intervalIntersection(vector<vector<int>>& A, vector<vector<int>>& B) {
        vector<vector<int>> res;
        for (auto a : A) {
            for (auto b : B) {
                if (a[1] < b[0]) break;
                if (a[0] > b[1]) continue;
                res.push_back({max(a[0], b[0]), min(a[1], b[1])});
            }
        }
        return res;
    }
};
```

## May 24th: [Construct Binary Search Tree from Preorder Traversal](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/537/week-4-may-22nd-may-28th/3339/)

Return the root node of a binary **search** tree that matches the given `preorder` traversal.

*(Recall that a binary search tree is a binary tree where for every node, any descendant of `node.left` has a value `< node.val`, and any descendant of `node.right` has a value `> node.val`. Also recall that a preorder traversal displays the value of the `node` first, then traverses `node.left`, then traverses `node.right`.)*

It's guaranteed that for the given test cases there is always possible to find a binary search tree with the given requirements.

**Example 1:**

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/05/09.png" style="zoom:80%"/>

```
Input: [8,5,1,7,10,12]
Output: [8,5,10,1,7,null,12]
```

**Constraints:**

- `1 <= preorder.length <= 100`

- `1 <= preorder[i] <= 10^8`

- The values of `preorder` are distinct.

### 题目解析

**利用 `func` 函数将 `preorder` 的 `[beg, end]` 区间分割为根节点、左子树和右子树。**具体地：

- 对于根节点，因为 `preorder` 是前序遍历，所以**根节点必然是 `preorder[beg]`。**

- 对于左子树和右子树，在 `preorder` 的 `[beg+1, end]` 区间内遍历寻找第一个大于 `preorder[beg]` 的数字，其下标为 `idx`，那么**左子树必然是 `preorder[beg+1, idx-1]`，右子树必然是 `preorder[idx, end]`。**

#### C++ 实现

```cpp
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    TreeNode* bstFromPreorder(vector<int>& preorder) {
        return func(preorder, 0, preorder.size()-1);
    }
    TreeNode* func(vector<int> &preorder, int beg, int end) {
        if (beg > end) return nullptr;
        int idx = beg + 1;
        while (idx <= end && preorder[idx] < preorder[beg]) ++idx;
        TreeNode *node = new TreeNode(preorder[beg]);
        node->left = func(preorder, beg+1, idx-1);
        node->right = func(preorder, idx, end);
        return node;
    }
};
```

## May 25th: [Uncrossed Lines](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/537/week-4-may-22nd-may-28th/3340/)

We write the integers of `A` and `B` (in the order they are given) on two separate horizontal lines.

Now, we may draw connecting lines: a straight line connecting two numbers `A[i]` and `B[j]` such that:

- `A[i] == B[j]`;

- The line we draw does not intersect any other connecting (non-horizontal) line.

Note that a connecting lines cannot intersect even at the endpoints: each number can only belong to one connecting line.

Return the maximum number of connecting lines we can draw in this way.

**Example 1:**

```
Input: A = [1,4,2], B = [1,2,4]
Output: 2
Explanation: We can draw 2 uncrossed lines as in the diagram.
We cannot draw 3 uncrossed lines, because the line from A[1]=4 to B[2]=4 will intersect the line from A[2]=2 to B[1]=2.
```

**Example 2:**

```
Input: A = [2,5,1,2,5], B = [10,5,2,1,5,2]
Output: 3
```

**Example 3:**

```
Input: A = [1,3,7,1,7,5], B = [1,9,2,5,1]
Output: 2
```

**Note:**

- `1 <= A.length <= 500`

- `1 <= B.length <= 500`

- `1 <= A[i], B[i] <= 2000`

### 题目解析

参考：[C++ DP with explanation](https://leetcode.com/problems/uncrossed-lines/discuss/650947/C%2B%2B-DP-with-explanation)

P.S. 嗨，看着动态规划的代码感觉还挺好理解的，自己写就写不出来。

#### C++ 实现

```cpp
class Solution {
public:
    int maxUncrossedLines(vector<int>& A, vector<int>& B) {
        int m = A.size(), n = B.size();
        vector<vector<int>> dp(m+1, vector<int>(n+1));
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (A[i] == B[j]) dp[i+1][j+1] = 1 + dp[i][j];
                else dp[i+1][j+1] = max(dp[i][j+1], dp[i+1][j]);
            }
        }
        return dp[m][n];
    }
};
```

## May 26th: [Contiguous Array](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/537/week-4-may-22nd-may-28th/3341/)

Given a binary array, find the maximum length of a contiguous subarray with equal number of 0 and 1.

**Example 1:**

```
Input: [0,1]
Output: 2
Explanation: [0, 1] is the longest contiguous subarray with equal number of 0 and 1.
```

**Example 2:**

```
Input: [0,1,0]
Output: 2
Explanation: [0, 1] (or [1, 0]) is a longest contiguous subarray with equal number of 0 and 1.
```

**Note:** The length of the given binary array will not exceed 50,000.

### 题目解析

参考：[[LeetCode] 525. Contiguous Array 相连的数组 - 刷尽天下](https://www.cnblogs.com/grandyang/p/6529857.html)

遍历 `nums` 中的数字 `num`，如果为 `1` 则累加 `1` 至 `sum`，如果为 `0` 则累加 `-1` 至 `sum`。

使用 `map<int, int> m` 记录首次出现某个 `sum` 的下标，如果之后再次出现该 `sum`，说明两者之间的子数组满足题目要求，寻找其长度的最大值即可。

#### C++ 实现

```cpp
class Solution {
public:
    int findMaxLength(vector<int>& nums) {
        int n = nums.size(), sum = 0, res = 0;
        map<int, int> m = {{0, -1}};
        for (int i = 0; i < n; ++i) {
            sum += nums[i] ? 1 : -1;
            if (m.count(sum)) {
                res = max(res, i-m[sum]);
            } else {
                m[sum] = i;
            }
        }
        return res;
    }
};
```

## May 27th: [Possible Bipartition](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/537/week-4-may-22nd-may-28th/3342/)

Given a set of `N` people (numbered `1, 2, ..., N`), we would like to split everyone into two groups of **any** size.

Each person may dislike some other people, and they should not go into the same group.

Formally, if `dislikes[i] = [a, b]`, it means it is not allowed to put the people numbered `a` and `b` into the same group.

Return `true` if and only if it is possible to split everyone into two groups in this way.

**Example 1:**

```
Input: N = 4, dislikes = [[1,2],[1,3],[2,4]]
Output: true
Explanation: group1 [1,4], group2 [2,3]
```

**Example 2:**

```
Input: N = 3, dislikes = [[1,2],[1,3],[2,3]]
Output: false
```

**Example 3:**

```
Input: N = 5, dislikes = [[1,2],[2,3],[3,4],[4,5],[1,5]]
Output: false
```

**Note:**

- `1 <= N <= 2000`

- `0 <= dislikes.length <= 10000`

- `1 <= dislikes[i][j] <= N`

- `dislikes[i][0] < dislikes[i][1]`

- There does not exist `i != j` for which `dislikes[i] == dislikes[j]`.

### 题目解析

参考：[[LeetCode] 886. Possible Bipartition 可能的二分图 - 刷尽天下](https://www.cnblogs.com/grandyang/p/10317141.html)

放弃治疗，直接看大佬的解法吧。

#### C++ 实现

```cpp
class Solution {
public:
    bool possibleBipartition(int N, vector<vector<int>>& dislikes) {
        vector<vector<int>> g(N+1, vector<int>(N+1));
        for (auto dislike : dislikes) {
            g[dislike[0]][dislike[1]] = 1;
            g[dislike[1]][dislike[0]] = 1;
        }
        vector<int> colors(N+1);
        for (int i = 1; i <= N; ++i) {
            if (colors[i] == 0 && !func(g, i, 1, colors)) return false;
        }
        return true;
    }
    bool func(vector<vector<int>>& g, int cur, int color, vector<int>& colors) {
        colors[cur] = color;
        for (int i = 0; i < g.size(); ++i) {
            if (g[cur][i] == 1) {
                if (colors[i] == color) return false;
                if (colors[i] == 0 && !func(g, i, -color, colors)) return false;
            }
        }
        return true;
    }
};
```

## May 28th: [Counting Bits](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/537/week-4-may-22nd-may-28th/3343/)

Given a non negative integer number **num**. For every numbers **i** in the range **0 ≤ i ≤ num** calculate the number of 1's in their binary representation and return them as an array.

**Example 1:**

```
Input: 2
Output: [0,1,1]
```

**Example 2:**

```
Input: 5
Output: [0,1,1,2,1,2]
```

### 题目解析

充分利用之前的结果：计算 `i` 中 `1` 的个数，那么只需要知道 `i>>1` 中 `1` 的个数（即 `res[i>>1]`）和 `i` 的最后一位是否为 `1`（即 `i&0x1`），相加即可。

#### C++ 实现

```cpp
class Solution {
public:
    vector<int> countBits(int num) {
        vector<int> res = {0};
        for (int i = 1; i <= num; ++i) {
            res.push_back(res[i>>1]+(i&0x1));
        }
        return res;
    }
};
```
