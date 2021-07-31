---
title:   2020 May LeetCoding Challenge - Week 3
date:    2020-05-15 16:23:22
updated: 2020-05-21 16:24:11
categories:
    - A3 - LeetCode
    - B4 - 2020 LeetCoding Challenge
tags:
    - Data Structure and Algorithm
    - LeetCode
    - CPP
    - Challenge
---

LeetCode 五月挑战专题每日随缘更新，点击类别 [2020 May LeetCoding Challenge](/categories/2020-May-LeetCoding-Challenge/) 查看更多。

<!-- more -->

## May 15th: [Maximum Sum Circular Subarray](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/536/week-3-may-15th-may-21st/3330/)

Given a **circular array C** of integers represented by `A`, find the maximum possible sum of a non-empty subarray of **C**.

Here, a *circular array* means the end of the array connects to the beginning of the array. (Formally, `C[i] = A[i]` when `0 <= i < A.length`, and `C[i+A.length] = C[i]` when `i >= 0`.)

Also, a subarray may only include each element of the fixed buffer `A` at most once. (Formally, for a subarray `C[i], C[i+1], ..., C[j]`, there does not exist `i <= k1, k2 <= j` with `k1 % A.length = k2 % A.length`.)

**Example 1:**

```
Input: [1,-2,3,-2]
Output: 3
Explanation: Subarray [3] has maximum sum 3
```

**Example 2:**

```
Input: [5,-3,5]
Output: 10
Explanation: Subarray [5,5] has maximum sum 5 + 5 = 10
```

**Example 3:**

```
Input: [3,-1,2,-1]
Output: 4
Explanation: Subarray [2,-1,3] has maximum sum 2 + (-1) + 3 = 4
```

**Example 4:**

```
Input: [3,-2,2,-3]
Output: 3
Explanation: Subarray [3] and [3,-2,2] both have maximum sum 3
```

**Example 5:**

```
Input: [-2,-3,-1]
Output: -1
Explanation: Subarray [-1] has maximum sum -1
```

**Note:**

- `-30000 <= A[i] <= 30000`

- `1 <= A.length <= 30000`

### 题目解析

参考：[[LeetCode] 918. Maximum Sum Circular Subarray 环形子数组的最大和 - 刷尽天下](https://www.cnblogs.com/grandyang/p/11716314.html)

考虑到环形数组，子数组的和实际上包含两种情况：

- **一种是正常的，即 `A` 的某一子数组。**

  对于这种情况，可以这样处理：在遍历过程中，**`curMx = max(curMx+num, num);` 语句表示 `curMx` 要么延续之前的子数组，要么放弃之前的子数组，**即是否重新组织子数组，然后**使用 `mx = max(mx, curMx);` 语句寻找子数组和的最大值。**

- **另一种是两段的，即 `A` 的开头一段和结束一段组合而成的某一子数组。**

  对于这种情况，可以这样处理：仿照第一种情况的方法，**寻找子数组和的最小值 `mn`，使用 `A` 的总和 `sum` 减去 `mn` 就可以得到子数组和的最大值。**

最后，上述两种情况取较大值即可。

另外，如果 `sum` 与 `mn` 相等，说明 `A` 中全为负数，结果应该是 `A` 中最大的负数，此时直接返回 `mx` 即可。

#### C++ 实现

```cpp
class Solution {
public:
    int maxSubarraySumCircular(vector<int>& A) {
        int sum = 0, mn = INT_MAX, mx = INT_MIN;
        int curMn = 0, curMx = 0;
        for (int num : A) {
            curMn = min(curMn+num, num);
            mn = min(mn, curMn);
            curMx = max(curMx+num, num);
            mx = max(mx, curMx);
            sum += num;
        }
        return (sum == mn) ? mx : max(mx, sum-mn);
    }
};
```

## May 16th: [Odd Even Linked List](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/536/week-3-may-15th-may-21st/3331/)

Given a singly linked list, group all odd nodes together followed by the even nodes. Please note here we are talking about the node number and not the value in the nodes.

You should try to do it in place. The program should run in O(1) space complexity and O(nodes) time complexity.

**Example 1:**

```
Input: 1->2->3->4->5->NULL
Output: 1->3->5->2->4->NULL
```

**Example 2:**

```
Input: 2->1->3->5->6->4->7->NULL
Output: 2->3->6->7->1->5->4->NULL
```

**Note:**

- The relative order inside both the even and odd groups should remain as it was in the input.

- The first node is considered odd, the second node even and so on ...

### 题目解析

参考：[[LeetCode] Odd Even Linked List 奇偶链表 - 刷尽天下](https://www.cnblogs.com/grandyang/p/5138936.html)

其实比着代码画个图就能明白了。

#### C++ 实现

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */
class Solution {
public:
    ListNode* oddEvenList(ListNode* head) {
        if (!head || !head->next) return head;
        ListNode *pre = head, *cur = head->next;
        while (cur && cur->next) {
            ListNode *tmp = pre->next;
            pre->next = cur->next;
            cur->next = cur->next->next;
            pre->next->next = tmp;
            pre = pre->next;
            cur = cur->next;
        }
        return head;
    }
};
```

## May 17th: [Find All Anagrams in a String](https://leetcode.com/explore/featured/card/may-leetcoding-challenge/536/week-3-may-15th-may-21st/3332/)

Given a string **s** and a **non-empty** string **p**, find all the start indices of **p**'s anagrams in **s**.

Strings consists of lowercase English letters only and the length of both strings **s** and **p** will not be larger than 20,100.

The order of output does not matter.

**Example 1:**

```
Input:
s: "cbaebabacd" p: "abc"

Output:
[0, 6]

Explanation:
The substring with start index = 0 is "cba", which is an anagram of "abc".
The substring with start index = 6 is "bac", which is an anagram of "abc".
```

**Example 2:**

```
Input:
s: "abab" p: "ab"

Output:
[0, 1, 2]

Explanation:
The substring with start index = 0 is "ab", which is an anagram of "ab".
The substring with start index = 1 is "ba", which is an anagram of "ab".
The substring with start index = 2 is "ab", which is an anagram of "ab".
```

### 题目解析

**使用 `array<int, 256>` 的 `arr1` 和 `arr2` 分别记录 `s` 的滑动窗口中和 `p` 中字符出现的次数，**通过比较 `arr1` 和 `arr2` 是否相等，就可以知道滑动窗口中的字符串是否为 `p` 的变型。

P.S. 一开始还使用 `multiset<char>` 做记录，然后就超时了。

#### C++ 实现

```cpp
class Solution {
public:
    vector<int> findAnagrams(string s, string p) {
        int n1 = s.size(), n2 = p.size();
        if (n1 < n2) return {};
        vector<int> res;
        array<int, 256> arr1{}, arr2{};
        for (int i = 0; i < n2; ++i) {
            ++arr1[s[i]];
            ++arr2[p[i]];
        }
        if (arr1 == arr2) res.push_back(0);
        for (int i = n2; i < n1; ++i) {
            ++arr1[s[i]];
            --arr1[s[i-n2]];
            if (arr1 == arr2) {
                res.push_back(i-n2+1);
            }
        }
        return res;
    }
};
```

## May 18th: [Permutation in String](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/536/week-3-may-15th-may-21st/3333/)

Given two strings **s1** and **s2**, write a function to return true if **s2** contains the permutation of **s1**. In other words, one of the first string's permutations is the **substring** of the second string.

**Example 1:**

```
Input: s1 = "ab" s2 = "eidbaooo"
Output: True
Explanation: s2 contains one permutation of s1 ("ba").
```

**Example 2:**

```
Input: s1= "ab" s2 = "eidboaoo"
Output: False
```

**Note:**

- The input strings only contain lower case letters.

- The length of both given strings is in range [1, 10,000].

### 题目解析

梅开二度，这不就是昨天的题嘛，不解释了。

#### C++ 实现

```cpp
class Solution {
public:
    bool checkInclusion(string s1, string s2) {
        int n1 = s1.size(), n2 = s2.size();
        if (n1 > n2) return false;
        array<int, 256> arr1{}, arr2{};
        for (int i = 0; i < n1; ++i) {
            ++arr1[s1[i]];
            ++arr2[s2[i]];
        }
        if (arr1 == arr2) return true;
        for (int i = n1; i < n2; ++i) {
            ++arr2[s2[i]];
            --arr2[s2[i-n1]];
            if (arr1 == arr2) return true;
        }
        return false;
    }
};
```

## May 19th: [Online Stock Span](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/536/week-3-may-15th-may-21st/3334/)

Write a class `StockSpanner` which collects daily price quotes for some stock, and returns the *span* of that stock's price for the current day.

The span of the stock's price today is defined as the maximum number of consecutive days (starting from today and going backwards) for which the price of the stock was less than or equal to today's price.

For example, if the price of a stock over the next 7 days were `[100, 80, 60, 70, 60, 75, 85]`, then the stock spans would be `[1, 1, 1, 2, 1, 4, 6]`.

**Example 1:**

```
Input: ["StockSpanner","next","next","next","next","next","next","next"], [[],[100],[80],[60],[70],[60],[75],[85]]
Output: [null,1,1,1,2,1,4,6]
Explanation:
First, S = StockSpanner() is initialized. Then:
S.next(100) is called and returns 1,
S.next(80) is called and returns 1,
S.next(60) is called and returns 1,
S.next(70) is called and returns 2,
S.next(60) is called and returns 1,
S.next(75) is called and returns 4,
S.next(85) is called and returns 6.

Note that (for example) S.next(75) returned 4, because the last 4 prices
(including today's price of 75) were less than or equal to today's price.
```

**Note:**

- Calls to `StockSpanner.next(int price)` will have `1 <= price <= 10^5`.

- There will be at most `10000` calls to `StockSpanner.next` per test case.

- There will be at most `150000` calls to `StockSpanner.next` across all test cases.

- The total time limit for this problem has been reduced by 75% for C++, and 50% for all other languages.

### 题目解析

参考：[[LeetCode] 901. Online Stock Span 股票价格跨度 - 刷尽天下](https://www.cnblogs.com/grandyang/p/11029306.html)

使用 `stack<pair<int, int>> st` 中的 `pair<int, int>` 存放当前股价和之前股价不比其高的连续天数。

每次调用 `next` 方法，循环遍历堆顶元素，如果其股价不比当前股价 `price` 高，则累加其连续天数至 `cnt`，直到其股价比当前股价 `price` 高。

结束遍历后，将当前股价 `price` 和之前股价不比其高的连续天数 `cnt` 添加至 `st` 的堆顶，返回 `cnt` 即可。

#### C++ 实现

```cpp
class StockSpanner {
public:
    StockSpanner() { }

    int next(int price) {
        int cnt = 1;
        while (!st.empty() && st.top().first <= price) {
            cnt += st.top().second; st.pop();
        }
        st.push({price, cnt});
        return cnt;
    }
private:
    stack<pair<int, int>> st;
};

/**
 * Your StockSpanner object will be instantiated and called as such:
 * StockSpanner* obj = new StockSpanner();
 * int param_1 = obj->next(price);
 */
```

## May 20th: [Kth Smallest Element in a BST](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/536/week-3-may-15th-may-21st/3335/)

Given a binary search tree, write a function `kthSmallest` to find the **k**th smallest element in it.

**Note:**

You may assume k is always valid, 1 ≤ k ≤ BST's total elements.

**Example 1:**

```
Input: root = [3,1,4,null,2], k = 1
   3
  / \
 1   4
  \
   2
Output: 1
```

**Example 2:**

```
Input: root = [5,3,6,2,4,null,null,1], k = 3
       5
      / \
     3   6
    / \
   2   4
  /
 1
Output: 3
```

### 题目解析

{% note info %}
众所周知，对二叉搜索树 BST 进行**中序遍历**，其结果即为从小到大排序的序列。
{% endnote %}

对二叉搜索树 BST 进行中序遍历的过程中，累减 `k` 直至 `k` 变为 `0`，返回节点的值即可。

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
    int kthSmallest(TreeNode* root, int k) {
        return func(root, k);
    }
    int func(TreeNode *node, int &k) {
        if (node->left) {
            int t = func(node->left, k);
            if (t != INT_MIN) return t;
        }
        if (--k == 0) return node->val;
        if (node->right) {
            int t = func(node->right, k);
            if (t != INT_MIN) return t;
        }
        return INT_MIN;
    }
};
```

## May 21st: [Count Square Submatrices with All Ones](https://leetcode.com/explore/challenge/card/may-leetcoding-challenge/536/week-3-may-15th-may-21st/3336/)

Given a `m * n` matrix of ones and zeros, return how many **square** submatrices have all ones.

**Example 1:**

```
Input: matrix =
[
  [0,1,1,1],
  [1,1,1,1],
  [0,1,1,1]
]
Output: 15
Explanation:
There are 10 squares of side 1.
There are 4 squares of side 2.
There is  1 square of side 3.
Total number of squares = 10 + 4 + 1 = 15.
```

**Example 2:**

```
Input: matrix =
[
  [1,0,1],
  [1,1,0],
  [1,1,0]
]
Output: 7
Explanation:
There are 6 squares of side 1.
There is 1 square of side 2.
Total number of squares = 6 + 1 = 7.
```

**Constraints:**

- `1 <= matrix.length <= 300`

- `1 <= matrix[0].length <= 300`

- `0 <= matrix[i][j] <= 1`

### 题目解析

P.S. 印象中碰到过这道题，那次没做出来，看了别人的解法之后，这次就记着了。

使用 `vec` 记录**以当前位置 `[i][j]` 为右下角的全 `1` 矩阵的最大尺寸**，也就是**以当前位置 `[i][j]` 为右下角的全 `1` 矩阵的个数**。

如果当前位置在 `matrix` 中的值 `matrix[i-1][j-1]` 为 `1`，那么可以**通过左上 `vec[i-1][j-1]`、左侧 `vec[i][j-1]` 和上方 `vec[i-1][j]` 中的最小值加 `1` 得到 `vec[i][j]`。**

{% note info %}
需要注意的是，为了在动态规划算法中使用统一的递推公式，一般将矩阵扩增一行和一列，所以 `vec[i][j]` 对应的是 `matrix[i-1][j-1]`。
{% endnote %}

最后，在遍历过程中，使用 `res` 累加 `vec[i][j]` 即可。

#### C++ 实现

```cpp
class Solution {
public:
    int countSquares(vector<vector<int>>& matrix) {
        int m = matrix.size(), n = matrix[0].size();
        int res = 0;
        vector<vector<int>> vec(m+1, vector<int>(n+1, 0));
        for (int i = 1; i <= m; ++i) {
            for (int j = 1; j <= n; ++j) {
                if (matrix[i-1][j-1] == 1) {
                    vec[i][j] = min(vec[i-1][j-1],
                                    min(vec[i][j-1], vec[i-1][j])) + 1;
                }
                res += vec[i][j];
            }
        }
        return res;
    }
};
```
