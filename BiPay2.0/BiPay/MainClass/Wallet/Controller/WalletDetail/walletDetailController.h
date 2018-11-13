//
//  walletDetailController.h
//  BiPay
//
//  Created by sunliang on 2018/6/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

@interface walletDetailController : BaseController
@property(nonatomic,strong)walletModel*wallet;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
