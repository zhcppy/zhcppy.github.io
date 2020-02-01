# Bigdata

## Kafka
消息系统，负责将数据从一个应用程序传输到另一个应用程序

发布--订阅（pub -- sub）消息系统

* 下载安装
```bash
wget -c http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/0.11.0.0/kafka_2.11-0.11.0.0.tgz

tar -xzf kafka_2.11-0.11.0.0.tgz

cd kafka_2.11-0.11.0.0
```

* 启动服务器
启动一个**ZooKeeper**服务器
```bash
bin/zookeeper-server-start.sh  config/zookeeper.properties
```

启动**kafka**服务器
```bash
bin/kafka-server-start.sh config/server.properties
```

* 创建话题(topics)
```bash
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

bin/kafka-topics.sh --list --zookeeper localhost:2181
```

* 生产者发送消息(producer)
```bash
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test

hello, My name is zhanghang
```

* 启动消费者（consumer）
```bash
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning

hello, My name is zhanghang
```

*  设置多代理群集

## Hadoop
分布式存储

分布式分析

大数据的核心是样本==总数

HDFS：分布式文件存储

YARN：分布式资源管理

MapReduce：分布式计算

Others：利用YARN实现其他的数据处理方法

1. 数据分布在多台机器
	可靠性：每个数据块都复制到多个节点
	性能：多个节点同时处理数据

2. 计算随数据走
	网络IO数据 << 本地磁盘IO速度
	
	大数据系统会尽量地将任务分配到离数据最近的机器上运行（程序运行时，将程序及其依赖的包都复制到数据所在的机器上运行）

	代码向数据迁移，避免大规模数据时，造成大量数据迁移的情况，尽量让一段数据的计算发生在同一台机器上

3. 串行IO取代随机IO
	传输时间 << 寻道时间  
	一般数据写入以后不再修改 


## Scala
函数式编程是种编程范式，它将电脑运算视为函数的计算。

多范式的编程语言

scala闭包
闭包是一个函数，返回值依赖与声明在函数外部的一个或多个变量
闭包通常来讲可以简单的认为是可以访问一个函数里面局部变量的另一个函数

Scala函数 类中定义的函数即是方法

* 函数式编程

Scala函数也能当成值来使用  
Scala提供了轻量级的语法用力定义匿名函数，支持高阶函数，允许嵌套多层函数，并支持柯里化

特点：
	函数与其他数据类型一样，处于平等地位，可以赋值给其他变量，也可以作为参数，传入另一个函数，或者作为别的函数的返回值。

只用“表达式”，不用语句 
表达式：一个单纯的运算过程，总是有返回值。
语句：只是执行某种操作，没有返回值。

没有副作用  不修改状态 引用透明

好处： 
	代码简洁，开发快速， 接近真实语言，易于理解， 更方便的代码管理，易于“并发编程”，代码的热升级

- 函数式编程必须是纯的，不能有副作用，因为它是一种数学运算，原始目的就是求值，不做其他事情，否则就无法满足函数运算法则了。总之，在函数式编程中，函数就是一个管道。
- 柯里化：就是把一个多参数的函数转化为单参数函数。

## Hbase
构建在HDFS上的分布式列存储系统

## HDFS
分布式文件系统

## Spark
弹性分布式数据集（RDD）

RDD是一种容错的并行操作元素集合

每个Spark应用都包含一个驱动（driver）程序， 驱动器运行用户的main函数，并在集群上执行各种并行操作

RDD是一个可区分的元素集合，其包括的元素可以分布在集群各个节点上，并可以执行一些分布式并行操作

共享变量是一种可以在并行操作之间共享使用的变量

专为大数据处理而设计的快速通用的计算引擎

Transformations 是Saprk API 的一种类型，Transformation返回值是一个RDD所有的，Transformation采用的是懒策略，
如果只是将Transformation提交是不会执行计算的。

Action 是Spark API的一种类型，Action返回值不是一个RDD，而是一个scala的集合，计算只有在Action被提交的时候计算才被触发。

- 什么是MapReduce
MapReduce是一种思想，是一种分布式计算模型，是一种并行编程模式
MapReduce有两部分组成：
map 任务分解 “分而治之”
reduce 结果汇总 “迭代汇总”

#### Spark 介绍
- 可能会有讲的不对的地方，务必指出来，避免误导了大家！！！

- 给大家简单介绍一下传说中的spark，其实，这东西也没想象中的那么难，在应用上，它的具体实现还是很复杂的，

- 接下来，将从这三个方面介绍Saprk
首先是认识Spark
再就是怎么用Spark
最后是Spark streaming实战

- 认识Spark，Spark是个什么东西呢？
官方是这么说的，apache spark 是用于大规模数据处理的快速和通用引擎；
维基百科上说它是一个开源集群运算框架；
不管是框架还是引擎，对于我们来说，他就是个工具，就像手机可以打电话。
它目前是apache软件基金会旗下的顶级开源项目，就是说它很牛逼

- 它能做什么呢？
简单来说，就是帮助我们处理多种场景下的海量的数据，PB甚至EB级数据，就是能处理庞大的数据，并且效率、实时性高。

- 它有什么用呢？
分析大数据、挖掘其中的价值，从而为我们的业务发展做决策
这个怎么挖，是个技术活

- 再说一下spark的特点
它最大的特点就是快了！！！
官方给出的数据是：
        如果数据由磁盘读取，速度是Hadoop MapReduce 的10倍以上
        如果数据从内存中读取，速度可以高达100多倍
原因：
是因为它基于内存计算，并采用了先进的DAG引擎进行优化，DAG 即 有向无环如图1，数据计算步骤根据依赖关系形成DAG图
spark是易于使用的，它是采用Scala语言撰写的，它支持多种语言来使用它，包括java scala python R

- 下面是spark与hadoop关系
Spark 是借鉴于 Hadoop MapReduce 发展而来，继承了其分布式并行计算的优点，并改进了MapReduce明显的缺陷。
MapReduce计算模型太单一且计算过程中的shuffle 过程对本地磁盘的I/O消耗太大，不能适应复杂需求

当然，这些并不是说Hadoop与saprk是对立的，用hadoop就不能用spark,用Spark就不能用hadoop,
spark的还有个特点就是它可以与hadoop数据进行整合，读取已存在hadoop上的HDFS数据

- 这是Spark的体系结构
spark主要包括Spark core和在sparkc core 基础之上建立的应用框架
Spark SQL、Spark Streaming、MLlib和GraphX
根据业务需求分为用于交互式查询的SQL、
实时流处理Streaming、
机器学习MLlib、
图计算GraphX四大框架

#### Spark 架构
- spark介绍完后，接下来第二点，就是spark怎么用了？
Spark为我们提供基于scala的交互式shell，用于做实验非常合适，
因为它可以立刻就能运行得出结果，并且还能看到变量的类型，可以说相当贴心
那在开始了解spark开发之前，先感受下spark运行起来的样子

- Spark开发主要就分为这两个部分，Transformation 和 Action 

- 刚看到的是Spark开发时候的样子，

- 现在从宏观上来分析Spark的架构，简单的了解下Spark的核心原理
Spark应用程序可分两部分：Driver部分和Executor部分  

Driver 是用来运行application并创建Sparkcontext的
创建SparkContext的目的是为了构建Spark应用程序的运行环境
SparkContext负责与集群管理器通信，进行资源的申请，任务分配和监控
在Executor部分运行完毕后，Driver负责将SparkContext关闭  

SparkContext的创建过程
首先是加载配置文件，然后创建SparkEnv、TaskScheduler、
最后创建DAGScheduler，创建DAGScheduler后再调用start()方法启动
这个4个步骤就是整个SparkContext的创建过程

cluster manager 负责资源管理

Executor是Application运行在Worker Node上的一个进程，
该进程负责运行Task，并且负责将数据存在内存或者磁盘上，
每个Application都有各自独立的Executor

**RDD**
RDD，中文全称为弹性分布式数据集，英文叫：Resilient Distributed Dataset
看这有点懵，实际上也很好理解，分布式，即不限于单个节点，弹性是指可以动态调整并行计算单位的划分结构，即是为并行计算服务的

RDD是Spark的基本计算单元,也是Spark的核心数据模型，可以说是Spark最核心的东西，
RDD是对原始数据的进一步封装，可以暂时通俗的把它理解为：一坨特殊的数据

分布式存储，并发处理，自动容错等功能
它表示已被分区，不可变的并能够被并行操作的数据集合，不同的数据集格式对应不同的RDD实现。
RDD必须是可序列化的。
RDD可以cache到内存中，每次对RDD数据集的操作之后的结果，都可以存放到内存中，下一个操作可以直接从内存中输入
分区 RDD内部数据集逻辑上分片，
依赖 RDD是通过依赖关系记录更新操作，生成计算链 --> 血统

**Spark 作业和调度**
如果理解了rdd，那么Spark的调度也就很好理解，
在个里我们对rdd做join,groupBy,filter等操作，
只有当执行到filter方法时，即action算子时，就会触发提交job作业
提交之后SparkContext就会根据RDD之间的依赖关系构建DAG图

然后DAG图交给DAGScheduler进行处理，DAG调度器就会在逻辑层面上将job拆分成不同阶段具有依赖关系的任务，
我们可以看一下Spark ui是怎么做拆分的，有没有觉得很合理的样子，它就是根据我们前面讲的RDD宽窄依赖关系进行拆分的
当遇到宽依赖时划分为新的调度阶段

拆分的任务集就会提交Task调度器，Task调度器就会负责把任务一个个的分发到集群的worker节点的Executor中去运行

最后Executor收到任务后，就会以多线程的方式，按照一个任务一个线程的标准分配下去，执行任务

stage 阶段

#### spsrk streaming
sparkstreaming 具有吞吐量高、容错能力强的实时流数据处理系统，暂可以把它理解为自来水处理器

SparkStreaming接收Kafka、Flume、HDFS等各种来源的实时输入数据，进行处理后，处理结果保存在HDFS、Databases等各种地方

SparkStreaming接收这些实时输入数据流，会将它们按批次划分，然后交给Spark引擎处理，生成按照批次划分的结果流
Spark Streaming在内部的处理机制是，接收实时流的数据，并根据一定的时间间隔拆分成一批批的数据，然后通过Spark Engine处理这些批数据，最终得到处理后的一批批结果数据

在sparkstreaming中，连续的数据流是用DStream来表示的

SparkStreaming提供了表示连续数据流的、高度抽象的被称为离散流的DStream。DStream本质上表示RDD的序列。任何对DStream的操作都会转变为对底层RDD的操作

Spark Streaming对内部持续的实时数据流的抽象描述，即我们处理的一个实时数据流

Spark Streaming 是将流式计算分解成一系列短小的批处理作业。
批处理引擎就是Spark，也就是把Spark Streaming的输入数据按照batch size（如1秒）分成一段一段的数据DStream（Discretized Stream）
每一段数据都转换成Spark中的RDD，然后将Spark Streaming中对DStream的Transformation操作变为针对Spark中对RDD的Transformation操作，将RDD经过操作变成中间结果保存在内存中。
整个流式计算根据业务的需求可以对中间的结果进行叠加，或者存储到外部设备。

Spark Streaming 是一个对实时数据进行高通量、容错处理的流式处理系统，可以对多种数据源进行类似Map、Reduce和Join等复杂操作，并将结果保存到外部系统，数据库或应用到实时仪表盘
