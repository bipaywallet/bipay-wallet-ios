//
//  ReceivablesController.h
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

@interface ReceivablesController : BaseController
@property(nonatomic,strong)coinModel*coin;
@property (weak, nonatomic) IBOutlet UILabel *coinNameLabel;

@end
