//
//  walletModel.h
//  BiPay
//
//  Created by sunliang on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
//钱包model
@interface walletModel : NSObject
@property(nonatomic,strong) NSNumber *ID;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *password;//加密主私钥
@property(nonatomic,copy) NSString *tips;//密码提示信息
@property(nonatomic,copy) NSString *mnemonics;//加密助记词
@property(nonatomic,copy) NSString *isHide;//是否隐藏此钱包的余额 0.不隐藏  1.隐藏
/**
 *  一个钱包可以有多个币种
 */
@property(nonatomic,strong) NSMutableArray *coinArray;
@end
