# P2P

在以太坊的p2p包下，discover包下的udp主要负责节点发现。以太坊的节点发现又是基于kademlia协议。

#### kademlia

[kad详细解读](http://www.yeolar.com/note/2010/03/21/kademlia/)

简单说来，kad中，每个节点由特定ID为唯一标识符。并且由ID决定K桶和两节点之间的逻辑距离。

ID由二进制表示，ID长度有几位，K桶数量就为几。K桶的划分满足，第n个K桶的节点前n-1位与自己ID的前n-1位是相同的。如ID长度为3，那么K桶数量为3，自己的ID为110，那么自己的K桶划分为前0位相同(0xx）、前1位相同(10x),前2位相同(11x)这样的三个K桶。显然，在这样的分布中，满足0xx的节点就会有很多，但满足11x的节点只有111。然后两个节点之前的逻辑距离为ID的异或值，越相近的节点，异或值越小，越远的节点，异或值越大。

另外，Kademlia 协议包括四种远程 RPC 操作：PING、STORE、FIND_NODE、FIND_VALUE。这些在上面的链接中都有也更详细。尤其是数据存放需要的基本步骤，都有相应提到。

#### 以太坊的kad

以太坊的kad与上面标准的kad略有不同。

先撸代码吧。

````
bucketSize      = 16 // Kademlia bucket size
// We keep buckets for the upper 1/15 of distances because
// it's very unlikely we'll ever encounter a node that's closer.
hashBits          = len(common.Hash{}) * 8
nBuckets          = hashBits / 15       // Number of buckets
bucketMinDistance = hashBits - nBuckets // Log distance of closest bucket
````

k桶数量nBuckets，（定为ID长度256(hash长度32byte * 8bit/byte)）/ 15。

k桶大小bucketSize，即每个k桶中的节点最大数量。

节点ID的计算方式(由公钥生成)

```
//encPubkey取hash
func (e encPubkey) id() enode.ID {
	return enode.ID(crypto.Keccak256Hash(e[:]))
}
//pubkey -> encpubkey
func encodePubkey(key *ecdsa.PublicKey) encPubkey {
	var e encPubkey
	math.ReadBits(key.X, e[:len(e)/2])
	math.ReadBits(key.Y, e[len(e)/2:])
	return e
}
```

【17个桶，每个桶中最多16个节点】
每30分钟刷新一次桶
重新验证数据的间隔时间为10秒
拷贝节点的时间间隔为30秒

种子总数为30个
种子最大的年纪是5天

+ 桶的基本结构
```
type Table struct {
	mutex   sync.Mutex        // protects buckets, bucket content, nursery, rand
	buckets [nBuckets]*bucket // index of known nodes by distance
	...
}
```

```
// bucket contains nodes, ordered by their last activity. the entry
// that was most recently active is the first element in entries.
type bucket struct {
   entries      []*node // live entries, sorted by time of last contact
   replacements []*node // recently seen nodes to be used if revalidation fails
   ips          netutil.DistinctNetSet
}
```

buckets是所有桶，是一个定长数组，其中，(0<index<nBuckets)的index代表index桶。然后节点的id经过计算映射到某个桶。桶里的节点们又是一个数组，entries数组中为优先可用的节点，他们按上一次联系的时间排序，最最近联系的节点排在数组的最前面。如果entries中某节点在revalidation时失败了，会从replacements中找出某个来代替..

```
//增。如果对应的桶b, b.entries的长度没超过最大数量的话，就增加到entries中，否则增加到replacements中
func (tab *Table) add(n *node) {
   if n.ID() == tab.self.ID() {
      return
   }
   tab.mutex.Lock()
   defer tab.mutex.Unlock()
   b := tab.bucket(n.ID())
   if !tab.bumpOrAdd(b, n) {
      // Node is not in table. Add it to the replacement list.
      tab.addReplacement(b, n)
   }
}

//删，找到node对应的桶，然后从桶中把节点删除了
func (tab *Table) delete(node *node) {
	tab.mutex.Lock()
	defer tab.mutex.Unlock()

	tab.deleteInBucket(tab.bucket(node.ID()), node)
}

//查，查呢是返回所有桶中距离target最近的nresults个节点
func (tab *Table) closest(target enode.ID, nresults int) *nodesByDistance {
	// This is a very wasteful way to find the closest nodes but
	// obviously correct. I believe that tree-based buckets would make
	// this easier to implement efficiently.
	close := &nodesByDistance{target: target}
	for _, b := range &tab.buckets {
		for _, n := range b.entries {
			close.push(n, nresults)
		}
	}
	return close
}
```

+ 主线逻辑操作

```
func (tab *Table) loop() {
  ...
  loop:
	for {
		select {
		case <-refresh.C:  //定时刷新，
			tab.seedRand() //更新随机种子
			if refreshDone == nil {
				refreshDone = make(chan struct{})
				go tab.doRefresh(refreshDone)  //进行刷新，刷新完成往refreshDone通道中通知
			}
		case req := <-tab.refreshReq: //上层请求刷新，上层有可能需要知道刷新完成时间，故req通道用于通知刷新完成
			waiting = append(waiting, req)  //记录下所有的刷新请求通道
			if refreshDone == nil {
				refreshDone = make(chan struct{})
				go tab.doRefresh(refreshDone)
			}
		case <-refreshDone:  //刷新完成后，关闭所有请求通道，通知上层已刷新完成
			for _, ch := range waiting {
				close(ch)
			}
			waiting, refreshDone = nil, nil //清空waiting数组，和refreshDone通道
		case <-revalidate.C:
			go tab.doRevalidate(revalidateDone)
		case <-revalidateDone:
			revalidate.Reset(tab.nextRevalidateTime())
		case <-copyNodes.C:
			go tab.copyLiveNodes()
		case <-tab.closeReq:
			break loop
		}
	}
  ...
}

//刷新方法
func (tab *Table) doRefresh(done chan struct{}) {
  defer close(done)
  ...
  
  //通过自己为target去找neighbor，前提是需要自己有secp256k1字段，v4版本的node里是含有secp256k1的，即v4版本是满足这个if条件。load后key中的值为node的公钥
  var key ecdsa.PublicKey
  if err := tab.self.Load((*enode.Secp256k1)(&key)); err == nil {
	tab.lookup(encodePubkey(&key), false)
  }
  
  
  //⭐️通过随机target去找neighbor。这里的疑问是注释中提到为什么不使用kad本来刷新的方式是因为findnode taget是512bit,这里为什么是512bit? (是因为findnode target是公钥，公钥长度是64byte/512bit) 后半句说不容易生成一个属于所选桶的sha3前镜像，kad本来刷新的方式是选择最近最少使用的桶，所以这里的意思是知道桶了，但是node的ID是经过hash生成的，hash的范围确定，但倒回去找ID就很复杂的意思吗
// The Kademlia paper specifies that the bucket refresh should
// perform a lookup in the least recently used bucket. We cannot
// adhere to this because the findnode target is a 512bit value
// (not hash-sized) and it is not easily possible to generate a
// sha3 preimage that falls into a chosen bucket.
// We perform a few lookups with a random target instead.
  for i := 0; i < 3; i++ {
	 var target encPubkey
	 crand.Read(target[:])
	 tab.lookup(target, false)
  }
}
```

```
//下面看一下关键方法lookup
func (tab *Table) lookup(targetKey encPubkey, refreshIfEmpty bool) []*node {
	var (
		target         = enode.ID(crypto.Keccak256Hash(targetKey[:]))  //targetid：由公钥进行hash得来
		asked          = make(map[enode.ID]bool)  //保存询问过的节点，以免重复询问
		seen           = make(map[enode.ID]bool)  //保存回复过的节点，防止询问的节点多次回复
		reply          = make(chan []*node, alpha) //节点回复的通道，alpha为并发量，每次三个
		pendingQueries = 0   //待定的查询数量，即询问了 但没回复的数量
		result         *nodesByDistance  //查询结果
	)
	//将自己列为询问过的节点
	asked[tab.self.ID()] = true

    //将现有的k桶节点们填充到result中
	for {
		tab.mutex.Lock()
		//从自己的所有桶中找出离target最近的bucketSize个节点
		result = tab.closest(target, bucketSize)
		tab.mutex.Unlock()
		//如果桶中有节点或者refreshIfEmpty为false，跳出循环
		if len(result.entries) > 0 || !refreshIfEmpty {
			break
		}
		//如果k桶中无节点，则请求刷新(doRefresh -> 从种子节点中出发..)
		<-tab.refresh()
		//请求一次刷新，将refreshIfEmpty置为false,防止一直无节点，一直在这里循环，相当于这个for循环最多只执行两次
		refreshIfEmpty = false
	}
	

	for {
		//向近的节点询问节点，询问过的就不再询问，并且每次询问的节点数<alpha,即每次只询问最近的alpha个节点。之前一直卡在为什么外层要for循环，难道不是每次问的都是相同的吗？还真的不是..要是相同的话，pendingQueries的值就不会++，这个询问for循环就不会再进行了，然后等回答完毕这个方法就完毕了。之所以桶里的前alpha个会不一样，是因为在后面从reply中读出的为问到的节点们，然后添加到本桶里的时候会影响整个排序，result中的应该是最近的就在前面。所以这个就是不断问到新的节点后，不断查询到离自己比较近的节点。到没有最近的节点后，就不再询问。
		for i := 0; i < len(result.entries) && pendingQueries < alpha; i++ {
			n := result.entries[i]
			if !asked[n.ID()] {
				asked[n.ID()] = true
				pendingQueries++
				//向节点n询问targetKey的节点们
				go tab.findnode(n, targetKey, reply)
			}
		}
		//所有人都回复了，就不再询问了
		if pendingQueries == 0 {
			// we have asked all closest nodes, stop the search
			break
		}
		
		//<-reply是最迷惑的，这个是每次从reply中读出一个回复，一个回复为一个节点回复的他的桶节点们，然后range它的桶节点，添加到本桶中
		// wait for the next reply
		for _, n := range <-reply {
			if n != nil && !seen[n.ID()] {
				seen[n.ID()] = true
				//result.push方法，result中数组的长度为bucketSize，且按离target的距离排序，有点像距离最“近”堆排序..
				result.push(n, bucketSize)
			}
		}
		//有过一次回复，pendingQueries递减
		pendingQueries--
	}

	return result.entries
}
```

```
//findnode方法
func (tab *Table) findnode(n *node, targetKey encPubkey, reply chan<- []*node) {
	//从db中读出向n节点查询出错的次数(这个出错次数应该会影响n节点的名誉吧)
	fails := tab.db.FindFails(n.ID())
	//调用上层通信向n节点发出查询消息
	r, err := tab.net.findnode(n.ID(), n.addr(), targetKey)
	
	//这里看着是直接就返回了消息和错误..看样子tab.net.findnode是同步的..
	//如果返回错误或者节点数量为0，都视为失败，出错次数fails++并更新db。如果fails次数达到一定，则会从tab中删除这个节点
	if err != nil || len(r) == 0 {
		fails++
		tab.db.UpdateFindFails(n.ID(), fails)
		log.Trace("Findnode failed", "id", n.ID(), "failcount", fails, "err", err)
		if fails >= maxFindnodeFailures {
			log.Trace("Too many findnode failures, dropping", "id", n.ID(), "failcount", fails)
			tab.delete(n)
		}
	} else if fails > 0 {
		//如果这次成功了，以前失败过，则可抵消以前的出错次数
		tab.db.UpdateFindFails(n.ID(), fails-1)
	}

	// 尽可能添加多个node,尽管他们之中可能有些不在线，但是我们会在revalidation时删除他们
	for _, n := range r {
		tab.add(n)
	}
	//回复成功
	reply <- r
}
```

revalidation的代码就不粘贴了，做的事情是，随机一个桶，找出这个桶里最后一个节点，然后向这个节点发出ping，如果这个节点回复了，就把他移到桶的最前方。如果没回复，就这个桶里的当前情况要么删除它要么替换它。

⭐️其实还是有疑问的，就是虽然桶的index是确定的，但target是随机的，那么每次target随机，各个桶里节点跟target的距离就会不一样，各个桶里的节点是不是会变化很大。

🤓除了第一个桶，其余桶里存放的节点是与自身的逻辑距离是固定的

	// bucket returns the bucket for the given node ID hash.
	func (tab *Table) bucket(id enode.ID) *bucket {
		// 计算对数距离
		d := enode.LogDist(tab.self.ID(), id)
		if d <= bucketMinDistance {
			// 距离自身较近的节点
			return tab.buckets[0]
		}
		// 距离自身固定距离的节点
		return tab.buckets[d-bucketMinDistance-1]
	}
	
这里是我写的一个测试

	func TestBuckets(t *testing.T) {
		buckets := [nBuckets]int{}
		for i := 0; i < 10000; i++ {
			key1, _ := crypto.GenerateKey()
			ID1 := encodePubkey(&key1.PublicKey).id()
			key2, _ := crypto.GenerateKey()
			ID2 := encodePubkey(&key2.PublicKey).id()
			d := enode.LogDist(ID1, ID2)
			if d <= bucketMinDistance {
				buckets[0] += 1
			} else {
				buckets[d-bucketMinDistance-1] += 1
			}
		}
		fmt.Println(buckets)
		// [0 1 0 2 2 3 5 7 23 34 64 158 353 623 1246 2495 4984]
		// 没想到这个数字会下降的如此之快！！！
	}
	
	这里是向桶中添加节点过程
	// bumpOrAdd moves n to the front of the bucket entry list or adds it if the list isn't
	// full. The return value is true if n is in the bucket.
	func (tab *Table) bumpOrAdd(b *bucket, n *node) bool {
		// 判断桶里是否存在该节点，如果存在则移至桶最前面
		if b.bump(n) {
			return true
		}
		// 如果桶满了就直接返回了，
		// 这里还有一个条件！每个桶中节点的IP地址最多只能有两个是在同一网段下的
		// 还有就是，相邻网段也属于同一网段，也会被丢弃掉 (p2p/netutil/net_test.go TestDistinctNetSet)
		if len(b.entries) >= bucketSize || !tab.addIP(b, n.IP()) {
			return false
		}
		b.entries, _ = pushNode(b.entries, n, bucketSize)
		b.replacements = deleteNode(b.replacements, n)
		n.addedAt = time.Now()
		if tab.nodeAddedHook != nil {
			tab.nodeAddedHook(n)
		}
		return true
	}
因为桶里存放的节点的逻辑距离是固定的，又因为每个桶的大小（16）是固定的，只有当桶中有空位时，节点才会被添加进桶。所以我的结论是，桶里节点的变化不会很大，顺序可能会经常变，随机目标是为了查找新的距离自身近的节点（即为了查找前大半部分桶中的节点），再就是为了保持桶的活性（即桶后小半部分桶中的节点）。

##### udp 

kad使用udp进行通信。作为tab.net。好玩的是上面的tab.net.findnode如何实现同步的。

```
func (t *udp) findnode(toid enode.ID, toaddr *net.UDPAddr, target encPubkey) ([]*node, error) {
   // If we haven't seen a ping from the destination node for a while, it won't remember
   // our endpoint proof and reject findnode. Solicit a ping first.
   if time.Since(t.db.LastPingReceived(toid)) > bondExpiration {
      t.ping(toid, toaddr)
      t.waitping(toid)
   }

   nodes := make([]*node, 0, bucketSize)
   nreceived := 0
   errc := t.pending(toid, neighborsPacket, func(r interface{}) bool {
      reply := r.(*neighbors)
      for _, rn := range reply.Nodes {
         nreceived++
         n, err := t.nodeFromRPC(toaddr, rn)
         if err != nil {
            log.Trace("Invalid neighbor node received", "ip", rn.IP, "addr", toaddr, "err", err)
            continue
         }
         nodes = append(nodes, n)
      }
      return nreceived >= bucketSize
   })
   t.send(toaddr, findnodePacket, &findnode{
      Target:     target,
      Expiration: uint64(time.Now().Add(expiration).Unix()),
   })
   return nodes, <-errc
}
```

上面可以看到findnode是发出了一个findnode包，然后等回复会回调pending的callback。但这个方法确实是同步的，就是说返回的话，就说明收到了回复，callback也回调了。是怎么做到的呢。真的很好玩，利用了errc通道。就是最后一句`return nodes, <-errc`，只有errc通道读出消息来，才会返回数据，这也是callback设计的精妙之处吧。这么设计真的是精妙，get到了。

udp处理的工作主要是进行通信。通信类型有两组，(发ping - 回pong)、(发findnode - 回neighbors)
