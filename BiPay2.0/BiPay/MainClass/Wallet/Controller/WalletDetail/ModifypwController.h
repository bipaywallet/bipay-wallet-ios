//
//  ModifypwController.h
//  BiPay
//
//  Created by sunliang on 2018/6/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

@interface ModifypwController : BaseController
@property (weak, nonatomic) IBOutlet UITextField *oldPsw;
@property (weak, nonatomic) IBOutlet UITextField *inputPsd;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property(nonatomic,strong)walletModel*wallet;
@end
