//
//  OptionalCell.m
//  BiPay
//
//  Created by sunliang on 2018/8/18.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "OptionalCell.h"

@implementation OptionalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = CellBackColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
