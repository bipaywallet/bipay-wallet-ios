//
//  marketModel.h
//  BiPay
//
//  Created by sunliang on 2018/8/20.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface marketModel : NSObject
@property(nonatomic,copy) NSString* c_name;
@property(nonatomic,copy) NSString* close;
@property(nonatomic,copy) NSString* close_rmb;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* open;
@property(nonatomic,copy) NSString* rise;

@end
