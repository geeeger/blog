---
title: 小程序技术调研
date: 2018-07-11 11:17
tags: [ 小程序 ]
description: 对小程序开发进行调研
categories:
- 小程序
---

## 非技术侧内容精简提要

### 通常审核被拒绝的原因

[我们为什么拒绝你](https://developers.weixin.qq.com/miniprogram/product/reject.html#36-UI-%E8%A7%84%E8%8C%83)

1. 服务类目必须明确，与小程序内容符合，不可含有商业化，违禁用语
2. 名称简介需要有关联性，并不能使用通用且布局识别性的词语命名
3. logo清晰，且不得包涵腾讯，微信官方标识
4. 诱导分享，关注，下载行为，含有明示或暗示的浮层，弹窗，文案，按钮等，会被拒绝
5. 小程序主要用途为营销或者广告的，会被拒绝（例如，悬浮广告占据页面50%视觉范围，广告遮住了内容等）
6. 小程序可用性和完整性没有达到要求的（小程序本身会崩溃或导致微信崩溃的，存在严重bug的，非测试版）
7. 如果要收集用户隐私，必须明确告诉用户用途
8. 需要提供小程序文档和说明
9. 禁止热更新，禁止自动播放（斗鱼都自动播放了，所以这条对我们没什么用）
10. 自有账户体系必须有易于发现的退出选项
11. UI不符合规范（小程序有严格的UI规范）
12. 浮层和弹窗不可关闭
13. logo非透明或无有色边框
14. 如相关法律法规规定提供服务的界面必须进行特别信息标识的，应予以明确标识。如小游戏必须在游戏开始画面显著位置标明游戏的批准文号、网络游戏出版号以及著作权登记号，全文登载《健康游戏忠告》等。

### 其他注意事项

1. 小程序名称不能喝公众号，订阅号，服务号重名，如果重名需要更换名称
2. 小程序名称设置完成后就再也不能更改了
3. 认证需要一点认证费用
4. 服务器配置每个月只能修改三次
5. 小程序头像，介绍，服务范围每个月只能修改1次，小程序二维码在第一个版本上线后才能获得
6. 一个主体可以注册30个小程序，一个绑定身份的开发者只能创建5个小程序
7. 地理位置信息的采集使用必须征得用户同意
8. 特殊行业所需要的资质材料
	1. 社交直播类： 《信息网络传播视听节目许可证》或《网络文化经营许可证》(经营范围含网络表演)
9. [小程序设计指南（不按规范来会被拒绝发布）](https://developers.weixin.qq.com/miniprogram/design/index.html?t=2018413)

### 支付规范

1. 支付必须明确提示
2. 支付不得违法
3. ios暂不能为虚拟物品购买提供支付功能（由apple程序开发许可协议和app store审核指南所限制）

### 功能页面的配置

功能页面不涉及参数，可以配置最多5组，这五组可以生成小程序二维码

### 绑定开发者

1. 已认证的企业小程序可以绑定20个开发者，40个体验者。可以设置不同的权限。
2. 未认证的减半。
3. 个人的减半再减半。

## 技术侧内容精简提要

### 代码的审核与发布

代码在腾讯服务器上托管，所以我们需要在本地仓库保管一份

### 小程序内是否可以内嵌网页

1. 可以，但是要遵循[微信外部链接内容管理规范](https://weixin.qq.com/cgi-bin/readtemplate?t=weixin_external_links_content_management_specification)
2. 但是提供功能应该与小程序一致，不得绕过微信小程序平台规则
3. 如果违反，可能导致被限制功能或封禁处理

### 程序内登录问题

小程序可以通过公众号授权登录，也可以通过自有账号体系登录，但是自有账号体系在审核时需要为审核员提供一份测试账号。


### 小程序服务器域名

现有现场程序支持四个合法域名地址。

|request合法域名|socket合法域名|uploadFile合法域名|downloadFile合法域名|
|-----|-----|-----|-----|
|网络请求合法域名|websocket合法域名|文件上传服务合法域名|文件下载服务合法域名|
|是否需要加密|是否需要加密|是否需要加密|是否需要加密|
|是 https|是 wss|是 https|是 https|

### 小程序开发者工具

能够查看小程序开发结果和上传小程序代码，必备

[下载链接](https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html?t=201861)

### 简易教程

[简易教程链接](https://developers.weixin.qq.com/miniprogram/dev/)
[框架教程](https://developers.weixin.qq.com/miniprogram/dev/framework/MINA.html)
[原生组件](https://developers.weixin.qq.com/miniprogram/dev/component/)

### 基础库兼容处理

#### 基础库是什么

微信客户端提供给小程序的基础能力的库，有版本区别，所以用户需要处理好不同版本之间的兼容问题

#### 如何兼容?

微信在最初的api接口中就内置了wx.getSystemInfo，wx.getSystemInfoSync接口可以获取版本信息，可以通过这个来给用户提示，要求用户升级到最新版本等。

如果要使用某个超前api特性，并想要向下兼容，可以使用wx.canIUse接口来判断当前api是否支持

### 小程序运行机制处理

你关闭小程序的时候会发现小程序依然在执行，这是涉及到了小程序的运行机制，为了了解这些坑，以及对小程序的更新，运行，再次打开等逻辑进行优化，有必要了解一下其机制

[运行机制](https://developers.weixin.qq.com/miniprogram/dev/framework/operating-mechanism.html)

### 小程序的性能问题

1. 不能滥用setData
2. setData传递的数据不宜过大
3. 如果用户处于后台状态，不宜进行setData
4. 大图片，长列表图片资源过多会导致客户端内存占用上升，会触发webview内存回收，导致页面卡顿。应劲量减少大图片使用，并尝试做图片懒加载
5. 严格限制代码包大小，（代码包最大只能2MB，注意）
6. 控制静态资源图片的质量
7. 及时清理无用代码和资源

### 小程序多线程问题

目前小程序支持多线程，但是我们貌似没有特别的需求要处理大量数据。


### 小程序api能力

1. 网络请求
2. 上传下载请求
3. websocket请求能力
4. 选择图片能力
	1. 从本地相册选择图片或使用相机拍照
5. 预览图片能力
	1. 预览网络图片
6. 获取图片信息能力
	1. 获取图片宽高本地路劲
	2. 图片方向
	3. 图片格式
7. 保存图片能力
	1. 需用户授权
8. 录音能力
9. 背景音乐播放控制
	1. 只支持m4a,aac,mp3,wav,hls。。。
10. 音频组件
	1. 创建并返回内部audio上下文（全局只有一个<audio>）
11. 视频组件控制
	1. 创建并返回视频（就是video标签对象）上下文对象，易于操作
12. 视频能力
	1. 拍摄视频或从手机相册中选视频，返回视频的临时文件路径。
13. 保存视频到用户相册
	1. 需要授权
14. 相机组件控制api
	1. \<camera/\>
15. 实时音视频API
	1. \<live-player/\>（需要递交材料申请开通）
16. 文件操作API
	1. 保存
	2. 获取文件信息
	3. 获取已保存文件列表
	4. 获取已保存文件信息
	5. 删除已保存文件
	6. 打开文档、、只支持doc,xls,ppt,pdf,docx,xlsx,pptx
17. 数据操作api
	1. localStore缓存操作相关
18. 地理位置api
19. system api
	1. 包括系统信息
	2. 网络状态
	3. 加速度记
	4. 罗盘
	5. 大电话
	6. 扫码
	7. 剪贴板操作
	8. 蓝牙操作
	9. 屏幕
	10. 震动
	11. nfc
	12. wifi
20. 界面交互api
	1. 界面交互反馈（toast一类）,
	2. 界面设置（导航条设置，tabBar设置，置顶信息设置等），
	3. 导航跳转api,
	4. 动画api,
	5. 页面滚动api，
	6. 绘图api(与canvas息息相关)，
	7. 下拉刷新，
	8. 页面节点操作（wxml api），
	9. 布局操作api
21. 第三方平台相关api
22. 开放接口
	1. 登录api
	2. 授权api
	3. 用户信息api
	4. 微信支付api
	5. 模板消息推送
	6. 客服消息
	7. 转发分享api
	8. 收货地址api
	9. 设置api
	10. 卡卷api
	11. 微信运动api
	12. 打开app API
	13. 生物认证api
23. 更新api
24. 打点上报api
25. 多线程api

### 小程序的测试

[小程序测试方案初探](https://cloud.tencent.com/developer/article/1006183)

### 如何在移动应用中直接拉起小程序

首先，公众号平台关联小程序（小程序平台也能关联公众号）。
其次，安卓，ios可以加入相关sdk，调用其调起接口。

### 如何在一个程序页面内发起群聊

1. 首先要分享
2. [群聊id](https://developers.weixin.qq.com/blogdetail?action=get_post_info&lang=zh_CN&token=&docid=00028e3b330710feafc6e3e3d51809)
3. wx.updateShareMenu api了解一下，其中参数shareTicket是获取openGID的关键
4. 使用wx.updateShareMenu({withShareTicket:true})重置了分享链接的，在微信群里的分享卡片无法被长按分享
5. 启动小程序时可以通过App.onLaunch 或者App.onShow 获取 shareTicket
6. openGID并不能直接获取，需要向自己的后台发送shareTicket并解密后拿到真实的openGID
7. wx.onShareAppMessage api在2018年7月5日后将不再支持，最终只能在启动参数中获取了，请注意
8. 群聊对应的名称不能直接获取，只能调用<open-data>组件展示
9. 首个分享群聊的群友，也必须通过点击群里的分享卡片才能进入群聊
10. 群聊具体实现依赖我方，小程序并不直接提供群聊功能

### 小程序es6 api支持情况

**不支持以下api**

+ String.prototype.normalize
+ Array.prototype.values
+ Array.prototype.includes (ios 8 不支持)
+ Proxy

### 小程序样式支持问题

wxss在某些情况下，渲染表现可能不一致（ios WKWebView UIWebView, Android Mobile Chrome 53/57），开启样式补全可以解决大部分问题，但不是全部



### 针对es6/7特性如何做

小程序ide本身可以开启es6转es5。但限制于内置babel-core，开发体验其实并不好。

在现有的解决方案中，为了减少学习曲线，可以使用wepy等现有开发框架直接进行开发（原因: wepy等类似框架对小程序原有开发体验封构了一层，可以使用类似vue单文件的开发体验进行开发）

wepy同时使用promise对小程序提供的原生API封装了一层，可以方便的使用 async await等语法，避免了同步只能发起5个wx.request的问题。

wepy作为一套官方解决方案，可以直接上手使用。

### 小程序iconfont

不支持引入ttf等文件，如果非要用，转成base64或者使用网络静态资源

### 样式层级问题

小程序样式层级由于严格的资源限制，并没有做过多的样式层级解析

所以如果你有

```html
<view class="a">
	<view class="b"></view>
</view>

<style>
.a {
 color: #000;
}
.b {
 color: #f00;
}
</style>
```

形如上面的样式层叠写法，.b不起作用，必须写成 .a .b {}才行

### 小程序页面栈限制

小程序最多允许5层页面记录，超过就会产生回不到首页的问题，所以请合理使用wx.navigateTo， wx.redirectTo，wx.switchTab几个api

redirectTo会覆盖当前栈记录，所以请不要在首页用

### 小程序音视频组件，在线直播应用场景

\<video\>标签直接支持m3u8直播形式，但不支持flv直播形式（如果在白名单内可以直接播放m3u8, 我们在）
\<live-player\>标签支持两种直播形式，但是需要资质证明


### wx.getUserInfo问题

由于收到开发者的反馈，为了方便开发者更好地使用 获取用户信息 的接口，开发者仍然可以使用  wx.getUserInfo 接口获取用户信息。 



具体优化调整如下： 


1.获取用户头像昵称，第一次需要使用 button 组件授权，如果已经用组件授权了，wx.getUserInfo 可直接返回用户数据，无需重复授权弹窗。 
2. 如果没有用 button 组件授权，wx.getUserInfo 调用接口返回失败，提醒开发者需要先使用 button 组件授权。 
3. 用户可在设置中，取消授权。取消授权后需重新用 button 组件拉起授权。 

此次调整仅会影响开发者工具、体验版和开发版，正式版本小程序暂不受影响。 

### rpx单位

由于小程序当前使用的单位视口就是一个相对根元素单位root em-quads px，已经做好相对转换（他把屏幕均分成750个单位）。所以在作图的时候，以750px的图稿开发正好合适

#### 1rpx问题

在有些机型上，1rpx可能显示不出来，原因很简单，rem计算方式了，屏幕实际像素，逻辑像素的相关概念

#### 0rpx问题

margin padding 写0的时候最好不要带rpx单位，不然可能产生间隙

#### 全屏问题

height: 100%解决不了就用height: 100vh

vh和vw的兼容性良好

### setTimeout问题

小程序的页面setTimeout会一直存在，即使跳转页面依然存在，请书写业务的时候注意

### 原生组件问题

input，textarea，video，map，canvas，live-player等组件，非webComponent，是原生实现，显示层级上相当高，可能出现样式层盖不住的情况，开发和设计请注意.

### wx.require

有并发5个请求的限制，wepy框架是怎么解决的呢？wepy框架实现了一个简单的消息队列，只有当上一个请求完成，才会进行下一个请求，队列最大限制是10个请求

### 其他开发坑

+ {{}}不能执行方法，只能处理简单运算+-*/
	+ 由于小程序无管道实现（也就是time | filters 这类）,所以只能运用以下几种方式
		+ 1.直接setData (大量循环时成本过高)
		+ 2.设置getter （大量循环时经常访问，也不是很好）
		+ 3.在获取数据时直接过滤掉
		+ wxs扩展的方法可以在wxml里使用，wepy框架同理
			
			```html
			<!-- wxml使用方式 -->
			<wxs src="../filter/index.wxs" module="filter" />
			<view>{{filter._filterOrderType(item.type)}}</view>
			<view>{{filter._filterTimestamp(item.time)}}</view>
			
			<!-- wepy使用方式.wpy -->
			<template>
			    <text>{{filter.doSomething(...)}}</text>
			</template>
			<script>
			import filter from './../filter/filter1.wxs'
			default class Page1 extends wepy.page {
			   wxs = {
			       filter: filter
			   }
			}
			</script>
			```
+ wcss本地静态资源支持问题（图片），所以我们需要实现一套图片资源上传至cdn的逻辑

## wepy

### wepy主要解决哪些问题？

原生小程序开发的痛点

1. 小程序的定制开发文件体系中，难以直接使用某些es6特性（即使是开启es6转es5的编译）
2. 一个页面或者一个组件对应3-4个文件，其实不怎么利于维护
3. 你要手动引入npm，极端费力
4. request的并发限制问题
5. 全局数据的维护问题
6. 并不支持less scss stylus pug hbs等不同预编译器

所以wepy直接解决了上述问题，优化了开发体验

### wepy创建模板项目

```sh
npm i wepy-cli -g
wepy init standard myproject
# 输入上面一行代码会有一系列选项
cd myproject
npm init
```

由于wepy自带构建和打包，所以用户需要关闭project.config.js里的一些选项，避免微信开发者工具冲突，微信开发者工具仅仅当做一个预览工具，但要预览，你需要设置项目目录（微信开发者工具-添加项目-项目目录更改）

### wepy如何赋予书写者书写es6能力

+ wepy-compiler-babel
+ wepy-compiler-less
+ babel-plugin-transform
	+ 支持class属性写法
		
		```js
		class a {
			data = {
				a: 1,
				b: 2
			}
		}
		```
		
	+ 支持装饰器写法
		+ 装饰器描述详见tc39草案文档
	
		```js
		function dec(id){
		    console.log('evaluated', id);
		    return (target, property, descriptor) => console.log('executed', id);
		}
		
		class Example {
		    @dec(1)
		    @dec(2)
		    method(){}
		}
		```
	+ 允许扩展export from语句
		+ export * as ns from 'mod';
		+ export v from 'mod';
	+ 支持object成员展开
		+ let { x, y, ...z } = { x: 1, y:2, c: 3, d: 4 };
		+ let n = { x, y, ...z };
+ 其他transform，你可以自行npm i babel-plugin-transform-x -D,并在wepy.config.js里配置，扩展其余tc39草案规则

### 为什么说wepy更适合dev-prod开发

wepy引入了cross-env,你可以在wepy.config.js里同时写上dev配置和prod配置，灵活使用
[WePY根据环境变量来改变运行时的参数](https://github.com/Tencent/wepy/wiki/WePY%E6%A0%B9%E6%8D%AE%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F%E6%9D%A5%E6%94%B9%E5%8F%98%E8%BF%90%E8%A1%8C%E6%97%B6%E7%9A%84%E5%8F%82%E6%95%B0)

### wepyignore文件

用于忽略不用打包的文件，不要什么都带上线

### .eslintrc

可以自行扩展代码检查规则，保证代码风格一致

### 测试

wepy-cli 支持以html的形式直接打开，通过cli发送命令，可以模拟登陆，获取微信用户数据等一系列操作，可以进行页面测试。但wepy并没有提供测试套件，需要自行研究。

后期可以自行加上测试脚本，可以参考[小程序测试方案初探](https://cloud.tencent.com/developer/article/1006183)

### 总结

用已有的脚手架直接开发更快速，自己搭建太慢了，并且我们没有时间写wcss, wxml, wxs文件解析器，所以请直接使用现有脚手架。
