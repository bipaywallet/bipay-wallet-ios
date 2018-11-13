//
//  NoticeModel.h
//  BiPay
//
//  Created by sunliang on 2018/8/30.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject
@property(nonatomic,copy) NSString* content;
@property(nonatomic,copy) NSString* createTime;
@property(nonatomic,copy) NSString* flag;
@property(nonatomic,copy) NSString* ID;
@property(nonatomic,copy) NSString* merchantCode;
@property(nonatomic,copy) NSString* merchantName;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* updateTime;
@end
