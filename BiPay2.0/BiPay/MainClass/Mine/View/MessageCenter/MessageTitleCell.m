//
//  MessageTitleCell.m
//  BiPay
//
//  Created by 褚青骎 on 2018/7/28.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MessageTitleCell.h"

@implementation MessageTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = CellBackColor;
    self.title.textColor = barTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
