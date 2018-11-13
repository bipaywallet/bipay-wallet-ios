//
//  ChangeWalletController.h
//  BiPay
//
//  Created by zjs on 2018/6/20.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"
#import "walletModel.h"
typedef void(^GetWalletBlock)(walletModel * wallet);

@interface ChangeWalletController : BaseController

@property (nonatomic, copy) GetWalletBlock walletBlock;
@property (nonatomic, strong) UITableView  * tableView;
@end
