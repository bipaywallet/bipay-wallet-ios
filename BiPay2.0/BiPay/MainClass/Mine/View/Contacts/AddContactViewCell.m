//
//  AddContactViewCell.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "AddContactViewCell.h"

@implementation AddContactViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.selectBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    // Initialization code
    self.backgroundColor = CellBackColor;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
