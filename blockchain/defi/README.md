# DeFi

## Compound

抵押Token获得CToken，

## Uniswap

去中心化交易所

通过以太坊智能合约实现

公式 eth_liquidity_pool * token_liquidity_pool = constant_product

流动性提供者：提供资金池交易对，如 10ETH/1000DAI，那么eth_price = token_liquidity_pool / eth_liquidity_pool

当其它交易所的价格发生变化后，则该交易所与Uniswap之间的价格差将产生套利机会，当套利者执行有利可图的交易，使Uniswap交易所与更广阔的市场重合时，流动性提供者将从Uniswap交易所费用中受益。

流动性提供者的实际收益是价格差带来的永久损失与交易所交易的累积费用之间的平衡

## Curve

基于以太坊的交换协议，去中心化交易所，可以提供稳定的稳定币交易

类似于uniswap，但是curve的算法是专门为稳定币交换设计的，可以实现较低的滑点和较低的手续费

在提供流动性的同时，curve流动性提供者不仅可以获得交易费用，还可以从其它DeFi协议中获得额外的收益

curve使用与uniswap类似的AMM自动做市商机制，使用算法模仿传统做市商的交易行为，并使用智能合约作为交易对手

curve发行CRV治理Token以奖励流动性提供者

## Synthetix

基于以太坊的去中心化合成资产发行协议。

合成资产又Synthetix网络通证（SNX）担保，只要将SNX在智能合约中锁定，即可发行合成资产（Synths）。

抵押池模型使用户可以直接使用智能合约在Synth之间执行转换，而无需交易对手。

这种机制解决了DEX遇到的流动性和滑点问题，Synthetix当前支持合成法定货币，加密货币（多头和空头）和大宗商品。

系统根据用户的贡献，将产生与Synthetix.Exchange交易所中的交易费按比例付给SNX持有者，从而鼓励用户持有SNX。

SNX的价值来源于使用网络的权利，和收取因Synth交易产生的费用。

持有SNX可以获得交易手续费和通胀政策产生的奖励


* 合成资产由抵押SNX或ETH的750%价值所产生
* 正向合成资产与对标资产正相关，反向合成资产与对标的资产呈负相关
* 反向合成资产有三个关键数据：入场价、下限和上限，所以反向合成资产是有交易范围的，这将限制用户在反向资产上获得的最大盈亏，
  当达到限制时，通证的汇率将被冻结并清算头寸。发生冻结或清算后，这些反向合成资产只能以固定值在synthetix交易所进行兑换，然后重新设置上下限
* 合成资产使交易者可以对资产进行价格敞口，而无需实际持有基础资产，合成资产使得交易者以更低的门槛进入市场
* 抵押创建合成资产，即表示抵押者承担了债务，并且债务水平会根据全球债务池中合成资产的总价值发生动态变化，从而导致抵押者所欠债务随着价值的变化而波动
* 合成资产的创建、管理和销毁是通过Mintr实现，合成资产的交易是通过Synthetix.exchange来完成的
* 合成资产在Synthetix.exchange上进行交易时是无需对手方的，交易的本质是销毁sell资产，铸造buy资产，此时buy资产的总量也会增加，此时债务会转变
* SNX的市值对应了Synthetix.exchange中sUSD的最大总量
* 

### 源码分析

AddressResolver：地址解析，作用是可以通过名称找到对应的合约地址，方便升级合约， https://fravoll.github.io/solidity-patterns/proxy_delegate.html
EternalStorage: 永恒的存储，用于存储数据，方便升级合约时不用迁移数据，https://fravoll.github.io/solidity-patterns/eternal_storage.html
EtherCollateral: ETH抵押，存在利息，没有交易费或SNX股权奖励，
ExchangeRates：存储最新的Synth汇率，三分钟更新一次，也负责逆向合成资产的价格
ExchangeState：
Exchanger：执行exchange（兑换）和settle（结算）功能
ExternStateToken：用于存储余额和token信息
FeePool：
FeePoolEternalStorage
FeePoolState
FlexibleStorage
IssuanceEternalStorage
Issuer
LimitedSetup
Liquidations
MixinResolver
MixinSystemSettings
MultiCollateralSynth
Owned
Pausable
Proxy
ProxyERC20
Proxyable
PurgeableSynth
ReadProxy
RewardEscrow
RewardsDistribution
RewardsDistributionRecipient
SelfDestructible
StakingRewards
State
SupplySchedule
Synth
SynthUtil
Synthetix
SynthetixEscrow
SynthetixState
SystemSettings
SystemStatus
TokenState
TradingRewards


* 通正：Token、代币、令牌、信令
* 头寸：款项、资金
* 敞口：开盘的意思，指买入一种货币，同时卖出另一种货币的行为；指在金融活动中存在金融风险的部位以及受金融风险影响的程度

# 金融逻辑

黄金、石油、股票、期货、债券、

如果看涨，那么就是可以买入持有更多，这个叫做多
如果看跌，那么就是可以借来更多，然后再卖出，最后在到期后买回归还，这个叫做空

对冲基金的方法有做空

CDS 信贷违约掉期

证券不是金融衍生品，股票、债券都是证券，它们都可以在市场上自由流通的，来回买卖。

借的资产做成债券


option 期权
Futures 期货 | Forward 远期
swap 互换/对赌协议
swaption 对赌期权
compliance 合规
trader 交易员
Foundation 慈善基金会
lock-up period 对冲基金投资人在这个期间内不可撤资
counter party 对家
alpha 衡量基金经理业绩的标准，（投资经理赚的收益-大盘收益）

对冲基金，对赌协议，零和游戏，
