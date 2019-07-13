---
title: 如何检测css特性
date: 2017-10-10 17:49
tags: [ javascript, css, css3 ]
description: 利用枚举进行检测
categories:
- web前端
---

如果我们要检测一个css属性是否支持

```js
var dom = document.createElement('p');
if ('textShadow' in dom.style) {
    alert('支持textShadow属性')
}
else {
    alert('不支持textShadow属性')
}
```

如果我们要检测该css3属性是否支持某值

```js
var dom = document.createElement('p');

dom.style.backgroundImage = 'linear-gradient(red, tan)';

if (dom.style.backgroundImage) {
    alert('支持该属性值');
}

else {
    alert('浏览器不支持该属性值')
}
```

如何动态赋值一个css3效果，并支持所有主流浏览器

```js
function iSlider() {};

/**
 * @returns {String}
 * @private
 */
iSlider.TRANSITION_END_EVENT = null;

iSlider.BROWSER_PREFIX = null;

(function () {
    var e = document.createElement('fakeElement');
    [
        ['WebkitTransition', 'webkitTransitionEnd', 'webkit'],
        ['transition', 'transitionend', null],
        ['MozTransition', 'transitionend', 'moz'],
        ['OTransition', 'oTransitionEnd', 'o']
    ].some(function (t) {
        if (e.style[t[0]] !== undefined) {
            iSlider.TRANSITION_END_EVENT = t[1];
            iSlider.BROWSER_PREFIX = t[2];
            return true;
        }
    });
})();

/**
 * @param {String} prop
 * @param {String} value
 * @returns {String}
 * @public
 */
iSlider.styleProp = function (prop, isDP) {
    if (iSlider.BROWSER_PREFIX) {
        if (!!isDP) {
            return iSlider.BROWSER_PREFIX + IU(prop);
        } else {
            return '-' + iSlider.BROWSER_PREFIX + '-' + prop;
        }
    } else {
        return prop;
    }
};

/**
 * @param {String} prop
 * @param {HTMLElement} dom
 * @param {String} value
 * @public
 */
iSlider.setStyle = function (dom, prop, value) {
    dom.style[iSlider.styleProp(prop, 1)] = value;
};

/**
 * @type {Object}
 *
 * @param {HTMLElement} dom The wrapper <li> element
 * @param {String} axis Animate direction
 * @param {Number} scale Outer wrapper
 * @param {Number} i Wrapper's index
 * @param {Number} offset Move distance
 * @protected
 */
iSlider._animateFuncs = {
    normal: (function () {
        function normal(dom, axis, scale, i, offset) {
            iSlider.setStyle(dom, 'transform', 'translateZ(0) translate' + axis + '(' + (offset + scale * (i - 1)) + 'px)');
        }

        normal.effect = iSlider.styleProp('transform');
        return normal;
    })()
};
```

### 资料

[css揭秘](http://www.ituring.com.cn/book/1695)

[iSlider line 250](https://github.com/be-fe/iSlider/blob/master/build/iSlider.js#L250)

