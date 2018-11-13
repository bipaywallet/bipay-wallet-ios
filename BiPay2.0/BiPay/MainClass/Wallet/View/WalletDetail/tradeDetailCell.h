//
//  tradeDetailCell.h
//  BiPay
//
//  Created by sunliang on 2018/9/5.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tradeDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightConstant;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end
