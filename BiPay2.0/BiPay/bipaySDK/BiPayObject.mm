//
//  BiPayObject.m
//  BiPaySDKDemo
//
//  Created by zsm on 2018/9/21.
//  Copyright © 2018年 zsm. All rights reserved.
//

#import "BiPayObject.h"

@implementation BiPayObject
//MARK:--由助记词创建钱包
+ (NSString *)createWalletWithMnemonic:(NSString *)mnemonicStr coinType:(int)coinType addressPrefix:(int)addressPrefix {
    NSString * mnemonic = [self getSeedWithMnemonic:mnemonicStr];
    NSString * masterKey = [self getMasterKey:mnemonic];
    NSString * exprivKey = [self getCoinMasterKey:masterKey coinType:coinType];
    NSString * getSubKey = [self getSubPrivKey:exprivKey index:2^31];
    NSString * getWalletAddress= [self getCoinAddress:getSubKey coinType:coinType addressPrefix:addressPrefix];
    return getWalletAddress;
}

//MARK:--由私钥创建钱包
+ (NSString *)createWalletWithPrivateKey:(NSString *)privateKey coinType:(int)coinType addressPrefix:(int)addressPrefix{
    
    NSString * exprivKey = [self getCoinMasterKey:privateKey coinType:coinType];
    NSString * getSubKey = [self getSubPrivKey:exprivKey index:2^31];
    NSString * getWalletAddress= [self getCoinAddress:getSubKey coinType:coinType addressPrefix:addressPrefix];
    return getWalletAddress;
}

//MARK:--导出私钥
+ (NSString *)exportWalletWithPrivateKey:(NSString *)privateKey coinType:(int)coinType privePrefix:(int)privePrefix{
    
    NSString * exprivKey = [self getCoinMasterKey:privateKey coinType:coinType];
    NSString * getSubKey = [self getSubPrivKey:exprivKey index:2^31];
    NSString * getPrivKey = [self getSignaturePrivKey:getSubKey coinType:coinType privePrefix:privePrefix];
    return getPrivKey;
}


//由助记词生成种子
+ (NSString *)getSeedWithMnemonic:(NSString *)mnemonic{
    const char *pConstChar = [mnemonic UTF8String];
    char *seedString= GetSeed(pConstChar);

    if(seedString){
        NSString * seed = [[NSString alloc] initWithUTF8String:seedString];
        return seed;
    }else{
        
        NSString *erroDes = @"助记词格式错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }

    
}

/**
 *  由熵生成对应语言的助记词,助记词以空格分割
 * @language 生成助记词的语言,分为以下几类
 * \ 0:en\ 1:es\ 2:ja\ 3:it\ 4:fr\ 5:cs\ 6:ru\ 7:uk\ 8:zh_Hans\ 9:zh_Hant
 */
+ (NSString *)getMnemonic:(int)language{
    char *resultStr= GetMnemonic(language);
    if (resultStr) {
        
        return [[NSString alloc] initWithUTF8String:resultStr];
    }else{
        NSString *erroDes = @"检查语言是否在0-9";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
}
/**
 *  获取主私钥,全局就一个主私钥,其它币种的私钥可由该私钥派生
 */
//BIPAY_DLL char* GetMasterKey(const char* seed);
+ (NSString *)getMasterKey:(NSString *)seed{
    const char *pConstChar = [seed UTF8String];
    char *masterKey= GetMasterKey(pConstChar);
    if (masterKey) {
        
        return [[NSString alloc] initWithUTF8String:masterKey];
    }else{
        NSString *erroDes = @"检查 seed 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
}
/**
 * 以WIF形式导出密钥
 */
//BIPAY_DLL char* GetExportedPrivKey(const char* privkey, int coin_type, int prefix);
+ (NSString *)getSignaturePrivKey:(NSString *)subPrivKey coinType:(int)coinType privePrefix:(int)privePrefix;
{
    const char *pConstChar = [subPrivKey UTF8String];
    char *priveKey= GetExportedPrivKey(pConstChar,coinType,privePrefix);
    if (priveKey) {
        
        return [[NSString alloc] initWithUTF8String:priveKey];
    }else{
        
        NSString *erroDes = @"检查 privkey 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
}

/**
 *  根据主私钥获取对应币种的私钥,获取私钥以xprv序列化格式
 */
//BIPAY_DLL char* GetCoinMasterKey(const char* master_key, int coin_type);
+ (NSString *)getCoinMasterKey:(NSString *)master_key coinType:(int)coinType{
    const char *pConstChar = [master_key UTF8String];
    char *privrKey= GetCoinMasterKey(pConstChar,coinType);
    
    if(privrKey){
        return [[NSString alloc] initWithUTF8String:privrKey];

    }else{
        
        NSString *erroDes = @"检查master_key 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
}

//BIPAY_DLL  char* GetAddressUsePrivkey(const char* privkey, int coin_type, int prefix);
+ (NSString *)getCoinAddress:(NSString *)privkey coinType:(int)coinType addressPrefix:(int)addressPrefix{
    const char *pConstChar = [privkey UTF8String];
    char *address= GetAddressUsePrivkey(pConstChar,coinType,addressPrefix);
    if(address){
        return [[NSString alloc] initWithUTF8String:address];
        
    }else{
        
        NSString *erroDes = @"检查 privkey 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
    
}

//BIPAY_DLL char* GetAddressUsePublicKey(const char* pubkey, int coin_type, int prefix);
+ (NSString *)getCoinAddressByPub:(NSString *)pubkey coinType:(int)coinType addressPrefix:(int)addressPrefix{
    const char *pConstChar = [pubkey UTF8String];
    char *addressByPub= GetAddressUsePublicKey(pConstChar,coinType,addressPrefix);
    
    if(addressByPub){
        return [[NSString alloc] initWithUTF8String:addressByPub];
        
    }else{
        
        NSString *erroDes = @"检查 pubkey 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
    
}


/**
 *  获取某个币种的主公钥,不同的币种公钥形式可能不同
 *
 */
//BIPAY_DLL char* GetPublicKey(const char* privkey, int coin_type);
+ (NSString *)getPublicKey:(NSString *)privkey coinType:(int)coinType{
    const char *pConstChar = [privkey UTF8String];
    char *publicKey= GetPublicKey(pConstChar,coinType);
    if(publicKey){
        return [[NSString alloc] initWithUTF8String:publicKey];
        
    }else{
        
        NSString *erroDes = @"检查 privkey 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
    
}
/**
 *  获取某个币种主公钥的导出形式,以xpub开头格式化字符串
 */
//BIPAY_DLL char* GetExPublicKey(const char* privkey, int coin_type);
+ (NSString *)getExPublicKey:(NSString *)privkey coinType:(int)coinType{
    const char *pConstChar = [privkey UTF8String];
    char *exPublicKey= GetExPublicKey(pConstChar,coinType);
    if(exPublicKey){
        return [[NSString alloc] initWithUTF8String:exPublicKey];
        
    }else{
        
        NSString *erroDes = @"检查 privkey 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
    
}

/***
 * *  以下接口实现BIP32协议中对应某个币种子私钥和子公钥的生成方式,分别有如下对应:
 * *   1. 母私钥+>子私钥  GetSubPrivKey
 * *   2. 母私钥+>子公钥  GetPrivSubPubKey
 * *   3. 父公钥+>子公钥  GetPubSubPubKey
 * *  所有的子公钥以xpub格式导出,可通过GetPublicKey方法获取各币种不同的形式
 * *  所有的子密钥以xprv格式导出,可通过GetExportedPrivKey方法获取不同币种的密钥形式
 */
/**
 *  获取某个币种的子密钥,以xprv格式导出
 * @pprivkey 对应某个币种的母密钥,有GetCoinMasterKey生成
 * @index 对应子密钥的索引,若index=[2^31, 2^32),则为强化子密钥否则为普通子密钥
 * @
 */
//BIPAY_DLL char* GetSubPrivKey(const char* pprivkey, unsigned int index);
+ (NSString *)getSubPrivKey:(NSString *)pprivkey index:(unsigned int)index{
    const char *pConstChar = [pprivkey UTF8String];
    char *subPrivKey= GetSubPrivKey(pConstChar,index);
    
    if(subPrivKey){
        return [[NSString alloc] initWithUTF8String:subPrivKey];
        
    }else{
        
        NSString *erroDes = @"检查 pprivkey 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
    
}

/**
 *  根据母私钥获取子公钥,以xpub格式导出
 * @pprivkey 母私钥
 * @index 对应子密钥的索引,index=[0, 2^31)
 */
//BIPAY_DLL char* GetPrivSubPubKey(const char* pprivkey, unsigned int index);
+ (NSString *)getPrivSubPubKey:(NSString *)pprivkey index:(unsigned int)index{
    const char *pConstChar = [pprivkey UTF8String];
    char *privSubPubKey= GetPrivSubPubKey(pConstChar,index);
    if(privSubPubKey){
        return [[NSString alloc] initWithUTF8String:privSubPubKey];
        
    }else{
        
        NSString *erroDes = @"检查 pprivkey 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
}
/**
 *  根据父公钥获取子公钥,以xpub格式导出
 * @ppubkey 父公钥
 * @index 对应子公钥的索引,index=[0, 2^31)
 */
//BIPAY_DLL char* GetPubSubPubKey(const char* ppubkey, unsigned int index);
+ (NSString *)getPubSubPubKey:(NSString *)ppubkey index:(unsigned int)index{
    const char *pConstChar = [ppubkey UTF8String];
    char *subpublicKey= GetPubSubPubKey(pConstChar,index);
    if(subpublicKey){
        return [[NSString alloc] initWithUTF8String:subpublicKey];
        
    }else{
        NSString *erroDes = @"检查 父公钥格式 是否错误";
        NSLog(@"BiPayObject erro:-- %@",erroDes);
        
        return @"";
    }
}
/// 签名
//BIPAY_DLL char* Signature(const char* tx, const char* privkeys, int coin_type);
+ (NSString *)signatureForTransfer:(NSString *)tx privkeys:(NSString *)privkeys coinType:(unsigned int)coin_type{
    const char *pConstChar = [tx UTF8String];
    const char *privkeysChar = [privkeys UTF8String];
    char *signature= SignSignature(pConstChar,privkeysChar,coin_type,[@"" UTF8String]);
    
    if(signature){
        return [[NSString alloc] initWithUTF8String:signature];
        
    }else{
        NSString *erroDes = @"检查 privkeys 格式是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
}
/// 通过keystore文件路径和密码对tx进行签名
//BIPAY_DLL char* SignatureByKS(const char* tx, const char* ks_file, const char* pass, int coin_type);

+ (NSString *)signatureByKS:(NSString *)tx ks_file:(NSString *)ks_file password:(NSString *)password coin_type:(unsigned int)coin_type{
    const char *pConstChar = [tx UTF8String];
    const char *ks_fileChar = [ks_file UTF8String];
    const char *passChar = [password UTF8String];
    char *signatureByKS= SignatureByKS(pConstChar,ks_fileChar,passChar,coin_type);
    
    if(signatureByKS){
        return [[NSString alloc] initWithUTF8String:signatureByKS];
        
    }else{
        
        NSString *erroDes = @"签名出错：检查tx ks_file 是否错误";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
}

///交易生成
/**
 *  通过给定的json格式的交易参数来创建一个交易,比如以太坊:
 *        {
 *            "nonce":5,
 *            "gasprice":4000000000,
 *            ...
 *          }
 *    @tx_json_str 形如上面的json字符串
 *    @return 十六进制交易字符串
 */
//BIPAY_DLL char* NewTransaction(const char* tx_json_str, int coin_type);//交易
+ (NSString *)createNewTransaction:(NSString *)tx_json_str coinType:(unsigned int)coin_type{
    const char *pConstChar = [tx_json_str UTF8String];
    char *transactionStr= NewTransaction(pConstChar,coin_type);
    if(transactionStr){
        return [[NSString alloc] initWithUTF8String:transactionStr];
        
    }else{
        
        NSString *erroDes = @"检查 json格式 要求是否符合";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
}
/**
 *  用于验证某个币种的地址是否合法
 */
//BIPAY_DLL bool VerifyAddress(const char* addr, int coin_type);
+ (BOOL)verifyCoinAddress:(NSString *)addr coinType:(int)coin_type{
    const char *pConstChar = [addr UTF8String];
    bool isLegal= VerifyAddress(pConstChar,coin_type);
    return isLegal;
}
//BIPAY_DLL char* GetSupportedCoins(void);
+ (NSString *)getSupportedCoins{
    char *supportCoins= GetSupportedCoins();
    if(supportCoins){
        return [[NSString alloc] initWithUTF8String:supportCoins];
        
    }else{
        
        NSString *erroDes = @"暂无支持币种";
        NSLog(@"BiPayObject warning:-- %@",erroDes);
        return @"";
    }
}

///在调用任意一个接口函数时,需要使用该接口来释放空间
//BIPAY_DLL void FreeAlloc(char* oc);
+ (void)freeAlloc:(NSString *)oc {
    char *tempChar = nullptr ;
    strcpy(tempChar,(char *)[oc UTF8String]);
    FreeAlloc(tempChar);
}
@end
