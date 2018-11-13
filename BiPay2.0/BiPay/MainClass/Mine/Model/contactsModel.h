//
//  contactsModel.h
//  BiPay
//
//  Created by sunliang on 2018/8/18.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface contactsModel : NSObject
@property(nonatomic,strong) NSNumber *ID;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *remark;
/**
 *  一个联系人可以有多个币种
 */
@property(nonatomic,strong) NSMutableArray *coinArray;
@end
