# 计算机中的浮点数

* 你确定会计算加减乘除？ **计算机二你知道么**

二进制浮点数算数标准（IEEE754），这个标准，使得浮点数在表示和计算时是不精确的

在 0.1 - 0.9 的9个小数中，有多少可以用二进制精确表示？？？

举个例子：  
0.1用二进制表示的计算方法为这样   
0.1 ✖ 2 = 0.2 取整数部分 0 得到 0.0    
0.2 ✖ 2 = 0.4 取整数部分 0 得到 0.00   
0.4 ✖ 2 = 0.8 取整数部分 0 得到 0.000  
0.8 ✖ 2 = 1.6 取整数部分 1 得到 0.0001  
0.6 ✖ 2 = 1.2 取整数部分 1 得到 0.00011  
0.2 ✖ 2 = 0.4 取整数部分 0 得到 0.000110    
0.4 ✖ 2 = 0.8 取整数部分 0 得到 0.0001100  
......

显然这个过程是无限循环的

* 精确表示与精确显示的区别

浮点数的精度丢失在每一个表达式，而不仅仅是表达式的求值结果，所以单纯的通过升级浮点数为定点数是无法解决问题的。

在数学上0.1+0.2=0.3，但是在计算机里0.1+0.2并不一定等于0.3
