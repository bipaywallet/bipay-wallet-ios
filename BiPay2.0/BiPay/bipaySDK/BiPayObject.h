//
//  BiPayObject.h
//  BiPaySDKDemo
//
//  Created by zsm on 2018/9/21.
//  Copyright © 2018年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bipaydll.h"
@interface BiPayObject : NSObject

#pragma mark -- 以下为自定义方法
/**
 GetCoinMasterKey
 GetExportedPrivKey [比特币系列增加整型的prefix参数，用于衍生代币导出前缀，其它币暂时可任意值]//私钥
 GetAddressUsePrivkey [比特币系列增加整型的prefix参数，用于衍生代币的地址前缀，其它币暂时可任意值]//地址前缀
 GetAddressUsePublicKey[同上]
 GetSupportedCoins
 
 
 . 不同比特币系列私钥和地址前缀参数
 
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
 */





/**
 助记词生成钱包

 @param mnemonicStr 助记词
 @param coinType 币种类型（根据coins.h中获取）
 @param addressprefix 地址前缀
 @return 钱包地址
 */
+ (NSString *)createWalletWithMnemonic:(NSString *)mnemonicStr coinType:(int)coinType addressprefix:(int)addressprefix;
//MARK:--由私钥创建钱包

/**
 由私钥创建钱包

 @param privateKey 私钥
 @param coinType 币种类型
 @param addressprefix 地址前缀
 @return 钱包地址
 */
+ (NSString *)createWalletWithPrivateKey:(NSString *)privateKey coinType:(int)coinType addressprefix:(int)addressprefix;

/**
 导出私钥

 @param privateKey 私钥
 @param coinType 币种
 @param Priveprefix 私钥前缀
 @return 私钥
 */
+ (NSString *)exportWalletWithPrivateKey:(NSString *)privateKey coinType:(int)coinType Priveprefix:(int)Priveprefix;
#pragma mark -- 以下为专有方法

/**
 *  由熵生成对应语言的助记词,助记词以空格分割
 * @language 生成助记词的语言,分为以下几类
 * \ 0:en\ 1:es\ 2:ja\ 3:it\ 4:fr\ 5:cs\ 6:ru\ 7:uk\ 8:zh_Hans\ 9:zh_Hant
 */
+ (NSString *)getMnemonic:(int)language;

/**
 由助记词生成种子

 @param mnemonic 一个16进制字符串,长度为128~256
 @return 需要的种子
 */
+ (NSString *)getSeedWithMnemonic:(NSString *)mnemonic;


//BIPAY_DLL char* GetMasterKey(const char* seed);
/**
 * 由种子获取主私钥,全局就一个主私钥,其它币种的私钥可由该私钥派生
 * @param seed 种子
 * @return 私钥
 */
+ (NSString *)getMasterKey:(NSString *)seed;

/**
 币种地址签名的私钥,可导出的币种私钥，用户可见
 
 @param subPrivKey 币种的子密钥，由getSubPrivKey生成
 @param coinType 币种 0-BTC;60-BTC;206-ETH;
  @param Priveprefix 私钥前缀
 @return 密钥
 */
+ (NSString *)getSignaturePrivKey:(NSString *)subPrivKey coinType:(int)coinType Priveprefix:(int)Priveprefix;


/**
 根据主私钥获取对应币种的私钥,获取私钥以xprv序列化格式

 @param master_key 主私钥
 @param coinType 币种
 @return 私钥
 */
+ (NSString *)getExPrivKey:(NSString *)master_key coinType:(int)coinType;


/**
 根据私钥获取地址

 @param privkey 主私钥
 @param coinType 币种
@param addressprefix 地址前缀
 @return 地址
 */
+ (NSString *)getCoinAddress:(NSString *)privkey coinType:(int)coinType Addressprefix:(int)addressprefix;


/**
 根据公钥获取地址

 @param pubkey 公钥
 @param coinType 币种
 @param addressprefix 地址前缀
 @return 地址
 */
+ (NSString *)getCoinAddressByPub:(NSString *)pubkey coinType:(int)coinType addressprefix:(int)addressprefix;

/**
 获取某个币种的主公钥,不同的币种公钥形式可能不同

 @param privkey 私钥
 @param coinType 币种
 @return 主公钥
 */
+ (NSString *)getPublicKey:(NSString *)privkey coinType:(int)coinType;

/**
 获取某个币种主公钥的导出形式,以xpub开头格式化字符串

 @param privkey 私钥
 @param coinType 币种
 @return 主公钥的导出形式,以xpub开头格式化字符串
 */
+ (NSString *)getExPublicKey:(NSString *)privkey coinType:(int)coinType;

/***
 * *  以下接口实现BIP32协议中对应某个币种子私钥和子公钥的生成方式,分别有如下对应:
 * *   1. 母私钥+>子私钥  GetSubPrivKey
 * *   2. 母私钥+>子公钥  GetPrivSubPubKey
 * *   3. 父公钥+>子公钥  GetPubSubPubKey
 * *  所有的子公钥以xpub格式导出,可通过GetPublicKey方法获取各币种不同的形式
 * *  所有的子密钥以xprv格式导出,可通过GetExportedPrivKey方法获取不同币种的密钥形式
 */

/**
 获取某个币种的子密钥,以xprv格式导出

 @param pprivkey 对应某个币种的母密钥,由GetCoinMasterKey生成
 @param index 对应子密钥的索引,若index=[2^31, 2^32),则为强化子密钥否则为普通子密钥
 @return 获取某个币种的子密钥,以xprv格式导出
 */
+ (NSString *)getSubPrivKey:(NSString *)pprivkey index:(unsigned int)index;



/**
 根据母私钥获取子公钥,以xpub格式导出

 @param pprivkey 母私钥
 @param index 对应子密钥的索引,index=[0, 2^31)
 @return 子公钥
 */
+ (NSString *)getPrivSubPubKey:(NSString *)pprivkey index:(unsigned int)index;

/**
 根据父公钥获取子公钥,以xpub格式导出

 @param ppubkey 父公钥
 @param index 对应子公钥的索引,index=[0, 2^31)
 @return 子公钥
 */
+ (NSString *)getPubSubPubKey:(NSString *)ppubkey index:(unsigned int)index;

/**
 签名,生成转账参数
 
 @param tx  newTransaction:coin_type:方法返回的数据
 @param privkeys 由getSignaturePrivKey: coinType:方法获得，createNewTransaction:的json中有几个交易结构体，就追加几个privkeys，用空格" "分开
 @param coin_type 币种 0-BTC;60-BTC;206-ETH;
 @return 签名后字符串,为了发送交易给后台
 */
+ (NSString *)signatureForTransfer:(NSString *)tx privkeys:(NSString *)privkeys coinType:(unsigned int)coin_type;



/**
 通过keystore文件路径和密码对tx进行签名

 @param tx tx
 @param ks_file keystore文件路径
 @param password 密码
 @param coin_type 币种
 @return 签名后字符串
 */
+ (NSString *)signatureByKS:(NSString *)tx ks_file:(NSString *)ks_file password:(NSString *)password coin_type:(unsigned int)coin_type;

//MARK:--交易生成

/**
 通过给定的json格式的交易参数来创建一个交易,比如以太坊:
 *        {
 *            "nonce":5,
 *            "gasprice":4000000000,
 *            ...
 *          }
 @param tx_json_str 形如上面的json字符串
 @param coin_type 币种
 @return 交易字符串
 */
+ (NSString *)createNewTransaction:(NSString *)tx_json_str coinType:(unsigned int)coin_type;
/**
 *  用于验证某个币种的地址是否合法
 
 @param addr 币种地址
 @param coin_type 币种
 @return 是否合法
 */
+ (BOOL)verifyCoinAddress:(NSString *)addr coinType:(int)coin_type;


/**
 获取支持的币种

 @return 支持币种字符串
 */
+ (NSString *)getSupportedCoins;

/**
 在调用任意一个接口函数时,需要使用该接口来释放空间

 @param oc oc description
 */
+ (void)freeAlloc:(NSString *)oc;

@end
