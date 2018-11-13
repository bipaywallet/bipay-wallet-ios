//
//  TradeModel.m
//  BiPay
//
//  Created by sunliang on 2018/8/9.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "TradeModel.h"

@implementation TradeModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"inputs":[TransferModel class],@"outputs":[TransferModel class]};
}

@end
