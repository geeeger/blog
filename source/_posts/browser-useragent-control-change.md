---
title: 浏览器关于用户代理控制的变化
date: 2018-07-10 10:44
tags: [ javascript, chrome, safari, browser ]
description: 浏览器为了保证安全性和用户的交互舒适度，所作出的改变。
categories:
- web前端
---

# 被动的事件监听器(passive event listeners)

这是**2016 Google I/O** Mobile Talk中，阐述的一个新的提高页面滑动浏览程度的策略。

## 他有什么用？

A new feature in the DOM spec that enable developers to opt-in to better scroll performance by eliminating the need for scrolling to block on touch and wheel event listeners.

Developers can annotate touch and wheel listeners with {passive: true} to indicate that they will never invoke preventDefault.

DOM规范里的一个新特性允许开发者通过去除 触摸以及滚轮事件监听器 会停止滚动的行为来获得更好性能

开发人员可以使用{passive：true}给触摸和滚动事件做注解，以指示它们永远不会调用preventDefault(对应效果为忽略打断默认行为)。

简而言之就是这么做是为了提高页面的滑动流畅度。

## 从什么时候加入该特性的？

+ chrome 51
+ firefox 49

## 从什么时候产生了warn警告

+ chrome 56

[Intervention]Unable to preventDefault inside passive event listener due to target being treated as passive. 
See https://www.chromestatus.com/features/5093566007214080

chrome 56将绑定了scroll 和 touch的元素（window,document,body）认为是passive的。如果内部有preventDefault()，则报自动介入警告

Ignored attempt to cancel a touchmove event with cancelable=false, for example because scrolling is in progress and cannot be interrupted.

chrome 56会对在touchmove事件中，设置了冒泡为false.并且正在滚动的事件报错，原因如上，滚动时touchmove事件响应不应被阻止，以提高滚动流畅度

## 对当前H5有影响吗

+ 暂时未见反馈
+ 自动介入，只是产生了警告消息，暂未见影响。

## 当前页面是否需要修复

除使用了Fastclick的页面需要去除Fastclick依赖，并无特别需要修复的地方

iscroll用到的地方需要检查是否在监听的时候调用了preventDefault

## 当前播放器模块是否需要修复

h5直播间模块部分模块由于防止点击穿透需要，设置了触摸禁止默认事件调用和冒泡，在下一版本中视影响程度酌情修复。

# video 相关问题

## 问题

自动播放报错，或调用play pause报错。

### 影响范围

webkit内核

### 原因

[ios新的\<video\>策略博文原文](https://webkit.org/blog/6784/new-video-policies-for-ios/)

其实从safari mobi产生开始， 苹果一直在强调用户手势直接操作媒体元素。但其实从ios 8之后该政策放松了。这使得开发者可以在ios8中进行元数据的预加载（确定媒体大小，持续时间等信息）。在ios 10上，对静音的\<video\>元素，进一步放宽了对用户的手势要求。

在 ios9上,开发者只能让用户来直接操作\<video\>(某个操作必须由用户手势触发)。直接反馈是当开发者使用js的video.play()或者video.pause()来播放暂停的时候，必须直接在事件touchend，click,doubleclick或者keydown中进行。

所以

```js
button.addEventListener('click', () => { video.play(); })
```

可以执行

```js
video.addEventListener('canplaythrough', () => { video.play(); })
```
将会报错

## ios \<video\>新策略

从ios 10开始， WebKit放宽了其内联和自动播放策略。不过新政策依然看中带宽使用和用户的电池电量消耗.

默认情况下,WebKit会遵循以下政策：

+ \<video autoplay\> 对于满足以下条件的元素，会正确识别autoplay(ios之前的版本autoplay是没有用的)
	+ 如果源媒体不包含音轨，则允许\<video\>元素在没有用户手势的情况下自动播放。
	+ \<video muted\>静音也允许在没有用户手势的情况下自动播放
	+ 如果\<video\>元素在没有用户手势的情况下获取到音轨，或者变为非静音状态，播放将暂停。
	+ \<video autoplay\> 只有在元素可见的时候才会自动播放，比如滚动到页面视口中，或者用css让其可见，或者直接插入dom让其可见
	+ \<video autoplay\> 当元素移出视口或者不可见的时候，自动播放将停止。
+ \<video\> play()对于满足以下条件的元素，现在将可以使用该方法:
	+ \<video\>元素如果他的muted（静音）属性被设置为true，或者源媒体中不包含音轨，可以在无用户手势的情况下调用play()
	+ 如果\<video\>元素在没有用户手势的情况下获取到音轨，或者变为非静音状态，播放将暂停。
	+ 如果\<video\>不在视觉范围内，你可以直接调用play()
	+ video.play()会返回一个Promise,如果不满足上述条件，将会reject。(注意，该条特性依然在实验中，请看MDN相关描述:)
		+ Note that the WHATWG and W3C versions of the specification differ (as of April 20, 2016) as to whether or not this method returns a Promise or nothing at all, respectively.
+ 在 iPhone上，\<video playsinline\> 元素现在能内联播放了，并且不会自动进入全屏模式.
+ 如果没有playsinline属性，一播放就会进入全屏。
+ 当在全屏下使用缩小手势退出全屏，没有playsinline属性的\<video\>元素将会内联播放。

对于使用了WebKit框架的ios客户端而言，这些策略仍然可以通过API来控制，并且使用这些现有api来控制这些策略的用户并不会感觉到变化。有关自动播放策略的更细粒度控制，请参阅新WKWebViewConfiguration 属性mediaTypesRequiringUserActionForPlayback。iOS 10上的Safari将使用WebKit的默认策略。

### 注意

A note about the playsinline attribute: this attribute has recently been added to the HTML specification, and WebKit has adopted this new attribute by unprefixing its legacy webkit-playsinline attribute. This legacy attribute has been supported since iPhoneOS 4.0, and accordance with our updated unprefixing policy, we’re pleased to have been able to unprefix webkit-playsinline. Unfortunately, this change did not make the cut-off for iOS 10 Developer Seed 2. If you would like to experiment with this new policy with iOS Developer Seed 2, the prefixed attribute will work, but we would encourage you to transition to the unprefixed attribute when support for it is available in a future seed.

关于playsinline属性的注意事项： 该属性最近被加入了HTML规范，WebKit目前采用了这个新属性，并废弃了旧属性'webkit-playsinline'。该旧属性从 ios 4.0开始支持,根据我们的更新无前缀属性政策，我们很高兴去掉这个属性的前缀，不幸的是，iOS 10 Developer Seed 2中并没有砍掉该前缀，如果你想在iOS 10 Developer Seed 2中尝试新策略，带前缀属性才会起作用，不带前缀的版本不会起作用。

## chromium相关自动播放策略修改

[autoplay play policy changes](https://developers.google.com/web/updates/2017/09/autoplay-policy-changes)

android 7.0以上机型，浏览器及webview已经更换为chromium 内核，所以需要注意。

谷歌浏览器的自动播放策略将会在2018年4月升级，相关升级与播放声音，音轨有关。

### 新的播放行为.

也许你已经注意到了，为了提高用户体验，降低用户安装广告拦截插件的欲望，以及减少在昂贵或者受限的网络中的流量消耗，浏览器的自动播放策略正在变得更加严格。这些更改旨在让用户更好的控制播放行为，以及通过规范用例使发布商受益。

chrome的自动播放策略很简单：

+ 静音播放是始终允许的
+ 允许以下情况带声音自动播放:
	+ 用户与当前域的元素有交互行为的（例如点击，轻点等）
	+ 在桌面端，如果突破了当前用户的**媒体播放指数**阈值，则意味着用户之前播放了有声视频
	+ 在移动端，如果用户把这个网站添加到用户桌面(添加行为详见[WebAPK](https://developers.google.com/web/updates/2017/02/improved-add-to-home-screen)模块)
+ 如果页面是以frame构成，则父级页面能够指定是否允许iframe自动播放（包括带声音的）

### 媒体播放指数(Media Engagement Index MSI)

媒体播放指数衡量个人在当前网页消费媒体内容(播放视频或者音频)的倾向。Chrome的现行算法是每个来源上有效媒体播放事件数与浏览数的比值：

+ 消费媒体内容（播放视频或者音频）超过7秒的
+ 音频必须存在并且非静音状态
+ 带视频的标签页必须处于激活状态
+ 视频的尺寸必须超过200 * 140 (px)

通过以上条件，chrome计算一个在所有用户经常播放媒体的网站中最大的播放指数。如果这个值足够大，则允许桌面端的有声的媒体自动播放。

用户的MEI可以在chrome://media-engagement 页面找到

### Iframe 授权

+ 需要同域下

```html
<!-- Autoplay is allowed. -->
<iframe src="https://cross-origin.com/myvideo.html" allow="autoplay">

<!-- Autoplay and Fullscreen are allowed. -->
<iframe src="https://cross-origin.com/myvideo.html" allow="autoplay; fullscreen">
```

如果禁止了该特性策略，当开发者调用play()非用户手势触发，将会获得一个拒绝的promise状态，并报错（NotAllowedError DOMException）.自动播放属性同样会被忽略。

### 最佳实践

**Audio/Video 元素**

您需要记住一件事：**永远不要假设一个视频会播放，并且在视频没有真正播放的时候不要显示暂停按钮。**

你需要总是注意是否支持promise：

```js
var promise = document.querySelector('video').play();

if (promise !== undefined) {
  promise.then(_ => {
    // Autoplay started!
  }).catch(error => {
    // Autoplay was prevented.
    // Show a "Play" button so that user can start playback.
  });
}
```

**警告：如果没有显示任何媒体控件，请勿播放插页式广告，因为它们可能无法自动播放，用户无法开始播放。**

吸引用户的一个很酷的方法是使用静音自动播放并让他们选择取消静音（请参阅下面的代码段）。一些网站已经有效地做到了这一点，包括Facebook，Instagram，Twitter和YouTube。

注意，此处也是通过用户直接触发，如果用程序，在没有用户操作的情况下触发是不可行的。

```html
<video id="video" muted autoplay>
<button id="unmuteButton"></button>

<script>
  unmuteButton.addEventListener('click', function() {
    video.muted = false;
  });
</script>
```

## 结论

在做H5播放的时候，尽量避免autoplay。。。

