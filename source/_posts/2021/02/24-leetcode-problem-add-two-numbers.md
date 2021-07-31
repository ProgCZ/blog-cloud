---
title:   LeetCode Problem 2 - Add Two Numbers
date:    2021-02-24 23:54:42
updated: 2021-02-26 08:18:02
categories:
    - A3 - LeetCode
    - B1 - LeetCode Problems
tags:
    - LeetCode
    - CPP
    - Linked List
    - Math
    - Recursion
---

## 题目

<https://leetcode.com/problems/add-two-numbers/>

### 大意

将两个数字的每一位，逆序地拆成两个链表 `l1` 和 `l2`，计算这两个数字的和，结果以同样顺序的链表表示。

<!-- more -->

## 解法一：递归

递归遍历两个输入链表，对应节点相加，`%10` 的值存入输出链表的对应节点，`/10` 的值存入输出链表的下一节点。

边界条件：两个输入链表的对应节点都为空指针。

{% note info %}
在边界条件下，需要根据下一节点的值是否为 0 而决定是否抛弃该下一节点。为了实现这一点，同时保持代码的 `neat` 性，传入递归函数的输出链表的对应节点，需要自带下一节点，这就是 C++ 实现中 `new ListNode(0, new ListNode(0))` 的由来。
{% endnote %}

### 复杂度分析

- 空间：`O(n)`

- 时间：`O(n)`

### C++ 实现

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
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        ListNode* root = new ListNode(0, new ListNode(0));
        helper(l1, l2, root);
        return root->next;
    }
    void helper(ListNode* l1, ListNode* l2, ListNode* node) {
        if (!l1 && !l2) {
            node->next = node->next->val ? node->next : nullptr;
            return;
        };
        node = node->next;
        int sum = node->val +
            (l1 ? l1->val : 0) + (l2 ? l2->val : 0);
        node->val = sum % 10;
        node->next = new ListNode(sum/10);
        l1 = l1 ? l1->next : nullptr;
        l2 = l2 ? l2->next : nullptr;
        return helper(l1, l2, node);
    }
};
```

## 解法二：循环

思路基本上与[解法一](#解法一：递归)保持一致，只是将递归形式改为循环形式，同时写法上更加 neat。

> 参考：<https://leetcode.com/problems/add-two-numbers/discuss/997/c++-Sharing-my-11-line-c++-solution-can-someone-make-it-even-more-concise>

### 复杂度分析

- 空间：`O(n)`

- 时间：`O(n)`

### C++ 实现

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
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        ListNode root(0), *node = &root;
        int extra = 0;
        while (l1 || l2 || extra) {
            int sum = extra + 
                (l1 ? l1->val : 0) + (l2 ? l2->val : 0);
            extra = sum/10;
            node->next = new ListNode(sum%10);
            node = node->next;
            l1 = l1 ? l1->next : l1;
            l2 = l2 ? l2->next : l2;
        }
        return root.next;
    }
};
```
