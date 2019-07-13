---
title: Object对象原型污染
date: 2019-07-13 16:48:37
tags: [ javascript ]
description: 近期收到github提示安全风险
categories:
- web前端
---

### 事件

七月2日， Snyk报告了一个lodash潜在的安全风险，该风险可能导致用户代码被用以执行有危险的脚本。

### 缘由

据报告，lodash的defaultsDeep方法可能会被欺骗导致Object对象原型链被污染

### 原理

原理代码

```js
const mergeFn = require('lodash').defaultsDeep;
const payload = '{ "constructor": {"prototype": { "a0": true }} }';

function check() {
    mergeFn({}, JSON.parse(payload));
    if (({})['a0'] === true) {
        console.log(`Vulnerable to Prototype Pollution via ${payload}`);
    }
}

check();
```

### 原理讲解

很明显的可以看出，该方法是利用了lodash.defaultsDeep 深拷贝未过滤危险对象成员constructor来达到污染原型链的目的。

使用JavaScript作为编程语言的人对原型继承方法并不陌生，js object的构造器为Object, Object的原型链上挂载的内容可以被所有js object所继承。

因此，如果对js对象深度拷贝了有危险的json字符串所构造出的js对象，将会把污染扩大到程序全局。

### 修复

Snyk的工程师Kirll已经给lodash开源库推送了一条修改,具体修改为

![修改代码](https://res.cloudinary.com/snyk/image/upload/v1562272212/Screen_Shot_2019-07-04_at_23.29.28.png)



### 原文章

[snyk报道](https://snyk.io/blog/snyk-research-team-discovers-severe-prototype-pollution-security-vulnerabilities-affecting-all-versions-of-lodash/)
