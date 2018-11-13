//
//  SettingDetailController.h
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

typedef void(^GetBackBlock)(NSString * text);

@interface SettingDetailController : BaseController
@property (nonatomic,   copy) NSString     * baseStr;
@property (nonatomic, strong) NSString *selectItem;
@property (nonatomic, copy) GetBackBlock getBackBlock;
@property (nonatomic, strong) UITableView  * tableView;
@end
