---
title:   LeetCode Problem 4 - Median of Two Sorted Arrays
date:    2021-03-03 08:22:15
updated: 2021-03-08 09:00:38
categories:
    - A03 - LeetCode
    - LeetCode Problems
tags:
    - LeetCode
    - CPP
    - Hash Table
    - Array
    - Binary Search
    - Divide and Conquer
---

## 题目

<https://leetcode.com/problems/median-of-two-sorted-arrays/>

### 大意

给定两个排序后的数组 `nums1` 和 `nums2`，返回这两个数组合并后的中位值。

<!-- more -->

## 解法一：暴力排序

合并两个数组之后进行排序，返回中位值。

### 复杂度分析

- 空间：`O(n)`

- 时间：`O((m+n)log(m+n))`

### C++ 实现

```cpp
class Solution {
public:
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size() + nums2.size();
        nums1.insert(nums1.end(), nums2.begin(), nums2.end());
        sort(nums1.begin(), nums1.end());
        return (nums1[(n-1)/2] + nums1[n/2]) / 2.0;
    }
};
```

## 解法二：二分查找

> 参考：<https://leetcode.com/problems/median-of-two-sorted-arrays/discuss/2471/Very-concise-O(log(min(MN)))-iterative-solution-with-detailed-explanation>

如果可以将两个数组各自切成左右两部分，即 `nums1` -> `nums1_left` 和 `nums1_right`，`nums2` -> `nums2_left` 和 `nums2_right`，然后将两个 `left` 合并，两个 `right` 合并，如果两者长度相等，且 `left` 中最大的数字都要比 `right` 中最小的数字要小，那么就能得到中位数 `(max(left)+min(right))/2`。

为了达成上述想法，需要在排序数组中找到切分的位置，自然引出二分查找。在使用二分查找的过程中，可以使用这样一个小技巧：

将数组 `nums` 的每个元素之间都插入 `*`，比如：

```
nums1: 1 3 4 7 11 -> * 1 * 3 * 4 * 7 * 11 *
nums2: 2 8 9 10   -> * 2 * 8 * 9 * 10 *
```

数组 `nums` 的长度 `n -> 2*n+1`，对应元素下标 `idx -> 2*idx`。

这样做的目的是，将 `nums` 转换为有奇数个元素的数组；这样做的好处是，对于新数组来说，需要切分的范围恒为奇数个元素，假定范围为 `[lo, hi]`（左右边界一定落在 `*` 上），那么切分的位置为 `c=(lo+hi)/2`，其左侧数字在原数组中的下标为 `(c-1)/2`，其右侧数字在原数组中的下标为 `c/2`；比如：

待补例子

### 复杂度分析

- 空间：`O(1)`

- 时间：`O(log(min(m,n)))`

### C++ 实现

```cpp
class Solution {
public:
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        int n1 = nums1.size();
        int n2 = nums2.size();
        if (n1 < n2) return findMedianSortedArrays(nums2, nums1);
        
        int lo = 0, hi = 2 * n2;
        while (lo <= hi) {
            int c2 = (lo + hi) / 2;
            int c1 = n1 + n2 - c2;
            
            int l1 = (c1 == 0) ? INT_MIN : nums1[(c1-1)/2];
            int l2 = (c2 == 0) ? INT_MIN : nums2[(c2-1)/2];
            int r1 = (c1 == n1*2) ? INT_MAX : nums1[c1/2];
            int r2 = (c2 == n2*2) ? INT_MAX : nums2[c2/2];
            
            if (l1 > r2) {
                lo = c2 + 1;
            } else if (l2 > r1) {
                hi = c2 - 1;
            } else {
                return (max(l1, l2) + min(r1, r2)) / 2.0;
            }
        }
        return 0;
    }
};
```
