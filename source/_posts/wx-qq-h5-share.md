---
title: 微信，qq等渠道h5页面设置分享内容的多种方式
date: 2019-07-16 16:15:40
tags: [ javascript, h5, ogp, wxjssdk ]
description: 在常见的分享落地业务中，产品经理或者运营同学经常要求分享出去的网页能携带分享图片，页面描述以及页面标题。
categories:
- web前端
---

在常见的分享落地业务中，产品经理或者运营同学经常要求分享出去的网页能携带分享图片，页面描述以及页面标题。

那么怎么才能解决部分问题呢，以下有几种解决方案以供参考。

### 传统方式

最传统的方式，无非为设置title, description等head元素

```html
<head>
    <title>分享标题</title>
    <meta name="description" content="分享详情">
</head>
```

一般而言，title的存在能让所有浏览器或者webview获取到分享标题，但description并不是所有环境都能带上。
按照其他seo经验，还可在页面上增加H1 article p等标签，然而分享方面基本用不上。

---

分享图的设置

```html
<body>
<p style="display: none;">
    <img src="http://host/share.png" />
</p>
</body>
```

经验性的，利用部分环境调用分享会取第一张加载图（一般是大于300px的图片，微信规则）生成分享卡片封面的特性，可设置一个隐藏的img。
这样生成的分享卡片即可获取到分享封面。


### 微信专属

使用微信jssdk进行分享设置

```html
<script src="path/to/jweixin-1.4.0.js">
```

```js
wx.config({
    // 从后台获取签名等配置
    debug: false,
    appId: data.appId,
    nonceStr: data.nonceStr,
    timestamp: data.timestamp,
    signature: data.signature,
    // 设置需要调用的api
    jsApiList: [
        'onMenuShareTimeline',
        'onMenuShareAppMessage',
        'onMenuShareQQ',
        'onMenuShareWeibo',
        'onMenuShareQZone'
    ]
});

wx.ready(function () {
    wx.onMenuShareTimeline({
        // 分享标题
        title: title,
        // 分享链接
        link: link,
        // 分享图标
        imgUrl: imgUrl,
        success: function () {},
        cancel: function () {}
    });
    wx.onMenuShareAppMessage({
        // 分享标题
        title: title,
        // 分享描述
        desc: description,
        // 分享链接
        link: link,
        // 分享图标
        imgUrl: imgUrl,
        success: function () {},
        cancel: function () {}
    });
    wx.onMenuShareQQ({
        // 分享标题
        title: title,
        // 分享描述
        desc: description,
        // 分享链接
        link: link,
        imgUrl: imgUrl,
        success: function () {},
        cancel: function () {}
    });
    wx.onMenuShareQZone({
        // 分享标题
        title: title,
        // 分享描述
        desc: description,
        // 分享链接
        link: link,
        imgUrl: imgUrl,
        success: function () {},
        cancel: function () {}
    });
    wx.onMenuShareWeibo({
        // 分享标题
        title: title,
        // 分享描述
        desc: description,
        // 分享链接
        link: link,
        imgUrl: imgUrl,
        success: function () {},
        cancel: function () {}
    });
});
```

此方法适用微信传播，并拥有公众号，公众号设置了正确的回调域，拥有相关权限
其中分享到qq微博api已经基本没什么用了，微信上也没有分享到微博入口
需要注意的是微信jssdk在1.4.0已经不建议使用以上api，转而使用以下api

```js
// 分享给朋友变动为
wx.ready(function () {   //需在用户可能点击分享按钮前就先调用
    wx.updateAppMessageShareData({ 
        title: '', // 分享标题
        desc: '', // 分享描述
        link: '', // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
        imgUrl: '', // 分享图标
        success: function () {
          // 设置成功
        }
    })
});

// 分享到朋友圈及分享到qq空间变动为
wx.ready(function () {      //需在用户可能点击分享按钮前就先调用
    wx.updateTimelineShareData({ 
        title: '', // 分享标题
        link: '', // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
        imgUrl: '', // 分享图标
        success: function () {
          // 设置成功
        }
    })
});
```

此处需要注意：

+ 分享链接必须是包含http https协议的完整链接
+ 分享图标必须是包含http https协议的完整链接
+ 分享设置必须在用户分享前设置完毕（分享设置时会下载相应分享图片，覆盖分享按钮默认设置）
+ 经调研此二api需要微信6.7.2及以上版本（经数据调研（6月27日），6.7.2级以上版本似乎占比73%，通过小程序基础库占比推出，不准确）
    + 经使用没起作用，可能是我使用姿势有问题，或者我用错了?

### 利用开放平台分享

实际上，除了微信和qq，其余分享形式依然不能覆盖到。此时需要针对各个社会化分享场景进行配置。

现有第三方社会化分享控件都凉的差不多了，原因是没钱赚。

那么我们要么只能自己去开放平台接sdk，要么只能利用开放的分享中间页去分享。

因为会跳转中间网页进行分享操作，对于运营者和产品来说不能容忍。

例如以下网页分享方式，直接调用分享中间页。

```js
define('share', [
    'zepto',
    'eventBus',
    'mixins'
], function (
    $,
    eventBus,
    mixins
) {
    const Modal = {
        type: 'share',
        init(opts = {}) {
            this.title = opts.title;
            this.summary = opts.summary;
            this.modal = $('#' + this.type + '-modal');
            this.initDoms();
            this.pic = this.doms.shareBar.data('pic');
            this.bindEvts();
        },

        update(opts) {
            this.title = opts.title;
            this.summary = opts.summary;
            this.pic = opts.pic || this.doms.shareBar.data('pic');
            this.url = opts.url;
        },
        initDoms() {
            this.doms = {
                tips: this.modal.find('.tips'),
                shareBar: this.modal.find('.share-bar'),
                close: this.modal.find('.close'),
                a: this.modal.find('a')
            };
        },
        hide() {
            this.modal.hide();
        },
        show() {
            if (mixins.type('wx') || mixins.type('wb') || mixins.type('qq')) {
                this.doms.tips.show();
            }
            else {
                this.doms.tips.hide();
            }
            this.modal.show();
        },
        bindEvts() {
            eventBus.on('modal', (type, showType) => {
                if (type === 'all' || type === this.type) {
                    switch (showType) {
                    case 'show':
                        this.show();
                        break;
                    case 'hide':
                        this.hide();
                        break;
                    default:
                        break;
                    }
                }
            });
            const doms = this.doms;
            doms.tips.on('click', () => {
                this.hide();
            });
            this.modal.on('click', () => {
                this.hide();
            });
            doms.a.on('click', function () {
                const $this = $(this);
                const type = $this.data('type');
                Modal.shareTo(type);
            });
        },
        _shareToQQ(href) {
            const encode = window.encodeURIComponent;
            let defaultDes = this.summary || ' 分享描述';
            const p = {
                // 分享链接
                url: this.url || location.href,
                showcount: '1',
                // 分享描述
                desc: defaultDes,
                // descript
                summary: defaultDes,
                title: this.title || defaultDes,
                pics: this.pic,
                style: '203',
                width: '32',
                height: '32',
                // 开放平台uid（貌似是，忘了）
                uid: 'xxxx',
                // eslint-disable-next-line camelcase
                data_track_clickback: 'true'
            };

            href = href + '?';
            let s = [];

            for (let i in p) {
                s.push(i + '=' + encode(p[i] || ''));
            }
            href = href + s.join('&');
            mixins.openLink(href);
        },
        _shareToWB() {
            const encode = window.encodeURIComponent;
            let defaultDes = this.summary || ' 分享';
            const p = {
                url: this.url || location.href,
                content: defaultDes,
                title: this.title || defaultDes,
                pic: this.pic,
                // 开放平台appkey
                appkey: 0,
                // 相关账号uid
                ralateuid: 0
            };
            let href = 'http://service.weibo.com/share/share.php?';
            let s = [];

            for (let i in p) {
                s.push(i + '=' + encode(p[i] || ''));
            }
            href = href + s.join('&');
            mixins.openLink(href);
        },
        shareTo(type) {
            eventBus.trigger('share.to', type);
            switch (type) {
            case 'wx':
                break;
            case 'wb':
            case 'tsina':
                this._shareToWB();
                break;
            case 'qzone':
                this._shareToQQ('http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey');
                break;
            case 'cqq':
                this._shareToQQ('http://connect.qq.com/widget/shareqq/index.html');
                break;
            default:
                break;
            }
        }
    };
    return {
        init(opts) {
            Modal.init(opts);
        },
        update(opts) {
            Modal.update(opts);
        }
    };
});
```

这种方式，不接受的话，我们还有另一种方式。下面一章讲

### 利用ogp设置

ogp全称：The Open Graph protocol，直译：开放图谱协议，百度译：通讯协定

据其简介：

+ 允许任何网页能在一个社会图谱中形成富文本对象
+ facebook弄的
+ 最开始是为了整合社交体验。

国内大厂（除了某些app魔改浏览器），基本都兼容了这玩意，可以使用这东西来指定分享卡片内容。

至少在笔者实验来说，qq，微信，微博支持都不错，兼容该协议。

使用方式

```html
<head>
    <meta property="og:type" content="website">
    <meta property="og:title" content="分享标题">
    <meta property="og:description" content="分享描述">
    <meta property="og:img" content="完整的分享图片链接">
    <meta property="og:url" content="完整的分享页面地址">
</head>
```

除了ogp外，各大厂商一般会定制该协议以适应自己和自己伙伴的社交通讯等业务，如有需要请自行百度。

嗯，社会在进步。。。

### 结语

结合多种分享方式，基本上能覆盖90%的应用场景，再不行我感觉也没其他方法了。

资料：

[jweixin-1.4.0官方文档](https://mp.weixin.qq.com/wiki?action=doc&id=mp1421141115)

[小程序基础库版本占比](https://developers.weixin.qq.com/miniprogram/dev/framework/client-lib/version.html)

[The Open Graph protocol](http://ogp.me/)

[为什么微信分享的链接有的会有小图片，有的却没有呢？](https://www.zhihu.com/question/22540443/answer/30544319)
