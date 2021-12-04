---
title:   2020 August LeetCoding Challenge - Week 1
date:    2020-08-01 15:37:02
updated: 2020-08-08 11:31:37
categories:
    - A4 - LeetCode
    - B4 - LeetCoding Challenge
tags:
    - 数据结构与算法
    - LeetCode
    - CPP
    - Challenge
---

LeetCode 八月挑战专题每日随缘更新，点击类别 [2020 August LeetCoding Challenge](/categories/2020-August-LeetCoding-Challenge/) 查看更多。

<!-- more -->

## August 1st: [Detect Capital](https://leetcode.com/explore/challenge/card/august-leetcoding-challenge/549/week-1-august-1st-august-7th/3409/)

Given a word, you need to judge whether the usage of capitals in it is right or not.

We define the usage of capitals in a word to be right when one of the following cases holds:

- All letters in this word are capitals, like "USA".

- All letters in this word are not capitals, like "leetcode".

- Only the first letter in this word is capital, like "Google".

Otherwise, we define that this word doesn't use capitals in a right way.

**Example 1:**

```
Input: "USA"
Output: True
```

**Example 2:**

```
Input: "FlaG"
Output: False
```

**Note:** The input will be a non-empty word consisting of uppercase and lowercase latin letters.

### 题目解析

不管字符串 `word` 的写法是否正确，我都可以列举出其三种正确的写法，放入集合 `s` 中，判断最初的 `word` 是否存在于 `s` 中即可。

#### C++ 实现

```cpp
class Solution {
public:
    bool detectCapitalUse(string word) {
        unordered_set<string> s;
        string word_cp = word;
        for (auto &ch : word_cp) {
            ch = tolower(ch);
        }
        s.insert(word_cp);
        word_cp[0] = toupper(word_cp[0]);
        s.insert(word_cp);
        for (auto &ch : word_cp) {
            ch = toupper(ch);
        }
        s.insert(word_cp);
        return s.find(word) != s.end();
    }
};
```

## August 2nd: [Design HashSet](https://leetcode.com/explore/challenge/card/august-leetcoding-challenge/549/week-1-august-1st-august-7th/3410/)

Design a HashSet without using any built-in hash table libraries.

To be specific, your design should include these functions:

- `add(value)`: Insert a value into the HashSet.

- `contains(value)`: Return whether the value exists in the HashSet or not.

- `remove(value)`: Remove a value in the HashSet. If the value does not exist in the HashSet, do nothing.

**Example:**

```
MyHashSet hashSet = new MyHashSet();
hashSet.add(1);
hashSet.add(2);
hashSet.contains(1);    // returns true
hashSet.contains(3);    // returns false (not found)
hashSet.add(2);
hashSet.contains(2);    // returns true
hashSet.remove(2);
hashSet.contains(2);    // returns false (already removed)
```

**Note:**

- All values will be in the range of `[0, 1000000]`.

- The number of operations will be in the range of `[1, 10000]`.

- Please do not use the built-in HashSet library.

### 题目解析

采用哈希函数 + 单向链表，将 `key` 取模后在链表中添加、删除和查找。

P.S. 空间换时间，当然可以把 `mod` 直接赋值为 `1000001`。

#### C++ 实现

```cpp
class MyHashSet {
public:
    /** Initialize your data structure here. */
    MyHashSet() : mod(1000) {
        v.resize(mod);
    }
    
    void add(int key) {
        v[key%mod].push_front(key);
    }
    
    void remove(int key) {
        v[key%mod].remove(key);
    }
    
    /** Returns true if this set contains the specified element */
    bool contains(int key) {
        for (auto &val : v[key%mod]) {
            if (val == key) {
                return true;
            }
        }
        return false;
    }
private:
    int mod;
    vector<forward_list<int>> v;
};

/**
 * Your MyHashSet object will be instantiated and called as such:
 * MyHashSet* obj = new MyHashSet();
 * obj->add(key);
 * obj->remove(key);
 * bool param_3 = obj->contains(key);
 */
```

## August 3rd: [Valid Palindrome](https://leetcode.com/explore/challenge/card/august-leetcoding-challenge/549/week-1-august-1st-august-7th/3411/)

Given a string, determine if it is a palindrome, considering only alphanumeric characters and ignoring cases.

**Note:** For the purpose of this problem, we define empty string as valid palindrome.

**Example 1:**

```
Input: "A man, a plan, a canal: Panama"
Output: true
```

**Example 2:**

```
Input: "race a car"
Output: false
```

**Constraints:**

- `s` consists only of printable ASCII characters.

### 题目解析

使用首尾指针 `beg` 和 `end` 进行比较，如果不是数字或字母，直接跳过。

#### C++ 实现

```cpp
class Solution {
public:
    bool isPalindrome(string s) {
        int beg = 0, end = s.size()-1;
        while (beg < end) {
            if (!isalnum(s[beg])) {
                ++beg;
                continue;
            }
            if (!isalnum(s[end])) {
                --end;
                continue;
            }
            if (tolower(s[beg]) != tolower(s[end])) {
                return false;
            }
            ++beg;
            --end;
        }
        return true;
    }
};
```

## August 4th: [Power of Four](https://leetcode.com/explore/challenge/card/august-leetcoding-challenge/549/week-1-august-1st-august-7th/3412/)

Given an integer (signed 32 bits), write a function to check whether it is a power of 4.

**Example 1:**

```
Input: 16
Output: true
```

**Example 2:**

```
Input: 5
Output: false
```

### 题目解析

每次累乘 4，实际上都是将二进制形式左移 2 位，循环判断即可。

#### C++ 实现

```cpp
class Solution {
public:
    bool isPowerOfFour(int num) {
        if (num < 0) return false;
        for (int i = 0; i < 32; i += 2) {
            if (num == (1 << i)) {
                return true;
            }
        }
        return false;
    }
};
```

## August 5th: [Add and Search Word - Data structure design](https://leetcode.com/explore/challenge/card/august-leetcoding-challenge/549/week-1-august-1st-august-7th/3413/)

Design a data structure that supports the following two operations:

```
void addWord(word)
bool search(word)
```

search(word) can search a literal word or a regular expression string containing only letters `a-z` or `.`. A `.` means it can represent any one letter.

**Example:**

```
addWord("bad")
addWord("dad")
addWord("mad")
search("pad") -> false
search("bad") -> true
search(".ad") -> true
search("b..") -> true
```

**Note:**

You may assume that all words are consist of lowercase letters `a-z`.

### 题目解析

使用 `um` 建立从字符串长度至字符串数组的映射，从而在查询的时候降低时间复杂度。妙啊。

#### C++ 实现

```cpp
class WordDictionary {
public:
    /** Initialize your data structure here. */
    WordDictionary() {
        
    }
    
    /** Adds a word into the data structure. */
    void addWord(string word) {
        um[word.size()].push_back(word);
    }
    
    /** Returns if the word is in the data structure. A word could contain the dot character '.' to represent any one letter. */
    bool search(string word) {
        for (auto str : um[word.size()]) {
            if (is_match(str, word)) {
                return true;
            }
        }
        return false;
    }
    
    bool is_match(string word1, string word2) {
        for (int i = 0; i < word1.size(); ++i) {
            if (word1[i] == '.' || word2[i] == '.') continue;
            if (word1[i] != word2[i]) return false;
        }
        return true;
    }
private:
    unordered_map<int, vector<string>> um;
};

/**
 * Your WordDictionary object will be instantiated and called as such:
 * WordDictionary* obj = new WordDictionary();
 * obj->addWord(word);
 * bool param_2 = obj->search(word);
 */
```

## August 6th: [Find All Duplicates in an Array](https://leetcode.com/explore/challenge/card/august-leetcoding-challenge/549/week-1-august-1st-august-7th/3414/)

Given an array of integers, `1 ≤ a[i] ≤ n` (`n` = size of array), some elements appear **twice** and others appear **once**.

Find all the elements that appear **twice** in this array.

Could you do it without extra space and in `O(n)` runtime?

**Example:**

```
Input:
[4,3,2,7,8,2,3,1]

Output:
[2,3]
```

### 题目解析

没啥好说的，直接看代码吧。

#### C++ 实现

```cpp
class Solution {
public:
    vector<int> findDuplicates(vector<int>& nums) {
        unordered_map<int, int> um;
        for (auto num : nums) {
            ++um[num];
        }
        vector<int> res;
        for (auto t : um) {
            if (t.second == 2) {
                res.push_back(t.first);
            }
        }
        return res;
    }
};
```

## August 7th: [Vertical Order Traversal of a Binary Tree](https://leetcode.com/explore/challenge/card/august-leetcoding-challenge/549/week-1-august-1st-august-7th/3415/)

Given a binary tree, return the vertical order traversal of its nodes values.

For each node at position `(X, Y)`, its left and right children respectively will be at positions `(X-1, Y-1)` and `(X+1, Y-1)`.

Running a vertical line from `X = -infinity` to `X = +infinity`, whenever the vertical line touches some nodes, we report the values of the nodes in order from top to bottom (decreasing `Y` coordinates).

If two nodes have the same position, then the value of the node that is reported first is the value that is smaller.

Return an list of non-empty reports in order of `X` coordinate.  Every report will have a list of values of nodes.

**Example 1:**

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/08/06.png" style="zoom:100%"/>

```
Input: [3,9,20,null,null,15,7]
Output: [[9],[3,15],[20],[7]]
Explanation:
Without loss of generality, we can assume the root node is at position (0, 0):
Then, the node with value 9 occurs at position (-1, -1);
The nodes with values 3 and 15 occur at positions (0, 0) and (0, -2);
The node with value 20 occurs at position (1, -1);
The node with value 7 occurs at position (2, -2).
```

**Example 2:**

<img src="https://cdn.jsdelivr.net/gh/ProgCZ/image-cloud-a@master/2020/08/07.png" style="zoom:50%"/>

```
Input: [1,2,3,4,5,6,7]
Output: [[4],[2],[1,5,6],[3],[7]]
Explanation:
The node with value 5 and the node with value 6 have the same position according to the given scheme.
However, in the report "[1,5,6]", the node value of 5 comes first since 5 is smaller than 6.
```

**Note:**

1. The tree will have between `1` and `1000` nodes.

2. Each node's value will be between `0` and `1000`.

### 题目解析

首先，核心在于这个声明：

```cpp
map<int, map<int, vector<int>, greater<int>>> m;
```

**第一个 `int` 代表节点的 `x` 坐标，第二个 `int` 代表节点的 `y` 坐标，`vector<int>` 存放节点的值；而且，`x` 坐标按照默认升序排列，`y` 坐标按照指定降序排列，适应题目要求。**

其次，使用函数 `func` 遍历树，存放至对应的 `vector<int>` 中。

最后，遍历 `m`，将 `x` 坐标相同的点合并到 `v` 中，组织为 `res` 即可。

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
    vector<vector<int>> verticalTraversal(TreeNode* root) {
        map<int, map<int, vector<int>, greater<int>>> m;
        func(root, 0, 0, m);
        vector<vector<int>> res;
        for (auto imp : m) {
            vector<int> v;
            for (auto ivp : imp.second) {
                sort(ivp.second.begin(), ivp.second.end());
                v.insert(v.end(), ivp.second.begin(), ivp.second.end());
            }
            res.push_back(v);
        }
        return res;
    }
    void func(TreeNode *node, int x, int y,
              map<int, map<int, vector<int>, greater<int>>> &m) {
        if (!node) return;
        m[x][y].push_back(node->val);
        func(node->left, x-1, y-1, m);
        func(node->right, x+1, y-1, m);
    }
};
```
