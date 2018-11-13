//
//  changeModel.h
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface changeModel : NSObject
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*fullName;
@property(nonatomic,copy)NSString*image;
@property(nonatomic,copy)NSString*time;//
@property(nonatomic,copy)NSString*fromCoin;
@property(nonatomic,copy)NSString*toCoin;
@property(nonatomic,copy)NSString*fromAmount;
@property(nonatomic,copy)NSString*toAmount;
@property(nonatomic,copy)NSString*fromAddress;
@property(nonatomic,copy)NSString*toAddress;
@property(nonatomic,copy)NSString*rate;
@property(nonatomic,copy)NSString*status;//0： confirming,确认中 1： exchanging 兑换中 2： sending，交换完成，确认中 3:finished 完成 4:其他：失败
@property(nonatomic,copy)NSString*txid;
@property(nonatomic,strong ) NSNumber *walletID;
@end

NS_ASSUME_NONNULL_END
