---
title: laravel开发第一天
date: 2019-09-20 16:00:00
tags: [ php, laravel, grpc, protobuf ]
description: 进入后端领域的第一天
categories:
- php
---

本篇为记录学习的第一天。

经过漫长的业务折磨后，突然记起来贵人所说过的话：『我建议你可以学一学后端。』在自我放弃将近两个月后，我决定参加他们的新项目，以了解后端所需的业务开发知识。

### step 1

这一阶段经历了三天，包括两天周末，我了解了以下知识

+ homebrew安装及包安装
+ php-fpm守护程序
+ mac下如何安装和更新php
+ laravel是什么
+ composer是什么,以及怎么用
+ docker怎么安装
+ pecl是什么
+ 什么是PSR-0,PSR-1,PSR-2,PSR-4,PSR-8,PSR-12等
+ php如何使用vscode调试
+ 如何自行编译php扩展
+ xdebug扩展是什么，怎么配置
+ yaf是什么，怎么安装其扩展
+ laravel中Request实例的validate是如何挂载的
+ composer如何加载私有库的包

### step 2

这一阶段经历了四天，我了解了以下知识

+ SocialiteProviders的包是干什么的
+ 怎么写一个SocialiteProviders的Provider
+ laravel自带命令行工具artisan的各种创建模板命令，迁移命令，生成model命令等
+ 编译和安装grpc php扩展，composer依赖
+ 编译和安装protobuf php扩展，composer依赖
+ php有枚举类么
+ php静态成员怎么调
+ php的魔术方法
+ 编译和安装SPL_Types php扩展
+ SPL_Types不支持PHP7.0，怎么办，非官方源码编译，或者其兼容的composer模块
+ 为什么我实现的OAuth Provider在跳转时对方报参数错误（参数写错）
+ 我们的网站到底怎么实现联合登录的
+ go组给的sdk为什么在我导师封装以后直接导致php程序crash
    + protoc 翻译过来的proto协议 消息继承了google/protobuf/internal/message
    + 其子类及父类本身不允许extends,其父类不允许被用户实例化
+ app上的三方登录是怎么回事
+ 怎么实现另一个OAuth Provider
+ laravel的validator到底怎么写好看[文章](https://www.sitepoint.com/data-validation-laravel-right-way/)
+ 群里说composer引入go给的两个sdk正常,引入三个就不正常是为毛
    + 原因是sdk包的命名空间及文件重叠了，其中一个sdk没有使用某名称一致的类
+ composer到底怎么自动加载包和对包生成索引的

### step 3

接了其他前端需求，暂时从php抽身了，还是觉得自己学习进度和工作进度太慢，没有任何实质性产出，很尴尬，跟负责人说请他把任务摊派给其他人。