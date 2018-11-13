//
//  coinModel.h
//  BiPay
//
//  Created by sunliang on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface coinModel : NSObject//币种model
/**
 *  所有者
 */
@property(nonatomic,strong ) NSNumber *own_id;

/**
 *  币种的ID
 */
@property(nonatomic,strong) NSNumber *coin_id;
@property(nonatomic,copy)   NSString *brand;//币种名字
@property(nonatomic,assign) int cointype;
@property(nonatomic,copy)   NSString* address;
@property(nonatomic,assign) int collect;//是否添加了该币种，0为false，1为true
@property(nonatomic,copy)   NSString *totalAmount;//该币种的总资产
@property(nonatomic,copy)   NSString *closePrice;//人民币价格
@property(nonatomic,copy)   NSString *usdPrice;//美元价格
@property(nonatomic,assign) long blockHeight;//区块高度
@property(nonatomic,copy)   NSString *recordType;//交易记录类型（区分UTXO和非UTXO等）0、1、2等
@property(nonatomic,assign) int Priveprefix;//比特币系列增加整型的prefix参数，用于衍生代币导出前缀，其它币暂时可任意值
@property(nonatomic,assign) int Addressprefix;//比特币系列增加整型的prefix参数，用于衍生代币的地址前缀，其它币暂时可任意值
@property(nonatomic,copy)   NSString *decimals;//代币时使用
@property(nonatomic,copy)   NSString *fatherCoin;//代币时使用
/**
 新增，代币的合约地址
 */
@property(nonatomic,copy)   NSString *contractAddress;

@property(nonatomic,copy)   NSString *addtime;//添加资产时间
@property(nonatomic,copy)   NSString *imgUrl;//代币时使用
@end
