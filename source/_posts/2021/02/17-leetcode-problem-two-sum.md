---
title:   LeetCode Problem 1 - Two Sum
date:    2021-02-17 23:48:43
updated: 2021-02-19 23:49:15
categories:
    - A03 - LeetCode
    - LeetCode Problems
tags:
    - LeetCode
    - CPP
    - Array
    - Hash Table
---

## 题目

<https://leetcode.com/problems/two-sum/>

### 大意

给定数组 `nums` 和数字 `target`，要求在 `nums` 中找到两个数字，和为 `target`，返回这两个数字的下标。

保证有且只有一个解，而且同一个数字不能用两次。

<!-- more -->

## 解法一：两层循环，暴力破解

两层循环，遍历所有可能的数字组合，找到则返回下标。

### 复杂度分析

- 空间：`O(1)`

- 时间：`O(n^2)`

### C++ 实现

```cpp
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        int n = nums.size();
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < i; ++j) {
                if (nums[i] + nums[j] == target) {
                    return {i, j};
                }
            }
        }
        return {};
    }
};
```

## 解法二：借助 `hash_map`，用空间换时间

既可以使用两次循环：

- 第一次循环完成「记录」：借助 `hash_map`，建立数字 `target-nums[i]` 和下标 `i` 之间的映射。

- 第二次循环进行「查询」：如果数字 `nums[i]` 存在于 `hash_map` 中，而且不是同一数字（下标不同），说明可以「配对」，则返回该数字下标和 `hash_map` 中记录的另一数字下标。

也可以使用单次循环：

- 单次循环合并「记录」和「查询」：如果数字 `nums[i]` 存在于 `hash_map` 中，说明可以「配对」，则返回该数字下标和 `hash_map` 中记录的另一数字下标，否则建立数字 `target-nums[i]` 和下标 `i` 之间的映射。

> 单次循环参考：<https://leetcode.com/problems/two-sum/discuss/13/Accepted-C++-O(n)-Solution/263>

### 复杂度分析

- 空间：`O(n)`（不太确定）

- 时间：`O(n)`

    - `hash_map` 插入、查询、删除的操作，时间复杂度均为 `O(1)`。

### C++ 实现

两次循环：

```cpp
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        int n = nums.size();
        unordered_map<int, int> um = {};
        for (int i = 0; i < n; ++i) {
            um[target-nums[i]] = i;
        }
        for (int i = 0; i < n; ++i) {
            if (um.find(nums[i]) != um.end() &&
                um[nums[i]] != i) {
                return {um[nums[i]], i};
            }
        }
        return {};
    }
};
```

单次循环：

```cpp
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        int n = nums.size();
        unordered_map<int, int> um;
        for (int i = 0; i < n; ++i) {
            if (um.find(nums[i]) != um.end()) {
                return {um[nums[i]], i};
            }
            um[target-nums[i]] = i;
        }
        return {};
    }
};
```
