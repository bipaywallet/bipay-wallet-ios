//
//  walletCell.m
//  BiPay
//
//  Created by sunliang on 2018/8/9.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "walletCell.h"

@implementation walletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = CellBackColor;
    self.titleLabel.textColor = barTitle;
    self.contentLabel.textColor = SubTitleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
