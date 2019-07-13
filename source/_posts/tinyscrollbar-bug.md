---
title: tinyscrollbar锁滚动问题
date: 2017-10-27 16:29
tags: [ javascript, w3c, scrollbar ]
description: 对该插件bug的探索
categories:
- web前端
---

近日做需求，发现一个常用插件jquery.tinyscrollbar突然出毛病了，于是探究了一番个中原因。

### 出问题的场景

在ie，chrome以及其他主流浏览器下，jquery.tinyscrollbar能够正常响应并滚动自定义滚动条。但在最新版firefox下，准确的说是OS X系统环境下，发生了自定义滚动条锁滚动的问题。

### 寻找问题源头

我们发现场景下，是滚动了一段距离后，插件突然卡住。

于是我开始翻阅jquery.tinyscrollbar的源码，寻找设置内容位置的代码。jquery.tinyscrollbar是通过监听页面滚轮事件，进一步进行设置内容位置来实现自定义滚动条的。其中响应滚动事件的方法是_wheel，那好，我们来看_wheel的源码

通过阅读jquery.tinyscrollbar源码发现，有一段源码是如此陈述的：

```js
/**
 * @method _wheel
 * @private
 */
function _wheel(event) {
    if(self.hasContentToSroll) {
        // Trying to make sense of all the different wheel event implementations..
        // 接洽原生事件
        var evntObj = event || window.event
        // 获取滚轮的差量
        ,   wheelDelta = -(evntObj.deltaY || evntObj.detail || (-1 / 3 * evntObj.wheelDelta)) / 40
        // 获取滚动单位
        ,   multiply = (evntObj.deltaMode === 1) ? self.options.wheelSpeed : 1
        ;
        // 计算内容位置
        self.contentPosition -= wheelDelta * multiply * self.options.wheelSpeed;
        self.contentPosition = Math.min((self.contentSize - self.viewportSize), Math.max(0, self.contentPosition));
        // 计算滚动条位置
        self.thumbPosition = self.contentPosition / self.trackRatio;

        /**
         * The move event will trigger when the carousel slides to a new slide.
         * 向外抛出移动事件
         * @event move
         */
        $container.trigger("move");

        // 设置滚动条位置
        $thumb.css(posiLabel, self.thumbPosition);
        // 设置内容位置
        $overview.css(posiLabel, -self.contentPosition);

        // 判断是否触底，触底的话阻止事件继续触发
        if(self.options.wheelLock || _isAtBegin() && _isAtEnd()) {
            evntObj = $.event.fix(evntObj);
            evntObj.preventDefault();
        }

        if(_isAtBegin() && _isAtEnd()){
            evntObj.stopPropagation(); 
        }
        
    }
}
```

既然是内容滚不动了，那么问题一定出在设置内容位置的地方了

### 确定问题

我们在这个方法里对self.contentPosition打了个log，果不其然，self.contentPosition显示为NaN。要知道NaN和任何数做计算最后所得的值都是NaN的，所以出现了bug。

那么这个NaN是哪里来的呢？继续对wheelDelta和multiply打log，发现wheelDelta产生了NaN值。

此时一头黑人问号。近一步翻阅MDN发现，大部分现代浏览器支持wheel事件（DOM Level 2的事件），ie和webkit浏览器支持mousewheel事件（非标准）,老的火狐浏览器支持的是DOMMouseScroll事件（非标准）。于是我们开始探究几个事件中的差异

wheel事件所具有的read-only属性

```js
WheelEvent.deltaX
双精度值，表示滚轮在水平方向的差量
WheelEvent.deltaY
双精度值，表示滚轮在竖直方向的差量
WheelEvent.deltaZ
双精度值，表示滚轮在z轴上的差量
WheelEvent.deltaMode
无符号长整形，表示滚动的单位， 0为表示px，1为表示以行为单位滚动，2为以页为单位滚动
```

wheel事件同时继承了父类MouseEvent, UIEvent 和 Event的属性
```js
UIEvent.detail
返回一个长整型数值，用于描述该事件，依赖于事件类型
```

delta的值并不代表真实的滚动量，只是针对鼠标指针的位置来计算的

---

MouseWheelEvent read-only属性

```js
wheelDelta
长整型，以像素来计算的滚轮偏移值
wheelDeltaX
长整型，以像素来计算的滚轮x轴偏移值
wheelDeltaY
长整型，以像素来计算的滚轮y轴偏移值
detail
该值总是0，除了Opera浏览器以外
```
---

DOMMouseScroll只有一个属性

```js
detail
用于精确描述滚动，正值表示向下滚，负值表示向上滚。向上滚一页-32768,向下滚一页32768，其他值表示滚动行数

重要描述，该值永远不为0
```

---

detail值的描述

在MouseWheelEvent中，

Opera设置这个值和firefox的Gecko内核DOMMouseScroll 事件的 detail是一样的。都用来表示以行来滚动，负值用来表示向底部或者向右滚动。在mac上，滚动加速阶段会计算该值。在linux上，是由原生滚动事件设置的，值为2或者-2

### 所以新版firefox中wheel事件发生了啥？

我们打印console.log(evt.deltaX,event.detail,event.wheelDelta)。发现在触底的时候，日志显示(0,0,undefined)，真相大白！

在webkit或者blink中，deltaX这个值永远不会被设置为0，而在新版firefox中（mac os x），这个值在某时阻尼滚动结束的时候是会变为-0。由于下式的断言，最终整个计算中被引入了一个NaN

```js
wheelDelta = -(evntObj.deltaY || evntObj.detail || (-1 / 3 * evntObj.wheelDelta)) / 40
```

### 是插件的缺陷吗

很明显，插件作者最初是没有设想到deltaY为0的情况，于是依托或运算的截断操作写了这句经验而来的代码。对我们这些工作者而言，这样的判断是不严谨的。如果严格按照浏览器的区分来判断，就能避免这个问题。以测试而言，明显作者没有考虑到undefined这样的极端情况。

### 作者去哪儿啦？

在git上寻找作者，发现该仓库已经年久失修了。。。作者弃坑而去

### 解决办法

临时的：
  自己把插件源码改了，将默认值设为0，避免NaN引入的风险wheelDelta = -(evntObj.deltaY || evntObj.detail || (-1 / 3 * evntObj.wheelDelta)) / 40 || 0
永久的：
  向火狐提issue~
可能实现的（极小）：
  向作者提pr

### 给我们的启示

一切按标准或者文档来（MSDN有时候不可信，[佐证如下](https://developer.mozilla.org/en-US/docs/Web/Events/mousewheel)）

```js
Interface :MouseWheelEvent
Synchronicity :asynchronous
Bubbles : yes (Though, MSDN documents "No")
Target :Element, Document, Window
Cancelable : yes (Though, MSDN documents "No")
Default action : Scroll, moving history, or zooming in/out
```

### MDN赛高！

MDN目前已经变成最大的web标准，文档集散地了

### 参考资料

[MouseWheelEvent](https://developer.mozilla.org/en-US/docs/Web/Events/mousewheel)
[DomMouseScrollEvent](https://developer.mozilla.org/en-US/docs/Web/Events/dommousescroll)
[WheelEvent](https://developer.mozilla.org/en-US/docs/Web/Events/wheel)
