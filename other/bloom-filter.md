# Bloom Filter

可以准确的判断一个元素一定不在集合中，但不能准确的判断一个元素存在于集合中（这是一个概率学问题）

用于快速的检索一个元素是否在一个很大的集合中

主要用到了位数组、哈希函数、

添加元素到集合的步骤是：
1. 准备一个足够大的位数组，将其全部初始化为零
2. 将元素经过K次哈希函数的计算（这个过程可以是并行的）到对应的k个哈希值
3. 将对应的哈希值映射到位数组中，修改对应位数组的值为1

验证元素是否存在集合中
1. 将元素进行同样的哈希计算得到的哈希值在位数字中进行匹配，
如果得到的值全位1，则该元素可能在集合中
如果得到的值中包含0，则该元素一定不在集合中

应用：
在网络爬虫里，判断一个网址是否被访问过
