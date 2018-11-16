# BipaySDK iOS 开发说明

## 5分钟入门（Five-minute Introduction）
####  1.下载SDK
> [SDK1.0.3下载地址](https://bitrade.oss-cn-hongkong.aliyuncs.com/bifu_sdk/Bifu_iOS_SDK.zip)

#### 2.将SDK 导入项目
##### 导入动态库

>将libbipay.dylib动态库导入项目，设置Target - General - Embedded Binaries 添加libbipay.dylib，如下图
![image.png](https://upload-images.jianshu.io/upload_images/6693936-29e8a33c9696d05b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) 

**导入头文件**

```
#import "BiPayObject.h"
```
**3.币种说明**
> 参考coin.h文件 例如：0 代表BTC  60 代表ETH



## API说明（API Specification）
##### 注.开发者只需要调用或者修改bipaySDK文件夹中的BiPayObject.h与BiPayObject.m文件即可，这两个文件是对C++的封装，需要用到的各币种的coinType，私钥前缀以及地址前缀都在bipaySDK文件夹中的coins.h中
<font face="Times New Roman" size="5" color="#388dee">  API - getSupportedCoins</font><br />
```
/**
获取支持的币种

@return 支持币种字符串
*/
+ (NSString *)getSupportedCoins;
```

**功能说明**

-       获取支持的币种

**参数说明**

-       无参数
***
<font face="Times New Roman" size="5" color="#388dee"> API - getMnemonic:</font><br />
```
/**
获取助记词，由熵生成对应语言的助记词,助记词以空格分割

@param language 生成助记词的语言,分为: 0:en 英文1:es 西班牙文 2:ja 日文 3:it  意大利文 4:fr 法文 5:cs 捷克文  6:ru 俄文 7:uk 乌克兰文   8:zh_Hans 简体中文 9:zh_Hant繁体中文

@return 获取助记词
*/
+ (NSString *)getMnemonic:(int)language;
```

**功能说明**

-      获取助记词

**参数说明**

-     language：0 - 9  暂时只支持 8-中文，0-英文

*** 
<font face="Times New Roman" size="5" color="#388dee">  API - getSeedWithMnemonic:</font><br /> 
```
API - getSeedWithMnemonic:
/**
由助记词生成种子

@param mnemonic 一个16进制字符串,长度为128~256 由getMnemonic获得
@return 需要的种子
*/
+ (NSString *)getSeedWithMnemonic:(NSString *)mnemonic;
```

**功能说明**

-       获取种子

**参数说明**
-       mnemonic:助记词，由getMnemonic获得
***
<font face="Times New Roman" size="5" color="#388dee">  API - getMasterKey:</font><br />
```
/**
* 由种子获取主私钥,全局就一个主私钥,其它币种的私钥可由该私钥派生
* @param seed 种子 由getSeedWithMnemonic获得
* @return 私钥
*/
+ (NSString *)getMasterKey:(NSString *)seed;
```

**功能说明**
-       获取主私钥

**参数说明**
-       seed:种子，由getSeedWithMnemonic获得
***
<font face="Times New Roman" size="5" color="#388dee">  API - getCoinMasterKey: coinType:</font><br />
```
/**
根据主私钥获取对应币种的母密钥（获取私钥以xprv序列化格式，用户不可见）

@param master_key 主私钥，由getMasterKey获得
@param coinType 币种
@return 私钥
*/
+ (NSString *)getCoinMasterKey:(NSString *)master_key coinType:(int)coinType;
```

**功能说明**

-       根据主私钥获取对应币种的母密钥（获取私钥以xprv序列化格式，用户不可见）

**参数说明**
-       masterKey: 主私钥，由getMasterKey获得 
-       coinType:  币种，0-BTC;60-ETH;206-DVC

***
<font face="Times New Roman" size="5" color="#388dee"> API - getSubPrivKey: index:</font><br />
```
/**
获取某个币种的子密钥,以xprv格式导出,可生成币种地址和签名

@param pprivkey 对应某个币种的母密钥,由getCoinMasterKey: coinType:生成
@param index 对应子密钥的索引,若index=[2^31, 2^32),则为强化子密钥否则为普通子密钥
@return 获取某个币种的子密钥,以xprv格式导出
*/
+ (NSString *)getSubPrivKey:(NSString *)privkey index:(unsigned int)index;
```

**功能说明**

-       获取某个币种的子密钥,以xprv格式导出,可生成币种地址和签名

**参数说明**
-      privKey: 对应某个币种的母密钥,由getCoinMasterKey: coinType:生成
-     index:     对应子密钥的索引，值为2 ^ 31

***
<font face ="Times New Roman" size = "5" color="#388dee"> API - getCoinAddress: coinType: addressPrefix</font>

```
/**
根据私钥获取地址 币种对应的地址

@param privkey 主私钥
@param coinType 币种
@param addressPrefix 地址前缀
@return 地址
*/
+ (NSString *)getCoinAddress:(NSString *)privkey coinType:(int)coinType addressPrefix:(int)addressPrefix;
```

**功能说明**

-       币种对应的地址

**参数说明**
-     privkey:币种的子密钥，由getSubPrivKey:index:生成
-     coinType:币种，0-BTC;60-ETH;206-DVC;
-     addressPrefix:地址前缀;

***

<font face="Times New Roman" size="5" color="#388dee"> API - getSignaturePrivKey: coinType: privePrefix:</font><br />
```
/**
币种地址签名的私钥,可导出的币种私钥，用户可见

@param subPrivKey 币种的子密钥，由getSubPrivKey生成
@param coinType 币种 0-BTC;60-ETH;206-DVC
@param privePrefix 私钥前缀
@return 密钥
*/
+ (NSString *)getSignaturePrivKey:(NSString *)subPrivKey coinType:(int)coinType privePrefix:(int)privePrefix;
```

**功能说明**

-       币种地址签名的私钥,可导出的币种私钥，用户可见

**参数说明**
-     subPrivKey: 币种的子密钥，由getSubPrivKey生成
-     coinType:   币种，0-BTC;60-ETH;206-DVC;
-     privePrefix:私钥前缀;
***
<font face="Times New Roman" size="5" color="#388dee"> API - freeAlloc:</font><br />
```
/**
在调用任意一个接口函数时,需要使用该接口来释放空间

@param oc 所有NSString类型的返回值
*/
+ (void)freeAlloc:(NSString *)oc;
```

**功能说明**

-       在调用任意一个接口函数时,需要使用该接口来释放空间

**参数说明**
-       oc:所有NSString类型的返回值

***
<font face="Times New Roman" size="5" color="#388dee"> API - verifyCoinAddress: coinType:</font><br />
```
/**
*  用于验证某个币种的地址是否合法

@param addr 币种地址
@param coin_type 币种 0-BTC;60-ETH;206-DVC;
@return 是否合法
*/
+ (BOOL)verifyCoinAddress:(NSString *)addr coinType:(int)coin_type;
```
**功能说明**

-       用于验证某个币种的地址是否合法

**参数说明**
-     addr:币种地址
-     coinType:币种，0-BTC;60-ETH;206-DVC;

***
<font face="Times New Roman" size="5" color="#388dee"> API - createNewTransaction:coinType:</font><br />
```
/**
获取signatureForTransfer:的第一个参数tx
通过给定的json格式的交易参数来创建一个交易,比如以太坊:
*        {
*            "nonce":5,
*            "gasprice":4000000000,
*            ...
*          }
@param tx_json_str 形如上面的json字符串,根据币种生成的json
@param coin_type 币种,0-BTC;60-ETH;206-DVC;
@return 交易字符串tx
*/
+ (NSString *)createNewTransaction:(NSString *)tx_json_str coinType:(unsigned int)coin_type;
```
**功能说明**
-      获取signature:的第一个参数tx
**参数说明**
-     tx_json_str: 根据币种生成的json
-     coinType:    币种，0-BTC;60-ETH;206-DVC;

**json说明**
```
ETH
{
"from":"0x389b5c399d998a71f816449ab31c9d2c358c082f",  // 转账地址
"to":"0xc52f519474f6f0def379c9d161b0a91ec47582f2", // 转入地址
"value":"10000000000000", // 转账金额
"nonce":"2", // 交易次数
"gasprice":"7000000000" // 手续费
}    
BTC、DVC
{
"inputs_count": 3, // 需要用到的交易结构体个数
"inputs": [
{
"prev_position": 0, // 上次输出的序号
"prev_tx_hash": "" // 交易编号
},
{
"prev_position": 0,
"prev_tx_hash": ""
}
],
"outputs_count": 2, // 不需要找零时为1，需要找零时为2
"outputs": [
{
"address": "", // 对方的接收地址
"value": "" // 转账金额
},
{
"address": "", // 自己的转账地址（需要找零时，追加此字段和value字段）
"value": "" // 找零金额
}
]
}
```


***

<font face="Times New Roman" size="5" color="#388dee">API - signatureForTransfer:privkeys:coinType:</font><br />
```
/**
签名,生成转账参数

@param tx  createNewTransaction:coin_type:方法返回的数据
@param privkeys 由getSignaturePrivKey: coinType:方法获得，createNewTransaction:的json中有几个交易结构体，就追加几个privkeys，用空格" "分开
@param coin_type 币种 0-BTC;60-ETH;206-DVC;
@return 签名后字符串,为了发送交易给后台
*/
+ (NSString *)signatureForTransfer :(NSString *)tx privkeys:(NSString *)privkeys coinType:(unsigned int)coin_type;
```

**参数说明**


-      tx:由createNewTransaction:coinType:方法返回的数据
-     privkeys:由getSignaturePrivKey: coinType:方法获得，newTransaction的json中有几个交易结构体，就追加几个privkeys，用空格" "分开
-     coinType: 币种，0-BTC;60-ETH;206-DVC;

***
<font face="Times New Roman" size="5" color="#388dee"> API - signatureByKS: ks_file: password: coinType:</font><br />
```

/**
通过keystore文件路径和密码对tx进行签名

@param tx createNewTransaction:coinType:方法返回值
@param ks_file keystore文件路径
@param password 密码
@param coin_type 币种,0-BTC;60-ETH;206-DVC;
@return 签名后字符串
*/
+ (NSString *)signatureByKS:(NSString *)tx ks_file:(NSString *)ks_file password:(NSString *)password coinType:(unsigned int)coin_type; 
```

**参数说明**

-       tx: 为createNewTransaction:coinType:方法的返回值
-       ks_file: keystore文件路径
-       coinType: 币种，0-BTC;60-ETH;206-DVC;


### 附 (statement)

| 币种  |  私钥前缀 | 地址前缀 |
|  ----| -----  | ------ |
|BTC   |   128    |   0     |
|BCH   |   128    |   0     |
|DVC   |   176    |   30    |
|DSH   |   207    |   75    |
|DOGE  |   176    |   30    |
|LTC   |   176    |   48    |
|QTUM  |   128    |   58    |
|USDT  |   128    |   0     |
|XNE   |   176    |   75    |
|ZEC   |   238    |   128   |


##### 有疑问或者问题欢迎加入币付钱包开发讨论群，开发者QQ群: 311189009


