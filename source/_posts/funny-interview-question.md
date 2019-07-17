---
title: 一道有趣的面试题
date: 2019-07-17 10:17:45
tags: [ javascript, ecmascript262 ]
description: 出自群里一位壕粘贴出的面试题
categories:
- web前端
---

据悉，这道题好像是京东考的。

### 题目

```
var x = ?
// 如何令 x == 1 && x == 2 && x == 3
```

### 解答

#### object方式

```js
var x = {
    a: 1,
    valueOf: function () {
        return this.a++;
    }
}
```

```js
var x = {
    a: 1,
    toString: function () {
        return this.a++;
    }
}
```

#### array方式

```js
var x = [1, 2, 3];
x.valueOf = function () {
    return this.shift();
}
```

```js
var x = [1, 2, 3];
x.toString = function () {
    return this.shift();
}
```

```js
var x = [1,2,3];
x.join = x.shift;
```

#### function方式

```js
var x = function () {};
x.a = 1;
x.toString = function () {
    return this.a
}
```

### 本质

请看ecmascript 262规格书

#### 抽象相等比较算法

比较运算 x==y, 其中 x 和 y 是值，产生 true 或者 false。这样的比较按如下方式 进行:

+ 若Type(x)与Type(y)相同，则
    + 若Type(x)为Undefined，返回true。
    + 若Type(x)为Null，返回true。
    + 若Type(x)为Number，则
        + 若x为NaN，返回false。
        + 若y为NaN，返回false。
        + 若x与y为相等数值，返回true。
        + 若x 为 +0 且 y为−0， 返回true。
        + 若x 为 −0 且 y为+0， 返回true。
        + 返回 false。
    + 若 Type(x)为 String, 则当 x 和 y 为完全相同的字符序列(长度相等且相同 字符在相同位置)时返回 true。 否则， 返回 false。
    + 若Type(x)为Boolean, 当x和y为同为true或者同为false时返回true。否 则， 返回 false。
    + 当x和y为引用同一对象时返回true。否则，返回false。
+ 若x为null且y为undefined， 返回true。
+ 若x为undefined且y为null， 返回true。
+ 若 Type(x) 为 Number 且 Type(y)为 String， 返回 comparison x == ToNumber(y)的结果。
+ 若 Type(x) 为 String 且 Type(y)为 Number，
    + 返回比较 ToNumber(x) == y 的结果。
+ 若 Type(x)为 Boolean， 返回比较 ToNumber(x) == y 的结果。
+ 若 Type(y)为 Boolean， 返回比较 x == ToNumber(y)的结果。
+ 若Type(x)为String或Number，且Type(y)为Object，返回比较x== ToPrimitive(y)的结果。
+ 若 Type(x)为 Object 且 Type(y)为 String 或 Number， 返回比较 ToPrimitive(x) == y 的结果。
+ 返回 false。


本质上，本题利用以下两条抽象比较规则

+ 若 Type(x) 为 String 且 Type(y)为 Number，
    + 返回比较 ToNumber(x) == y 的结果。
+ 若 Type(x)为 Object 且 Type(y)为 String 或 Number， 返回比较 ToPrimitive(x) == y 的结果。


实际上，三者都是Object，不明确此处为何需要自行翻阅ecma262的规格书以及复习基本类型

那么，为什么用valueOf，toString, 覆盖join都能实现呢，请查看以下规格书定义：

#### ToPrimitive

ToPrimitive 运算符接受一个值，和一个可选的 期望类型 作参数。ToPrimitive 运算符把其值参数转换为非对象类型。如果对象有能力被转换为不止一种原语类 型，可以使用可选的 期望类型 来暗示那个类型。根据下表完成转换:

此处我们只关注Object：

+ Object
    + 返回该对象的默认值。(调用该对象的内部方法\[\[DefaultValue\]\]一樣)

#### 关注\[\[DefaultValue\]\]\(hint\)

对象内部方法\[\[DefaultValue\]\]\(hint\)

当用字符串 hint 调用 O 的 \[\[DefaultValue\]\] 内部方法，采用以下步骤:

+ 令 toString 为用参数 "toString" 调用对象 O 的 \[\[Get\]\] 内部方法的结果。
+ 如果 IsCallable(toString) 是 true，则
    + 令 str 为用 O 作为 this 值，空参数列表调用 toString 的 \[\[Call\]\] 内部方法的结果.
    + 如果 str 是原始值，返回 str。
    + 令 valueOf 为用参数 "valueOf" 调用对象 O 的 \[\[Get\]\] 内部方法的结果。
    + 如果 IsCallable(valueOf) 是 true，则
        + 令 val 为用 O 作为 this 值，空参数列表调用 valueOf 的 \[\[Call\]\] 内部方法的结果。
        + 如果 val 是原始值，返回 val。
    + 抛出一个 TypeError 异常。

当用数字 hint 调用 O 的 \[\[DefaultValue\]\] 内部方法，采用以下步骤:

+ 令 valueOf 为用参数 "valueOf" 调用对象 O 的 \[\[Get\]\] 内部方法的结果。
+ 如果 IsCallable(valueOf) 是 true，则
    + 令 val 为用 O 作为 this 值，空参数列表调用 valueOf 的 \[\[Call\]\] 内部方法的结果。
    + 如果 val 是原始值，返回 val。
    + 令 toString 为用参数 "toString" 调用对象 O 的 \[\[Get\]\] 内部方法的结果。
    + 如果 IsCallable(toString) 是 true，则
        + 令 str 为用 O 作为 this 值，空参数列表调用 toString 的 \[\[Call\]\] 内部方法的结果。
        + 如果 str 是原始值，返回 str。
    + 抛出一个 TypeError 异常。

当不用 hint 调用 O 的 \[\[DefaultValue\]\] 内部方法，O 是 Date 对象的情况下 仿佛 hint 是字符串一样解释它的行为，除此之外仿佛 hint 是数字一样解释它 的行为。

上面说明的 \[\[DefaultValue\]\] 在原生对象中只能返回原始值。如果一个宿主对象 实现了它自身的 \[\[DefaultValue\]\] 内部方法，那么必须确保其 \[\[DefaultValue\]\] 内部方法只能返回原始值。

既然已经知道了规则，那么我们需要关注以下两个方法。

#### 关注valueOf及toString方法

[valueOf MDN描述](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/valueOf)

[toString MDN描述](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/toString)

#### 为何复写join一样有效

规格书中规定当调用toString方法时， 以 "join" 作为参数调用 array 的 \[\[Get\]\] 内部方法并输出结果。

### 结论

本题考查的是类型转换后获取原始值进行对比。
