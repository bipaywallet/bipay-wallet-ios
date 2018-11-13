//
//  selectedCell.h
//  BiPay
//
//  Created by sunliang on 2018/8/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "contactsModel.h"
@interface selectedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *FirsrtAddress;
@property (weak, nonatomic) IBOutlet UILabel *coinCount;
-(void)configModel:(contactsModel*)model;
@end
