//
//  changeDetailController.h
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"
#import "changeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface changeDetailController : BaseController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)changeModel*model;
@end

NS_ASSUME_NONNULL_END
