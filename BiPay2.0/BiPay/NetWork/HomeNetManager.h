//
//  HomeNetManager.h
//  BiPay
//
//  Created by sunliang on 2018/8/9.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseNetManager.h"

@interface HomeNetManager : BaseNetManager
//查询地址列表余额
+(void)checkManyAddress:(NSArray*)addressArray CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查询某一地址列表余额
+(void)checksingleAddress:(NSString*)address coinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查询某一地址列表交易明细记录
+(void)checkDetaileSingleAddress:(NSString*)address coinName:(NSString*)name withconfirmations:(long)confirmations CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//发送交易
+(void)postTrade:(NSString*)transaction withcoinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查询交易手续费余额
+(void)cheakservicechargewithcoinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//根据区块高度查询某一地址交易记录
+(void)blockHeightchecksingleAddress:(NSString*)address coinName:(NSString*)name confirmations:(long)confirmations startHeight:(NSString*)start endHeight:(NSString*)end CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查询最新的区块高度
+(void)latestblockHeightcoinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//查询某一地址列表余额(增加标识符coinName)
+(void)coinNamechecksingleAddress:(NSString*)address coinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code,NSString*coinName))completeHandle;

/////////////带token的，ETH代币////////////

//查询某一地址列表交易明细记录
+(void)checkTokenkDetaileSingleAddress:(NSString*)address coinName:(NSString*)name withconfirmations:(long)confirmations CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

//查询代币合约信息--1
+(void)checkTokeninformationWithAddress:(NSString*)contractAddress  coinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查询代币合约信息--2
+(void)QuerydetaiTokeninformationWithAddress:(NSString*)contractAddress CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//查询某一代币地址列表余额
+(void)coinNameTokenchecksingleAddress:(NSString*)address  WithcontractAddress:(NSString*)contractAddress  coinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code,NSString*coinName))completeHandle;
//根据区块高度查询某一地址交易记录
+(void)TokenblockHeightchecksingleAddress:(NSString*)address WithAddress:(NSString*)contractAddress  coinName:(NSString*)name confirmations:(long)confirmations startHeight:(NSString*)start endHeight:(NSString*)end CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
@end
