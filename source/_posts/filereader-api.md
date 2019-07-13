---
title: FileReader Api
date: 2017-09-22 15:46
tags: [ javascript, WebAPI ]
description: 学习FileReader API
categories:
- web前端
---

FileReader api为用户提供了方法去读取一个文件或者一个二进制大对象，并且提供了事件模型让用户可以操作读取后的结果。

### 接口

```c++
  // window, worker中可用
  [Constructor, Exposed=Window,Worker]
  // 实现EventTarget的FileReader接口声明
  interface FileReader: EventTarget {

    // 异步的读取方法
    // 直接读取二进制大对象为ArrayBuffer类型
    void readAsArrayBuffer(Blob blob);
    
    // 读取为文本,第二个参数可指定编码类型
    void readAsText(Blob blob, optional DOMString label);
    
    // 读取为base64格式
    void readAsDataURL(Blob blob);

    // 中断读取
    void abort();

    // 状态常量
    
    // 还没有加载任何数据
    const unsigned short EMPTY = 0;
    
    // 数据正在加载中
    const unsigned short LOADING = 1;
    
    // 已完成全部的读取请求
    const unsigned short DONE = 2;

    // 只读，获取常量中的某一个状态
    readonly attribute unsigned short readyState;

    // 返回文件结果，只读的，只有在读取结束后才有效
    // 数据的格式取决于读取操作是由哪个方法发起的
    readonly attribute (DOMString or ArrayBuffer)? result;

    // 如果读取时发生错误，只读的
    readonly attribute DOMError? error;

    // 事件方法属性
    
    // 当读取开始时的事件
    attribute EventHandler onloadstart;
    
    // 当进行时的事件
    attribute EventHandler onprogress;
    
    // 当读取时的事件
    attribute EventHandler onload;
    
    // 当取消时的事件
    attribute EventHandler onabort;
    
    // 当错误时的事件
    attribute EventHandler onerror;
    
    // 当读取完成的事件
    attribute EventHandler onloadend;

  };
    
```

### 构造器

当FileReader构造器被调用的时候，用户代理必须返回一个新的FileReader对象。该构造器必须在Window 或者 WorkerGlobalScope 环境下可用.

### 事件处理属性

下列的内容是事件处理属性和他们的事件处理类型：

|---|---|
|事件处理属性|事件处理类型|
|onloadstart|loadstart|
|onprogress|progress|
|onabort|abort|
|onerror|error|
|onload|load|
|onloadend|loadend|

### FileReader States 状态

FileReader对象有三种状态，在readyState属性中，当触发getting访问操作，必然会返回一个FileReader的当前状态，而他的值必然是下面三个中的其中一个：

EMPTY (数字值为 0)
    当FileReader对象呗创建的时候，是不存在pending读取状态的，因为此时没有任何读取方法被调用。这个空状态是创建FileReader时候的初始状态，直到某个读取方法被调用。

LOADING (数字值为 1)
    当一个文件或者二进制大对象正在被读取，某一个读取方法正在进行的时候，并且没有错误发生的时候，状态为loading
    
DONE (数字值为2)
    当文件对象或者二进制大对象被读入内存的时候，或者发生一个读取错误的时候，或者用户调用了abort()操作的时候，这个时候，FileReader不再进行读取，如果状态被设置为了完成，这意味着某一个读取方法被调用过了
    
### 读取一个文件或者二进制大对象(Blob)

FileReader接口有三个异步读取方法，readAsArrayBuffer, readAsText, and readAsDataURL,他们可以把文件读入内存，如果多个读取方法同时被调用（一个FileReader对象上）,用户代理必须在任何读取进行中的时候抛出一个非法状态错误

### result属性

当访问result属性，该属性将会返回一个原始二进制数据或者一个ArrayBuffer对象或者null以表示所读取文件的内容.

+ 当访问该属性的时候，如果准备状态为EMPTY，你将得到一个null结果
+ 当访问该属性的时候，如果读取过程中发生了错误，你将得到一个null结果
+ 当访问该属性的时候，如果是使用了readAsBataURL读取方法，result属性必然会返回一个DataURL编码的字符串
+ 当访问该属性的时候，如果readAsText读取方法被调用，并且没发生错误，该属性将返回指定编码的文档字符串。
+ 当访问该属性的时候，如果readAsArrayBuffer方法被调用，并且中间没有错误发生，该属性将返回一个ArrayBuffer对象

### readAsDataURL(blob) 方法
当调用该方法，用户代理将会执行以下步骤

1. 如果状态为loading，抛出非法状态错误异常，并终止流程。

2. 如果二进制大对象引用处于非可读状态（ CLOSED readability state）,在上下文对象上设置错误属性，用来返回 InvalidStateError DOMError，并且触发一个error事件，在上下文对象中调用错误，终止流程。

3. 如果没事，就将读取状态设置为LOADING。

4. 初始化一个带注解的读取任务，将blob参数作为输入并且处理在下述[file reading task source](https://www.w3.org/TR/FileAPI/#fileReadingTaskSource)上的任务队列

5. 处理读取错误，如果开始读取就失败，流程将进入错误触发流程

6. 处理读取并且触发loadstart事件

7. 处理读取到的数据，触发progress事件

8. 处理读取到结束符(EOF),执行以下步骤:
    1. 设置readyState为DONE
    2. 设置result属性内容为读操作的DataURL结果，当访问该属性的时候，将二进制对象数据以DataURL形式返回
    3. 触发load事件
    4. 直到readyState不是loading状态，触发loadend事件
    
9. 结束流程

### readAsText(blob, label) 方法

该方法接受一个额外的可选参数label，他是一个字符串，表明读取成的文档应该以何种形式编码，如果提供了该参数，当在调用该方法过程中，将会以该种编码形式编码读取到的文档。

当该方法被调用，用户代理将会执行以下过程：

1. 如果readyState状态为loading，抛出非法状态错误异常，并终止流程。

2. 如果二进制大对象引用处于非可读状态（ CLOSED readability state）,在上下文对象上设置错误属性，用来返回 InvalidStateError DOMError，并且触发一个error事件，在上下文对象中调用错误，终止流程。

3. 如果没事，就将读取状态设置为LOADING。

4. 初始化一个带注解的读取任务，将blob参数作为输入并且处理在下述[file reading task source](https://www.w3.org/TR/FileAPI/#fileReadingTaskSource)上的任务队列

5. 处理读取错误，如果开始读取就失败，流程将进入错误触发流程

6. 处理读取并且触发loadstart事件

7. 处理读取到的数据，触发progress事件

8. 处理读取到结束符(EOF),执行以下步骤:
    1. 设置readyState为DONE
    2. 设置result属性内容为读操作的结果，当访问该属性的时候，将数据以规定编码形式编码后返回
    3. 触发load事件
    4. 直到readyState不是loading状态，触发loadend事件

9. 结束流程

### readAsArrayBuffer(blob) 方法

当该方法被调用，用户代理执行以下步骤：

1. 如果readyState状态为loading，抛出非法状态错误异常，并终止流程。

2. 如果二进制大对象引用处于非可读状态（ CLOSED readability state）,在上下文对象上设置错误属性，用来返回 InvalidStateError DOMError，并且触发一个error事件，在上下文对象中调用错误，终止流程。

3. 如果没事，就将读取状态设置为LOADING。

4. 初始化一个带注解的读取任务，将blob参数作为输入并且处理在下述[file reading task source](https://www.w3.org/TR/FileAPI/#fileReadingTaskSource)上的任务队列

5. 处理读取错误，如果开始读取就失败，流程将进入错误触发流程

6. 处理读取并且触发loadstart事件

7. 处理读取到的数据，触发progress事件

8. 处理读取到结束符(EOF),执行以下步骤:
    1. 设置readyState为DONE
    2. 设置result属性内容为读操作的结果，当访问该属性的时候，将数据以ArrayBuffer对象的形式返回
    3. 触发load事件
    4. 直到readyState不是loading状态，触发loadend事件

9. 结束流程

### 错误处理步骤

首先，这些错误步骤是用于处理读取过程中获得失败原因的。

1. 设置上下文中的readyState为DONE状态，然后将result置null

2. 设置上下文中的error属性，当我们访问ctx.error的时候，值返回一个DOMError对象，该对象记录了失败原因。触发error事件。

3. 直到readyState不是loading状态，触发loadend事件

4. 流程终止并终止任何正在进行的读方法

### abort() 方法

当调用该方法，用户代理做以下事情：

1. 如果readyState = EMPTY或者 readyState = DONE, 设置result为null,终止流程

2. 如果状态为LOADING,设置状态为DONE，设置result为null,

3. 如果下述读取任务在任务队列中，从队列中移除这些任务

4. 终止正在执行的读取方法，终止其处理流程

5. 触发abort事件

6. 触发loadend事件

### blob参数

FileReader上有三个异步方法，FileReaderSync有三个同步方法，URL对象上有createObjectURL，createFor两个静态方法，他们都接受一个叫做blob的参数，这一章节将阐述该参数的定义

> blob
  这个形式参数是指调用时的一个二进制大对象的实参，并且他必然是一个非底层文件系统拿到的File/Filelist/Blob对象的引用

### 声明编码

当我们通过readAsText(bolb, label)方法读取blob对象的时候，必须遵循：

1. 使 encoding 为 null
2. 如果提供了label参数,设置encoding = label，这个label字符串必须符合现行编码标准所规定的各种编码类型
3. 如果"获取编码"（2这一步）这一步骤返回失败，设置encoding为null
4. 如果encoding为null,并且blob对象提供了type属性，并且限定了一个字符集参数（例如 text/plain;charset=UTF-8）,然后该步骤会取此限定参数作为encoding。
5. 如果上一步失败，设置encoding = null
6. 如果encoding = null, 设置encoding = 'utf-8'
7. 获取对blob的编码结果

### 事件

FileReader对象就是自己所接受事件的event target。。。因为从第一章节我们知道这个FileReader API是继承自 EventTarget的。。。。

当按照规范说明触发某个进度事件（onload什么的，event对象的构造函数是ProgressEvent）的时候，将遵循以下内容：
+ 进度事件的e，是不会冒泡的e.bubbles = false
+ 进度事件的事件对象e是不可取消的 e.cancelable = false
+ 术语“触发一个事件（fire an event）”是在DOM Core规范中定义的。Progress Event是Progress Events规范定义的

```js
const reader = new FileReader();
reader.onload = function (e) {
    console.log(e.target === this) // true
    console.log(this === reader) // true
    console.log(e.bubbles === false) // true
    console.log(e. cancelable === false) // true
    console.log(e.cancelBubble === false) // true
    console.log(console.log(e.constructor.toString())) // function ProgressEvent() { [native code] }
}
```
