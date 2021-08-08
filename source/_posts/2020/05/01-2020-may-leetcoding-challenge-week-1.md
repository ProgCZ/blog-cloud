---
title:   2020 May LeetCoding Challenge - Week 1
date:    2020-05-01 16:06:40
updated: 2020-05-07 16:08:30
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

P.S. 四月挑战因为错过了开头，不想从半路开始，所以干脆没做，现在五月挑战出现了，希望自己能坚持做完。

## May 1st: [First Bad Version](https://leetcode.com/explore/featured/card/may-leetcoding-challenge/534/week-1-may-1st-may-7th/3316/)

You are a product manager and currently leading a team to develop a new product. Unfortunately, the latest version of your product fails the quality check. Since each version is developed based on the previous version, all the versions after a bad version are also bad.

Suppose you have `n` versions `[1, 2, ..., n]` and you want to find out the first bad one, which causes all the following ones to be bad.

You are given an API `bool isBadVersion(version)` which will return whether `version` is bad. Implement a function to find the first bad version. You should minimize the number of calls to the API.

**Example:**

```
Given n = 5, and version = 4 is the first bad version.

call isBadVersion(3) -> false
call isBadVersion(5) -> true
call isBadVersion(4) -> true

Then 4 is the first bad version.
```

### 题目解析

二分查找算法就可以解决，注意 `beg` 和 `end` 两个边界值应该如何变化即可。

{% note info %}
二分查找算法可以参考这篇文章：[二分查找详解](https://labuladong.gitbook.io/algo/suan-fa-si-wei-xi-lie/er-fen-cha-zhao-xiang-jie)。
{% endnote %}

#### C++ 实现

```cpp
// The API isBadVersion is defined for you.
// bool isBadVersion(int version);

class Solution {
public:
    int firstBadVersion(int n) {
        return func(0, n);
    }
    int func(int beg, int end) {
        if (beg >= end) return beg;
        int mid = beg + (end - beg) / 2;
        if (isBadVersion(mid)) end = mid;
        else beg = mid + 1;
        return func(beg, end);
    }
};
```

## May 2nd: [Jewels and Stones](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/534/week-1-may-1st-may-7th/3317/)

You're given strings `J` representing the types of stones that are jewels, and `S` representing the stones you have. Each character in `S` is a type of stone you have. You want to know how many of the stones you have are also jewels.

The letters in `J` are guaranteed distinct, and all characters in `J` and `S` are letters. Letters are case sensitive, so `"a"` is considered a different type of stone from `"A"`.

**Example 1:**

```
Input: J = "aA", S = "aAAbbbb"
Output: 3
```

**Example 2:**

```
Input: J = "z", S = "ZZ"
Output: 0
```

**Note:**

- `S` and `J` will consist of letters and have length at most 50.

- The characters in `J` are distinct.

### 题目解析

侮辱智商，不解释了。

#### C++ 实现

```cpp
class Solution {
public:
    int numJewelsInStones(string J, string S) {
        array<bool, 52> arr = {};
        for (auto ch : J) {
            if (ch >= 'a' && ch <= 'z') {
                arr[ch-'a'] = true;
            } else if (ch >= 'A' && ch <= 'Z') {
                arr[ch-'A'+26] = true;
            }
        }
        int res = 0;
        for (auto ch : S) {
            if ((ch >= 'a' && ch <= 'z' && arr[ch-'a']) ||
                (ch >= 'A' && ch <= 'Z' && arr[ch-'A'+26])) {
                ++res;
            }
        }
        return res;
    }
};
```

## May 3rd: [Ransom Note](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/534/week-1-may-1st-may-7th/3318/)

Given an arbitrary ransom note string and another string containing letters from all the magazines, write a function that will return true if the ransom note can be constructed from the magazines; otherwise, it will return false.

Each letter in the magazine string can only be used once in your ransom note.

**Note:**

You may assume that both strings contain only lowercase letters.

```
canConstruct("a", "b") -> false
canConstruct("aa", "ab") -> false
canConstruct("aa", "aab") -> true
```

### 题目解析

使用 `map<char, int> m` 统计 `magazine` 中每个字符出现的个数，在遍历 `ransomNote` 的过程中消耗对应字符的个数，如果发现某个字符的个数为负，则说明无法用 `magazine` 中的字符构造 `ransomNote`，返回 `false` 即可。

#### C++ 实现

```cpp
class Solution {
public:
    bool canConstruct(string ransomNote, string magazine) {
        map<char, int> m;
        for (auto ch : magazine) ++m[ch];
        for (auto ch : ransomNote) --m[ch];
        for (auto p : m) {
            if (p.second < 0) return false;
        }
        return true;
    }
};
```

## May 4th: [Number Complement](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/534/week-1-may-1st-may-7th/3319/)

Given a positive integer, output its complement number. The complement strategy is to flip the bits of its binary representation.

**Example 1:**

```
Input: 5
Output: 2
Explanation: The binary representation of 5 is 101 (no leading zero bits), and its complement is 010. So you need to output 2.
```

**Example 2:**

```
Input: 1
Output: 0
Explanation: The binary representation of 1 is 1 (no leading zero bits), and its complement is 0. So you need to output 0.
```

**Note:**

- The given integer is guaranteed to fit within the range of a 32-bit signed integer.

- You could assume no leading zero bit in the integer's binary representation.

- This question is the same as 1009: <https://leetcode.com/problems/complement-of-base-10-integer/>

### 题目解析

因为需要忽略二进制形式中开头的 `0`，所以首先从末尾起遍历一遍 `num`，使用 `cnt` 记录最后一个 `1` 出现的位置，然后使用异或运算 `^` 反转末尾的 `cnt` 个数字即可。

#### C++ 实现

```cpp
class Solution {
public:
    int findComplement(int num) {
        int cnt = 0, tmp = 0x1;
        for (int i = 0; i < 32; ++i) {
            if (num & tmp) cnt = i;
            if (i < 31) tmp = tmp << 1;
        }
        tmp = 0x1;
        for (int i = 0; i < cnt+1; ++i) {
            num = num ^ tmp;
            if (i < 31) tmp = tmp << 1;
        }
        return num;
    }
};
```

## May 5th: [First Unique Character in a String](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/534/week-1-may-1st-may-7th/3320/)

Given a string, find the first non-repeating character in it and return it's index. If it doesn't exist, return -1.

**Examples:**

```
s = "leetcode",
return 0.

s = "loveleetcode",
return 2.
```

**Note:** You may assume the string contain only lowercase letters.

### 题目解析

首先，遍历 `s`，使用 `map<char, int> m` 记录 `s` 中每个字符的出现次数。

然后，遍历 `s`，找到出现次数为 `1` 的字符，返回其下标即可。

#### C++ 实现

```cpp
class Solution {
public:
    int firstUniqChar(string s) {
        map<char, int> m;
        for (auto ch : s) ++m[ch];
        for (int i = 0; i < s.size(); ++i) {
            if (m[s[i]] == 1) return i;
        }
        return -1;
    }
};
```

## May 6th: [Majority Element](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/534/week-1-may-1st-may-7th/3321/)

Given an array of size `n`, find the majority element. The majority element is the element that appears **more than** `n/2` times.

You may assume that the array is non-empty and the majority element always exist in the array.

**Example 1:**

```
Input: [3,2,3]
Output: 3
```

**Example 2:**

```
Input: [2,2,1,1,1,2,2]
Output: 2
```

### 题目解析

将 `nums` 进行排序，出现次数大于 `n/2` 的数字必然出现在下标为 `n/2` 的位置。

#### C++ 实现

```cpp
class Solution {
public:
    int majorityElement(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        return nums[nums.size()/2];
    }
};
```

## May 7th: [Cousins in Binary Tree](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/534/week-1-may-1st-may-7th/3322/)

In a binary tree, the root node is at depth `0`, and children of each depth `k` node are at depth `k+1`.

Two nodes of a binary tree are *cousins* if they have the same depth, but have **different parents**.

We are given the `root` of a binary tree with unique values, and the values `x` and `y` of two different nodes in the tree.

Return `true` if and only if the nodes corresponding to the values `x` and `y` are cousins.

**Example 1:**

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/05/00.png" style="zoom:80%"/>

```
Input: root = [1,2,3,4], x = 4, y = 3
Output: false
```

**Example 2:**

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/05/01.png" style="zoom:80%"/>

```
Input: root = [1,2,3,null,4,null,5], x = 5, y = 4
Output: true
```

**Example 3:**

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/05/02.png" style="zoom:80%"/>

```
Input: root = [1,2,3,null,4], x = 2, y = 3
Output: false
```

**Note:**

- The number of nodes in the tree will be between `2` and `100`.

- Each node has a unique integer value from `1` to `100`.

### 题目解析

首先，使用 `queue<TreeNode*>` 对二叉树进行**层级遍历**。

其次，对于每一层，**使用 `map<int, int> m` 记录节点的值与其在该层中的下标 `idx`，**即使遇到 `nullptr` 的话 `idx` 也会自增，只是不做记录而已。

然后，**如果 `x` 和 `y` 同时存在于 `m` 中，那么说明两者在同一层，**继而判断两者是否属于同一父节点：

- **如果两者在该层的下标相差不为 `1`，那么不可能属于同一父节点。**

- **如果两者在该层的下标相差为 `1`，但是两者下标中的较小者不是奇数，那么说明两者虽然相邻但属于不同父节点。**

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
    bool isCousins(TreeNode* root, int x, int y) {
        queue<TreeNode*> q;
        q.push(root);
        while (!q.empty()) {
            queue<TreeNode*> t;
            map<int, int> m;
            int idx = 1;
            while (!q.empty()) {
                auto node = q.front(); q.pop();
                if (node->left) {
                    t.push(node->left);
                    m[node->left->val] = idx;
                }
                ++idx;
                if (node->right) {
                    t.push(node->right);
                    m[node->right->val] = idx;
                }
                ++idx;
            }
            if (m.find(x) != m.end() && m.find(y) != m.end() &&
                (abs(m[x]-m[y]) != 1 || min(m[x],m[y]) % 2 != 1)) {
                return true;
            }
            q = t;
        }
        return false;
    }
};
```
