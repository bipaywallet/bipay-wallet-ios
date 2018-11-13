//
//  LeftMenuViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BaseController.h"
typedef void(^GetBackBlock)(NSString * text);
@interface LeftMenuViewController : BaseController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) GetBackBlock getBackBlock;
- (void)showFromLeft;
@end
