---
title: 验证大陆身份证号
date: 2019-08-09 14:14:41
tags: [ javascript, chrome, safari, browser ]
description: 论如何验证大陆身份证号
categories:
- javascript
---

本篇只是记录，为实际业务所碰到的问题。

实现了一个前端的大陆身份证验证（网上cv的）。

问：为毛没验证15位身份证？

答：因为1999年起开始执行18位标准，现在已经过去了20年。

实现代码(非本人实现)：

```javascript
const validateIdCard = function (id) {
    const format = /^(([1][1-5])|([2][1-3])|([3][1-7])|([4][1-6])|([5][0-4])|([6][1-5])|([7][1])|([8][1-2]))\d{4}(([1][9]\d{2})|([2]\d{3}))(([0][1-9])|([1][0-2]))(([0][1-9])|([1-2][0-9])|([3][0-1]))\d{3}[0-9xX]$/;

    // 号码规则校验

    if (!format.test(id)) {
        return false;
    }

    // 区位码校验
    // 出生年月日校验  前正则限制起始年份为1900;
    const year = id.substr(6, 4);
    // 身份证月
    const month = id.substr(10, 2);
    // 身份证日
    const date = id.substr(12, 2);
    // 身份证日期时间戳date
    const time = Date.parse(month + '-' + date + '-' + year);
    // 当前时间戳
    const now_time = Date.parse(new Date());
    // 身份证当月天数
    const dates = new Date(year, month, 0).getDate();
    if (time > now_time || date > dates) {
        // 出生日期不合规
        return false;
    }

    // 校验码判断
    // 系数
    const c = [
        7,
        9,
        10,
        5,
        8,
        4,
        2,
        1,
        6,
        3,
        7,
        9,
        10,
        5,
        8,
        4,
        2
    ];
    // 校验码对照表
    const b = [
        '1',
        '0',
        'X',
        '9',
        '8',
        '7',
        '6',
        '5',
        '4',
        '3',
        '2'
    ];
    const id_array = id.split('');

    let sum = 0;
    for (let k = 0; k < 17; k++) {
        sum += parseInt(id_array[k], 10) * parseInt(c[k], 10);
    }

    if (id_array[17].toUpperCase() !== b[sum % 11].toUpperCase()) {
        // 身份证校验码不合规
        return false;

    }

    return true;
}
```

[实现原理](https://zh.wikisource.org/zh-hans/GB_11643-1999_%E5%85%AC%E6%B0%91%E8%BA%AB%E4%BB%BD%E5%8F%B7%E7%A0%81)

