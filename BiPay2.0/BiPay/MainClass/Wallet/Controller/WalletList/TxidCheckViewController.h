//
//  TxidCheckViewController.h
//  BiPay
//
//  Created by sunliang on 2018/10/11.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TxidCheckViewController : BaseController
@property(nonatomic,copy)NSString*txid;
@property(nonatomic,strong)coinModel*coin;
@end

NS_ASSUME_NONNULL_END
