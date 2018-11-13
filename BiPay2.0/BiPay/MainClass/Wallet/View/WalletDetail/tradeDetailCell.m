//
//  tradeDetailCell.m
//  BiPay
//
//  Created by sunliang on 2018/9/5.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "tradeDetailCell.h"

@implementation tradeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = CellBackColor;
    self.titleLabel.textColor = DealTitleColor;
    self.detailLabel.textColor = DealSubTitleColor;
    [self.checkBtn setTitle:LocalizationKey(@"see") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
