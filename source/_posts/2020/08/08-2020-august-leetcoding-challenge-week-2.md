---
title:   2020 August LeetCoding Challenge - Week 2
date:    2020-08-08 23:36:56
updated: 2020-08-16 10:42:26
categories:
    - A3 - LeetCode
    - B4 - LeetCoding Challenge
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
    - Challenge
---

LeetCode 八月挑战专题每日随缘更新，点击类别 [2020 August LeetCoding Challenge](/categories/2020-August-LeetCoding-Challenge/) 查看更多。

<!-- more -->

## August 8th: [Path Sum III](https://leetcode.com/explore/challenge/card/august-leetcoding-challenge/550/week-2-august-8th-august-14th/3417/)

You are given a binary tree in which each node contains an integer value.

Find the number of paths that sum to a given value.

The path does not need to start or end at the root or a leaf, but it must go downwards (traveling only from parent nodes to child nodes).

The tree has no more than 1,000 nodes and the values are in the range -1,000,000 to 1,000,000.

**Example:**

```
root = [10,5,-3,3,2,null,11,3,-2,null,1], sum = 8

      10
     /  \
    5   -3
   / \    \
  3   2   11
 / \   \
3  -2   1

Return 3. The paths that sum to 8 are:

1.  5 -> 3
2.  5 -> 2 -> 1
3. -3 -> 11
```

### 题目解析

使用函数 `func` 对树进行深度优先搜索，对以 `node` 为起点且满足题目要求的路径进行计数。

`pathSum(root->left, sum)` 和 `pathSum(root->right, sum)` 则是分别给左右节点一次「重新开始」的机会。

#### C++ 实现

```cpp
class Solution {
public:
    int pathSum(TreeNode* root, int sum) {
        if(!root) return 0;
        return func(root, sum) + pathSum(root->left, sum) + pathSum(root->right, sum);
    }
    int func(TreeNode *node,int sum){
        if(!node) return 0;
        int ans = node->val==sum ? 1 : 0;
        return ans + func(node->left, sum-node->val) + func(node->right, sum-node->val);
    }
};
```

---

终究还是没能在工作日坚持下来，这个系列终止吧。
