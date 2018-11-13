//
//  HomeNetManager.m
//  BiPay
//
//  Created by sunliang on 2018/8/9.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "HomeNetManager.h"

@implementation HomeNetManager
//查询地址列表余额
+(void)checkManyAddress:(NSArray*)addressArray CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"address/unspent";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSMutableDictionary *dicdetail = [NSMutableDictionary new];
    dicdetail[@"addresses"]=addressArray;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicdetail options:NSJSONWritingPrettyPrinted error:&error];
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dic[@"data"] = str;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//查询某一地址列表余额
+(void)checksingleAddress:(NSString*)address coinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/address/single-address/unspent/tx",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"address"] = address;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//查询某一地址列表交易明细记录
+(void)checkDetaileSingleAddress:(NSString*)address coinName:(NSString*)name withconfirmations:(long)confirmations CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/address/single-address/total/tx",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"address"] = address;
    dic[@"confirmations"] = [NSNumber numberWithLong:confirmations];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//发送交易

+(void)postTrade:(NSString*)transaction withcoinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path =[NSString stringWithFormat:@"%@/raw/send",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"signTxStr"] = transaction;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//查询交易手续费余额
+(void)cheakservicechargewithcoinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path =[NSString stringWithFormat:@"%@/raw/get/service-charge",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//根据区块高度查询某一地址交易记录
+(void)blockHeightchecksingleAddress:(NSString*)address coinName:(NSString*)name confirmations:(long)confirmations startHeight:(NSString*)start endHeight:(NSString*)end CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path =[NSString stringWithFormat:@"%@/address/single-address/total/tx",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"address"] = address;
    dic[@"confirmations"] = [NSNumber numberWithLong:confirmations];
    dic[@"start"] = start;
    dic[@"end"] = end;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//查询最新的区块高度
+(void)latestblockHeightcoinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path =[NSString stringWithFormat:@"%@/block/latest/height",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}


//查询某一地址列表余额(增加标识符coinName)
+(void)coinNamechecksingleAddress:(NSString*)address coinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code,NSString*coinName))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/address/single-address/unspent/tx",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"address"] = address;
    [self coinNameylNonTokenRequestWithGET:path parameters:dic withCoinName:name successBlock:^(id resultObject, int isSuccessed,NSString* coinName) {
        completeHandle(resultObject,isSuccessed,coinName);
    }];
}

/////////////带token的，ETH代币////////////
//查询某一地址列表交易明细记录
+(void)checkTokenkDetaileSingleAddress:(NSString*)address coinName:(NSString*)name withconfirmations:(long)confirmations CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/address/single-address/total/tx",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"address"] = address;
    dic[@"confirmations"] = [NSNumber numberWithLong:confirmations];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//查询某一代币地址列表余额
+(void)coinNameTokenchecksingleAddress:(NSString*)address  WithcontractAddress:(NSString*)contractAddress  coinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code,NSString*coinName))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/address/token/single-address/unspent/tx",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"address"] = address;
    dic[@"contractAddress"] = contractAddress;
    
    [self coinNameylNonTokenRequestWithGET:path parameters:dic withCoinName:name successBlock:^(id resultObject, int isSuccessed,NSString* coinName) {
        completeHandle(resultObject,isSuccessed,coinName);
    }];
}

//查询代币合约信息1
+(void)checkTokeninformationWithAddress:(NSString*)contractAddress   coinName:(NSString*)name CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/address/token/query",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"address"] = contractAddress;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//查询代币合约信息2
+(void)QuerydetaiTokeninformationWithAddress:(NSString*)contractAddress CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"toc/coin/token/query/detail"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"contractAddress"] = contractAddress;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}
//根据区块高度查询某一地址交易记录
+(void)TokenblockHeightchecksingleAddress:(NSString*)address WithAddress:(NSString*)contractAddress  coinName:(NSString*)name confirmations:(long)confirmations startHeight:(NSString*)start endHeight:(NSString*)end CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path =[NSString stringWithFormat:@"%@/address/token/single-address/total/tx",[name lowercaseString]];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"address"] = address;
    dic[@"contractAddress"] = contractAddress;
    dic[@"confirmations"] = [NSNumber numberWithLong:confirmations];
    dic[@"start"] = start;
    dic[@"end"] = end;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

@end
