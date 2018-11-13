//
//  TradeDetailController.h
//  BiPay
//
//  Created by zjs on 2018/6/20.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"
#import "TradeModel.h"
#import "coinModel.h"
@interface TradeDetailController : BaseController
@property (nonatomic, strong) UITableView  * tableView;
@property (nonatomic, strong) TradeModel*model;
@property (nonatomic, strong) coinModel*coin;
@end
