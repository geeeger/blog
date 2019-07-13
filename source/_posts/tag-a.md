---
title: a标签target属性仔细审题
date: 2018-12-19 12:07
tags: [ html ]
description: 对html标签进行探索
categories:
- web前端
---

我们来看[msdn](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a)对于a标签target的描述


+ Specifies where to display the linked URL. It is a name of, or keyword for, a browsing context: a tab, window, or <iframe>. The following keywords have special meanings:
    + _self: Load the URL into the same browsing context as the current one. This is the default behavior.
    + _blank: Load the URL into a new browsing context. This is usually a tab, but users can configure browsers to use new windows instead.
    + _parent: Load the URL into the parent browsing context of the current one. If there is no parent, this behaves the same way as _self.
    + _top: Load the URL into the top-level browsing context (that is, the "highest" browsing context that is an ancestor of the current one, and has no parent). If there is no parent, this behaves the same way as _self.

翻译一下，就是该属性可以指定在什么地方展示我们的链接页面。该属性值可以是浏览器上下文比如说 tab window或者 iframe的名字，或者关键词.下面有几个关键字具有特殊含义
+ _self: 在本上下文下直接加载链接, a标签的默认行为
+ _blank: 在一个新的浏览器上下文中打开链接，基本上是个新tab
+ _parent: 该上下文的父上下文中加载链接，如果该上下文不是iframe，行为跟_self一致
+ _top: 该上下文的顶部上下文中加载链接，如果该上下文不是iframe，行为跟_self一致

白话描述一下，

target的值你可以指定iframename 或者windowname, 一个随意的值，或者那四个特殊关键字

指定name将在 iframe中加载，
示例：

```html
<a href="https://www.baidu.com" target="iframename">iframename</a>
<iframe name="iframename"></iframe>
```

指定windowname

```html
<a href="https://www.baidu.com" target="windowname">windowname</a>
<script>
window.open('', 'windowname', '_blank');
</script>
```

指定随意一个关键字操作类似指定windowname
新开一个tab页，并在里面直接加载新链接

_self的情况下，就是在当前tab直接打开

_blank是无论如何新开一个tab

_parent是有父框架，比如iframe上层,直接刷新iframe宿主页面

_top是当有祖先框架的时候，情况就是 tab页里有iframe套iframe的情况，子孙iframe的 a标签设置了_top,祖先tab页被加载新url
