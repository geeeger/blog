---
title: Web Notifications 学习
date: 2017-10-10 17:51
tags: [ javascript, html5, WebAPI ]
description: 学习新的WebAPI
categories:
- web前端
---

网页通知API。
这是2011年由谷歌技术员John Gregg提出的一项网页通知api。

### 定义

请读者直接参考whatwg工作组对这个api的定义

[Notifications API](https://w3c-html-ig-zh.github.io/notifications/whatwg/)

### API设计

```
[Constructor(DOMString title, optional NotificationOptions options),
 Exposed=(Window,Worker)]
interface Notification : EventTarget {
  static readonly attribute NotificationPermission permission;
  [Exposed=Window] static void requestPermission(optional NotificationPermissionCallback callback);

  attribute EventHandler onclick;
  attribute EventHandler onshow;
  attribute EventHandler onerror;
  attribute EventHandler onclose;

  readonly attribute DOMString title;
  readonly attribute NotificationDirection dir;
  readonly attribute DOMString lang;
  readonly attribute DOMString body;
  readonly attribute DOMString tag;
  readonly attribute USVString icon;
  readonly attribute USVString sound;
  // 目前还没有暴露振动属性；见 bug 23682
  readonly attribute boolean renotify;
  readonly attribute boolean silent;
  readonly attribute boolean noscreen;
  readonly attribute boolean sticky;
  [SameObject] readonly attribute any data;

  void close();
};

dictionary NotificationOptions {
  NotificationDirection dir = "auto";
  DOMString lang = "";
  DOMString body = "";
  DOMString tag = "";
  USVString icon;
  USVString sound;
  VibratePattern vibrate;
  boolean renotify = false;
  boolean silent = false;
  boolean noscreen = false;
  boolean sticky = false;
  any data = null;
};

enum NotificationPermission {
  "default",
  "denied",
  "granted"
};

callback NotificationPermissionCallback = void (NotificationPermission permission);

enum NotificationDirection {
  "auto",
  "ltr",
  "rtl"
};
```

从api设计可知，该api的构造器接受两个参数，即*通知标题*与*通知参数*，该对象可在window和worker上被使用

> 通知标题

通知标题即是指用户可见的通知内容，由容器显示在通知窗口上

> 通知参数

+ dir
    + 通知的方向，其可用类型为: 默认自动确认， 从左及右， 从右及左。在chrome最新浏览器上亲测无用。。
+ lang
    + 标记通知的标题，和身体的语言类型，默认为空字符串，若需要填写，应填写一个有效的 [BCP 47](http://www.ietf.org/rfc/bcp/bcp47.txt) 语言标记。据猜测是为浏览器翻译服务。
+ body
    + 通知内容，显示在通知标题之下，默认为空字符串
+ tag
    + 标记通知的类型，打上标签，默认为空字符串。使用该tag的场景是： 1.多实例通知并发操作的时候，当两个通知同时出现时，同一tag只出现一次。2.[单实例时](https://w3c-html-ig-zh.github.io/notifications/whatwg/#using-the-tag-member-for-a-single-instance)，两个定义了相同的tag的通知实体，会显示最新那个。
+ icon
    + 指定通知图标，接受一个URI资源标识符字符串,不填或解析错误时，默认未定义
+ sound
    + 指定通知声效，同上。在最新的Notifications技术评审稿中，该参数被舍弃
+ vibrate
    + 指定通知是否震动，该参数接洽了新的vibrate api, 通过[valid pattern](https://w3c-html-ig-zh.github.io/vibration/)驱动，具体请点击链接查看示例。在最新的Notifications技术评审稿中，该参数被舍弃
+ renotify
    + 当一个通知列表中通知被替换时，指定该通知是否再次显示。值为true||false。在最新的Notifications技术评审稿中，该参数被舍弃
+ silent
    + 该标志表示不接收声音或者振动通知，值为true||false。在最新的Notifications技术评审稿中，该参数被舍弃
+ noscreen
    + 设置该标志表示设备屏幕不会被启用，值为true||false。在最新的Notifications技术评审稿中，该参数被舍弃
+ sticky
    + 设置该标志表示最终用户将不能很容易地清除 notification。设置该标志，通知将为永久型通知。在最新的Notifications技术评审稿中，该参数被舍弃
+ data
    + 扩展数据，在最新的Notifications技术评审稿中，该参数被舍弃

#### 可设置的事件回调

```js
var not = new Notification("Gebrünn Gebrünn by Paul Kalkbrenner");
// 当点击通知时
not.onclick = function () { alert('clicked') }
// 当通知出现时
not.onshow = function () { alert('show') }
// 当通知关闭时
not.onclose = function () { alert('closed') }
// 当通知发生错误时
not.onerror = function (e) { console.log(e.message) }
```

#### 静态属性

Notification.permission:获取用户当前对通知的设置，包括default，denied， granted三个枚举值。default相当于禁止显示，表示用户没有设置通知许可，denied表示用户设置过不希望接受通知，同时通知是无法显示的，granted可以显示通知

#### 静态方法

Notification.requestPermission(ptional NotificationPermissionCallback callback)该方法接受一个回调,回调带一个参数status。注意，在最新的技术评审稿中，调用该方法是异步的，会返回一个promise对象，我们完全可以点个then去处理status。

在评审稿中，它首先会设置permission = status，如果status === 'default'，浏览器会弹出一个小窗，询问用户对该域进行通知设置。然后异步处理我们的callback。例子如下
```js
function notifyMessage(message, options, callback) {
    if (Notification && Notification.permission === 'granted') {
        var notification = new Notification(message, options);
        callback(null, notification);
    } else if (Notification.requestPermission) {
        Notification.requestPermission(function (status) {
            if (Notification.permission !== status) {
                Notification.permission = status;
            }
            if (status === 'granted') {
                var notification = new Notification(message, options);
                callback(null, notification);
            } else {
                callback(new Error('user denied'));
            }
        });
    } else {
        callback(new Error('doesn\'t support Notification API'));
    }
}

function notifyMessage(message, options, callback) {
    if (Notification && Notification.permission === 'granted') {
        var notification = new Notification(message, options);
        callback(null, notification);
    } else if (Notification.requestPermission) {
        Notification
            .requestPermission()
            .then(function (status) {
                new Notification(message, options);
                callback(null, notification);
            })
            .catch(function (status) {
                callback(new Error('user denied'));
            });
    } else {
        callback(new Error('doesn\'t support Notification API'));
    }
}
```

#### 实例方法
notification.close();直接关闭通知。
