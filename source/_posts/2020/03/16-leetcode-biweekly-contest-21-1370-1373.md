---
title:   LeetCode Biweekly Contest 21 (1370 - 1373)
date:    2020-03-16 10:24:00
updated: 2020-03-16 10:24:00
categories:
    - A3 - LeetCode
    - B3 - LeetCode Biweekly Contest
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
    - String
---

LeetCode 双周赛专题每双周随缘更新，点击类别 [LeetCode Biweekly Contest](/categories/LeetCode-Biweekly-Contest/) 查看更多。

<!-- more -->

## [1370. Increasing Decreasing String](https://leetcode.com/contest/biweekly-contest-21/problems/increasing-decreasing-string/) #Easy

### 题目解析

首先，使用 `map<char, int> um` 记录每个字符出现的次数。

其次，因为 `map` 在插入过程中自动排序，所以从头到尾遍历可以得到字符的升序序列，同样从尾到头遍历可以得到字符的降序序列，不断循环上述步骤，直到用完所有字符即可。

#### C++ 实现

```cpp
class Solution {
public:
    string sortString(string s) {
        map<char, int> um;
        for (auto c : s) ++um[c];
        int cnt = 0, n = s.size();
        string res = "";
        while (cnt < n) {
            for (auto iter = um.begin(); iter != um.end(); ++iter) {
                if (iter->second > 0) {
                    res += iter->first;
                    --iter->second;
                    ++cnt;
                }
            }
            for (auto iter = um.rbegin(); iter != um.rend(); ++iter) {
                if (iter->second > 0) {
                    res += iter->first;
                    --iter->second;
                    ++cnt;
                }
            }
        }
        return res;
    }
};
```

## [1371. Find the Longest Substring Containing Vowels in Even Counts](https://leetcode.com/contest/biweekly-contest-21/problems/find-the-longest-substring-containing-vowels-in-even-counts/) #Medium

### 题目解析

首先，使用掩码 `mask`，其中的五位分别对应五个字符，位为 `0` 代表该字符出现次数为偶数，位为 `1` 代表该字符出现次数为奇数。那么，掩码 `mask` 可能出现的情况共有 `32` 种，使用 `iarr` 记录每种情况第一次出现的位置。

其次，遍历字符串 `s`，将掩码 `mask` 与每个字符对应的编码进行异或运算，计算当前的位置与该掩码第一次出现的位置之间子串的长度，比较最大值即可。

{% note info %}
需要明白的是，如果 `i` 和 `j` 两个位置具有相同的掩码 `mask`，那么 `[i + 1, j]` 之间的子串必然是满足题意的。
{% endnote %}

#### C++ 实现

```cpp
class Solution {
public:
    int findTheLongestSubstring(string s) {
        array<char, 26> carr;
        fill(begin(carr), end(carr), 0);
        carr['a'-'a'] = 1; carr['e'-'a'] = 2;
        carr['i'-'a'] = 4; carr['o'-'a'] = 8;
        carr['u'-'a'] = 16;
        array<int, 32> iarr;
        fill(begin(iarr), end(iarr), -1);
        int mask = 0, res = 0;
        for (int i = 0; i < s.size(); ++i) {
            mask ^= carr[s[i]-'a'];
            if (mask != 0 && iarr[mask] == -1) {
                iarr[mask] = i;
            }
            res = max(res, i-iarr[mask]);
        }
        return res;
    }
};
```

## [1372. Longest ZigZag Path in a Binary Tree](https://leetcode.com/contest/biweekly-contest-21/problems/longest-zigzag-path-in-a-binary-tree/) #Medium

### 题目解析

递归遍历树，使用 `is_left` 标记是否为左节点。

{% note info %}
需要注意的是，如果当前节点为其父节点的左节点，那么可以在之前深度 `depth` 的基础上遍历其右节点，也可以从 `0` 开始遍历其左节点。右节点亦然。
{% endnote %}

#### C++ 实现

```cpp
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
public:
    int longestZigZag(TreeNode* root) {
        int res = 0;
        helper1(root, false, 0, res);
        helper1(root, true, 0, res);
        return res;
    }
    void helper1(TreeNode *node, bool is_left, int depth, int &res) {
        if (!node) return;
        res = max(res, depth);
        if (is_left) {
            helper1(node->right, false, depth+1, res);
            helper1(node->left, false, 0, res);
        } else {
            helper1(node->left, true, depth+1, res);
            helper1(node->right, true, 0, res);
        }
    }
};
```

## [1373. Maximum Sum BST in Binary Tree](https://leetcode.com/contest/biweekly-contest-21/problems/maximum-sum-bst-in-binary-tree/) #Hard

### 题目解析

递归遍历树，使用 `array<int, 3>` 记录子树的和、最小值和最大值。

如果左子树的最大值小于当前节点的值，而且右子树的最小值大于当前节点的值，那么说明以当前节点为根节点的树为 BST，传递该树的和、最小值和最大值，否则传递 `{0, INT_MIN, INT_MAX}`。

#### C++ 实现

```cpp
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
public:
    int maxSumBST(TreeNode* root) {
        int res = 0;
        helper1(root, res);
        return res;
    }
    array<int, 3> helper1(TreeNode *node, int &res) {
        auto l = node->left ? helper1(node->left, res)
                            : array<int, 3>{0, node->val, INT_MIN};
        auto r = node->right ? helper1(node->right, res)
                             : array<int, 3>{0, INT_MAX, node->val};
        if (l[2] < node->val && node->val < r[1]) {
            res = max(res, node->val+l[0]+r[0]);
            return {node->val+l[0]+r[0], l[1], r[2]};
        }
        return {0, INT_MIN, INT_MAX};
    }
};
```
