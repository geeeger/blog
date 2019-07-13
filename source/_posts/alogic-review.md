---
title: 基础排序算法复习
date: 2018-01-18 13:28
tags: [ javascript, arithmetic, 算法 ]
description: 复习算法
categories:
- 算法
---


||最差时间分析|平均时间复杂度|稳定度|空间复杂度|
|:------:|:------:|:------:|:------:|:------:|
|冒泡排序|O(n^2)|O(n^2)|稳定|O(1)|
|快速排序|O(n^2)|O(n*log2n)|不稳定|O(log2n)~O(n)|
|选择排序|O(n^2)|O(n^2)|不稳定|O(1)|
|归并排序|O(n^2)|O(n*log2n)|不稳定|O(n)|
|插入排序|O(n^2)|O(n^2)|稳定|O(1)|
|希尔排序|O(n^2)|O(nlogn)|不稳定|O(1)|

## 冒泡排序

他是最慢的排序，但也是最容易实现的排序算法

```js
/**
 * 他是最慢的排序，但也是最容易实现的排序算法
 */
/*
算法原理：将前后每两个数进行比较，较大的数往后排，一轮下来最大的数就排到最后去了。然后再进行第二轮比较，第二大的数也排到倒数第二了，以此类推：
 */



function bubbleSort(arrs) {
    for (var outer = 0; outer < arrs.length - 1; outer++) {
        for (var inner = 0; inner < arrs.length - 1 - outer; inner++) {
            if (arrs[inner] > arrs[inner + 1]) {
                var temp = arrs[inner];
                arrs[inner] = arrs[inner + 1];
                arrs[inner + 1] = temp;
            }
        }
    }
}
```

## 选择排序
原理就是带着从第一个开始，寻找第一个以后的最小数，和第一个进行交换

```js
function selection(a) {
    var min;
    var tmp;
    for (var out = 0; out < a.length - 1; out++) {
        min = out;
        for (var inner = out + 1; inner < a.length; inner++) {
            if (a[inner] < a[min]) {
                min = inner;
            }
        }
        tmp = a[out];
        a[out] = a[min]
        a[min] = tmp;
    }
}
```

## 快速排序

处理大数据集最快的算法之一。是一种分而治之的算法。 原理，通过递归将数据分解为包涵较小元素和较大元素的不同子序列，不停重复，知道所有数据排序完成。

### 算法描述
+ 选择一个基准元素，将列表分成两个子序列
+ 对列表重新排序，将所有小于基准值的元素放在基准值钱，所有大于基准值的元素放在基准值后
+ 分别对较小元素的子序列和较大元素的子序列重复步骤1和2

```js
function qSort(list) {
    if (list.length === 0) {
        return [];
    }
    var lesser = [];
    var greater = [];
    var privot = list[0];
    for (var i = 1; i < list.length; i++) {
        if (list[i] < privot) {
            lesser.push(list[i]);
        }
        else {
            greater.push(list[i]);
        }
    }
    return qSort(lesser).concat(privot, qSort(greater));
}
```

## 归并排序

+ 分治思想
+ 将有序子序列合并，得到完全有序的序列
    * 先使每个子序列有
    * 再使子序列段间有序
+ 若将两个有序表合并成一个有序表，称之为二路归并


自上而下最好记
+ 先将数组一半一半分割成一堆最小数组
+ 不断将一半一半分割的左右数组合并
+ 返回最终结果


```js
// 自低向上的归并,非递归实现

function mergeSort(arr) {
    if (arr.length < 2) {
        return;
    }
    var step = 1;
    var left;
    var right;
    while (step < arr.length) {
        left = 0;
        right = step;
        while (right + step <= arr.length) {
            mergeArrays(arr, left, left + step, right, right + step);
            left = right + step;
            right = left + step;
        }
        if (right < arr.length) {
            mergeArrays(arr, left, left + step, right, arr.length);
        }
        step *= 2;
    }
}

function mergeArrays(arr, startLeft, stopLeft, startRight, stopRight) {
    var rightArr = new Array(stopRight - startRight + 1);
    var leftArr = new Array(stopLeft - startLeft + 1);
    var k = startRight;
    for (var i = 0; i < rightArr.length - 1; i++) {
        rightArr[i] = arr[k];
        k++;
    }
    k = startLeft;
    for (var i = 0; i < leftArr.length - 1; i++) {
        leftArr[i] = arr[k];
        k++;
    }
    rightArr[rightArr.length - 1] = Infinity; // 哨兵值
    leftArr[leftArr.length - 1] = Infinity; // 哨兵值
    var m = 0;
    var n = 0;
    for (var k = startLeft; k < stopLeft; k++) {
        if (leftArr[m] <= rightArr[n]) {
            arr[k] = leftArr[m];
            m++;
        }
        else {
            arr[k] = rightArr[n];
            n++;
        }
    }
}
```

```js
// 自上而下的形式
function mergeSort(arr) {
    var len = arr.length;
    if(len < 2) {
        return arr;
    }
    var middle = Math.floor(len / 2);
    var left = arr.slice(0, middle);
    var right = arr.slice(middle);
    return merge(mergeSort(left), mergeSort(right));
}

function merge(left, right) {
    var result = [];

    while (left.length > 0 && right.length > 0) {
        if (left[0] <= right[0]) {
            result.push(left.shift());
        } else {
            result.push(right.shift());
        }
    }

    while (left.length)
        result.push(left.shift());

    while (right.length)
        result.push(right.shift());

    return result;
}
```

## 插入排序

简单理解，就是当年老师把学生按身高排队
+ 老师比较了一下第一个同学和第二个同学的高度，发现第二个同学比较低，于是让他排在第一排
+ 于是第一个同学和第二个同学交换了位置
+ 老师看了一眼第三个同学，和第一第二个同学比较了一下高度，发现第三个同学比较矮，于是让第三个同学排在了第一排
+ 重复这个过程

这个类比可能不全面，大家想象一下打扑克摸牌理牌的过程。

```js
function insertSort(arr) {
    var temp;
    var inner;
    for (var outer = 1; outer < arr.length; outer++) {
        temp = arr[outer];
        inner = outer;
        while (inner > 0 && (arr[inner - 1] >= temp)) {
            arr[inner] = arr[inner - 1];
            inner--;
        }
        arr[inner] = temp;
    }
}
```

## 希尔排序

+ 设计初始步长，开始比较
+ 若初始步长为4 即把第5个元素和第1个元素进行排序， 第6个元素和第2个元素进行排序 以此类推，
+ 步长慢慢缩短
+ 若初始步长为1，其实就是标准的插入排序


```js
function shellSort(arr) {
    var len = arr.length;
    var gap = 1;
    // 设置动态步长，不使用设计步长
    while (gap < len / 3) {
        gap = 3 * gap + 1;
    }
    while (gap >= 1) {
        for (var i = gap; i < len; i++) {
            for (var j = i; j >= gap && arr[j] < arr[j - gap]; j -= gap) {
                var temp = arr[j];
                arr[j] = arr[j - gap];
                arr[j - gap] = temp;
            }
        }
        gap = (gap - 1) / 3;
    }
}

/*
[ 8, 10, 10, 6, 7, 1, 9, 3, 9, 0 ]
7和8比较，换位
[ 7, 10, 10, 6, 8, 1, 9, 3, 9, 0 ] 4
1和10比较，换位
[ 7, 1, 10, 6, 8, 10, 9, 3, 9, 0 ] 4
9和10比较，换位
[ 7, 1, 9, 6, 8, 10, 10, 3, 9, 0 ] 4
3和6比较，换位
[ 7, 1, 9, 3, 8, 10, 10, 6, 9, 0 ] 4
9和8比较不换位，8和7比较，不换位， 0和10比较换位
[ 7, 1, 9, 3, 8, 0, 10, 6, 9, 10 ] 4
0和1比较换位
[ 7, 0, 9, 3, 8, 1, 10, 6, 9, 10 ] 4
缩减gap = (gap - 1) / 3,进入插入排序模式
[ 0, 7, 9, 3, 8, 1, 10, 6, 9, 10 ] 1
[ 0, 7, 3, 9, 8, 1, 10, 6, 9, 10 ] 1
[ 0, 3, 7, 9, 8, 1, 10, 6, 9, 10 ] 1
[ 0, 3, 7, 8, 9, 1, 10, 6, 9, 10 ] 1
[ 0, 3, 7, 8, 1, 9, 10, 6, 9, 10 ] 1
[ 0, 3, 7, 1, 8, 9, 10, 6, 9, 10 ] 1
[ 0, 3, 1, 7, 8, 9, 10, 6, 9, 10 ] 1
[ 0, 1, 3, 7, 8, 9, 10, 6, 9, 10 ] 1
[ 0, 1, 3, 7, 8, 9, 6, 10, 9, 10 ] 1
[ 0, 1, 3, 7, 8, 6, 9, 10, 9, 10 ] 1
[ 0, 1, 3, 7, 6, 8, 9, 10, 9, 10 ] 1
[ 0, 1, 3, 6, 7, 8, 9, 10, 9, 10 ] 1
[ 0, 1, 3, 6, 7, 8, 9, 9, 10, 10 ] 1
[ 0, 1, 3, 6, 7, 8, 9, 9, 10, 10 ]
 */
```
