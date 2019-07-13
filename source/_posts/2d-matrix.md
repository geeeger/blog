---
title: 2d变换矩阵
date: 2017-10-10 17:48
tags: [ javascript, css, createjs ]
description: css变换基础
categories:
- web前端
---

2d变换矩阵总共有6个可动的参数，这六个参数分别控制不同的变换
```sh
| a  b  0 |
| c  d  0 |
| tx ty 1 |
```
a 水平缩放

b 水平拉伸

c 垂直拉伸

d 垂直缩放

tx 水平位移

ty 垂直位移

当矩阵为1的单元矩阵的时候

表明该图形没有变换

## 同等效果

- 缩放：scale(sx, sy) 等同于 matrix(sx, 0, 0, sy, 0, 0);
- 平移：translate(tx, ty) 等同于 matrix(1, 0, 0, 1, tx, ty);
- 旋转：rotate(deg) 等同于 matrix(cos(deg), sin(deg), -sin(deg), cos(deg), 0, 0);
- 拉伸：skew(degx, degy) 等同于 matrix(1, tan(degy), tan(degx), 1, 0, 0);

## 转换后的点的计算

x' = a \* x + c \* y + tx;

y' = b \* x + d \* y + ty;

## 作用

可以通过不同matrix，对不同坐标系（相对-绝对或物体-物体）间的点进行转换。常用于游戏/动画场景
