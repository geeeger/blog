---
title: redux中间件探秘
date: 2017-10-10 17:46
tags: [ javascript, redux ]
description: 对redux中间件的实现进行探索
categories:
- web前端
---

### 从redux-thunk引出思考

在使用redux-thunk进行异步action书写的时候，我经常好奇redux到底如何运作，让asyncAction成为可能

为了探究，我们必须看一下redux-thunk的源码了。幸运的是redux-thunk的源码很少。。。至于为什么，下面立马讲解。

### redux-thunk的源码

```js
// redux-thunk source code
function createThunkMiddleware(extraArgument) {
  return ({ dispatch, getState }) => next => action => {
    if (typeof action === 'function') {
      return action(dispatch, getState, extraArgument);
    }

    return next(action);
  };
}

const thunk = createThunkMiddleware();
thunk.withExtraArgument = createThunkMiddleware;

export default thunk;
```

从源码可以看出该中间件仅仅只是一个工厂函数，输出了一个嵌套工厂函数的工厂函数，那个最终参数带着next的返回函数，就是redux所需要适应的中间件。

以es6箭头语法看来可能比较麻烦，我们可以试着把这个代码直接转成es5的形式看看。

```js
function createThunkMiddleware(extraArgument) {
  return function (storeOrFakeStore) {
    var dispatch = storeOrFakeStore.dispatch;
    var getState = storeOrFakeStore.getState;
    return function (next) {
      return function (action) {
          return action(dispatch, getState, extraArgument);
      }
      return next(action);
    }
  };
}
```

从这个源码可以看出，本身中间件是会接受当前store或者一个fakeStore（这个fakeStore可能仅仅只承载了store的两个api，dispatch和getState），并将dispatch和getState这两个store的方法传进可能执行异步操作的action函数里。这样，action完成异步操作以后，同样被赋予了dispatch的权利，就能够将状态通过action流转到下一个场景了。

那同学们又会问了，这个next是个啥？恩，其实这个next其实就是下一个要处理action的中间件，毕竟中间件是一个接着一个的对吧。如果大家写过koa或者express应该对这个next会熟悉很多。

接下来我们来看看react源码中的createStore模块是怎么应用中间件的。

### 我们使用createStore api创建store的时候发生了什么

applyMiddleware同样也是一个工厂，如果读者您用过redux中间件的话，你应该知道redux创建store是怎样创建的

```js
const store = createStore(
  reducer,
  applyMiddleware(...middleware)
)
```

以下是createStore的源码，我们只看相关的一部分

```js
export default function createStore(reducer, preloadedState, enhancer) {
  if (typeof preloadedState === 'function' && typeof enhancer === 'undefined') {
    enhancer = preloadedState
    preloadedState = undefined
  }

  if (typeof enhancer !== 'undefined') {
    if (typeof enhancer !== 'function') {
      throw new Error('Expected the enhancer to be a function.')
    }

    return enhancer(createStore)(reducer, preloadedState)
  }
  ...
}
```
结合store的声明和使用，我们可以知道redux的第三个参数可以接受一个叫做增强器的东西，如果存在增强器，则直接调用增强器方法，返回新的store并增强redux的功能。而使用中间件的时候，redux将存在的applyMiddleware工厂方法作为增强器应用在了redux上。

### applyMiddleware api如何实现中间件操作的。

```js
export default function applyMiddleware(...middlewares) {
  return (createStore) => (reducer, preloadedState, enhancer) => {
    const store = createStore(reducer, preloadedState, enhancer)
    let dispatch = store.dispatch
    let chain = []

    const middlewareAPI = {
      getState: store.getState,
      dispatch: (action) => dispatch(action)
    }
    chain = middlewares.map(middleware => middleware(middlewareAPI))
    dispatch = compose(...chain)(store.dispatch)

    return {
      ...store,
      dispatch
    }
  }
}
```

applyMiddleware工厂函数对传入的中间件进行了compose操作，使中间件互相之间呈嵌套的形式，这样在中间件里的next函数就可以next()执行下去了。。。新的dispatch会从第一个中间件开始触发，这样，在我们调用store.dispatch的时候，就会将中间件走一遍了。

```js
// compose函数
export default function compose(...funcs) {
  if (funcs.length === 0) {
    return arg => arg
  }

  if (funcs.length === 1) {
    return funcs[0]
  }
  // 如果存在多个中间件，直接使用reduce方法将各个中间件嵌套起来。
  // 于是我们在使用中间件的时候就要注意了，中间件本质是一个拦截操作
  // 如果我们有两个中间件对某一个类型的action先后做了拦截，我们必须注意
  // 在createStore的时候插入中间件的顺序，中间件方法的执行是有序的。
  return funcs.reduce((a, b) => (...args) => a(b(...args)))
}
```
### 你也可以制作一个中间件

怎么样，redux的源码简单吗？简单到同学们也能自己开发中间件，现在大家自己也可以动手写自己的react中间件了。
