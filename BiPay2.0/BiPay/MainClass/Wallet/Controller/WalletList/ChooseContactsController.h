//
//  ChooseContactsController.h
//  BiPay
//
//  Created by sunliang on 2018/8/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"
typedef void(^GetBackBlock)(NSString * text);
@interface ChooseContactsController : BaseController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) GetBackBlock getBackBlock;
@end
