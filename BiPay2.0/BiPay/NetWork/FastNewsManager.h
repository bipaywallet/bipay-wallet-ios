//
//  FastNewsManager.h
//  BiPay
//
//  Created by sunliang on 2018/8/16.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseNetManager.h"

@interface FastNewsManager : BaseNetManager
+(void)getNearnewsWithPageSize:(int)pageSize WithpageNo:(int)p withkeywords:(NSString*)keywords CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
//MARK:--/app/index/get_new_kuaixun_count.html
+ (void)getFastInfoCountWithID:(NSString *)aid withCompletion:(ResultBlock)block;
@end
