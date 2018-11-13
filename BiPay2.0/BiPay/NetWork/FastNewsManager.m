//
//  FastNewsManager.m
//  BiPay
//
//  Created by sunliang on 2018/8/16.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "FastNewsManager.h"
#define BlockChainHost @"http://www.qkljw.com/"
@implementation FastNewsManager
//MARK:--http://www.qkljw.com/app/index/get_kuaixun_list
+(void)getNearnewsWithPageSize:(int)pageSize WithpageNo:(int)p withkeywords:(NSString*)keywords CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"%@/app/index/get_kuaixun_list.html",BlockChainHost];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"pageSize"] = [NSNumber numberWithInt:pageSize];
    dic[@"p"] = [NSNumber numberWithInt:p];
    dic[@"keywords"] = keywords;
    [self ylNonTokenRequestWithPostNoHost:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
    
}

//MARK:--/app/index/get_new_kuaixun_count.html
+ (void)getFastInfoCountWithID:(NSString *)aid withCompletion:(ResultBlock)block{
    NSString *path = [NSString stringWithFormat:@"%@/app/index/get_new_kuaixun_count.html",BlockChainHost];
    
    NSMutableDictionary *dic = NSMutableDictionary.dictionary;
    dic[@"id"] = aid;
    
    NSString *url = path;
    [BaseNetManager requestWithPost:url parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        block(resultObject,isSuccessed);
    }];
}
@end
