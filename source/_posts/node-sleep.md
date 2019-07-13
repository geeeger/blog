---
title: node thread.sleep实现
date: 2018-06-20 14:42
tags: [ javascript, node.js ]
description: 一个骚气的实现方式
categories:
- node.js
---

最近在写一些奇怪的东西的时候，发现大佬们用go或者其他语言实现的并发任务用了thread.sleep让主进程暂停。

回头一想，妈个鸡我要复制粘贴到node一直循环不合适啊，我也需要暂停来着！

怎么办？？

抓了脑袋一会去npm上找了下相关的包，发现有个叫thread-sleep的包，下载量还挺高。

抱着好奇心去看了下源码，又发现源码相当之骚气

```js
'use strict';

var childProcess = require('child_process');
var nodeBin = process.argv[0];

module.exports = sleep;
function sleep(milliseconds) {
  var start = Date.now();
  if (milliseconds !== Math.floor(milliseconds)) {
    throw new TypeError('sleep only accepts an integer number of milliseconds');
  } else if (milliseconds < 0) {
    throw new RangeError('sleep only accepts a positive number of milliseconds');
  } else if (milliseconds !== (milliseconds | 0)) {
    throw new RangeError('sleep duration out of range')
  }
  milliseconds = milliseconds | 0;

  var shouldEnd = start + milliseconds;
  try {
    childProcess.execFileSync(nodeBin, [ '-e',
      'setTimeout(function() {}, ' + shouldEnd + ' - Date.now());'
    ], {
      timeout: milliseconds,
    });
  } catch (ex) {
    if (ex.code !== 'ETIMEDOUT') {
      throw ex;
    }
  }
  var end = Date.now();
  return end - start;
}
```

黑人问号？？？

这是什么奇怪的实现。

翻阅node文档发现

```
Synchronous Process Creation#

The child_process.spawnSync(), 
child_process.execSync(), and child_process.execFileSync() methods are synchronous and WILL block the Node.js event loop, 
pausing execution of any additional code until the spawned process exits.

Blocking calls like these are mostly useful for simplifying general-purpose scripting tasks and for simplifying the loading/processing of application configuration at startup.
```

???

以上三种同步方法会阻塞nodejs的事件循环，除非创建的子进程执行完了，才会继续执行下面的代码。

thread-sleep包的作者正是利用这一特性实现了sleep功能。叹为观止

所以很多时候我们没办法解决现有问题的原因是对文档不熟么？？
