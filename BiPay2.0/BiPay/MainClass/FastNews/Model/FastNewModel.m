//
//  FastNewModel.m
//  BiPay
//
//  Created by sunliang on 2018/8/16.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "FastNewModel.h"

@implementation FastNewModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"newsID": @"id"};
}
@end
