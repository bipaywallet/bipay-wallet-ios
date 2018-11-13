//
//  TransferController.h
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

@interface TransferController : BaseController
typedef NS_ENUM(NSInteger, coinType) {
    BTC,//默认从0开始
    LTC,
    DASH,
    ETH,
    ETC,
};
@property(nonatomic,strong)coinModel*coin;
@property(nonatomic,assign)int popType;//区分是正常进入还是二维码扫描进入
@property(nonatomic,copy)NSString* popCount;//二维码中转账数量
@end
