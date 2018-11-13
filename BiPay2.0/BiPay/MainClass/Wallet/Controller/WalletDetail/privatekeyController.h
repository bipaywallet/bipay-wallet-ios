//
//  privatekeyController.h
//  BiPay
//
//  Created by sunliang on 2018/9/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

@interface privatekeyController : BaseController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)walletModel*wallet;
@end
