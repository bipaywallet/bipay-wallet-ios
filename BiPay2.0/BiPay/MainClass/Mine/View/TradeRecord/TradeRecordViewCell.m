//
//  TradeRecordViewCell.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "TradeRecordViewCell.h"


@interface TradeRecordViewCell ()


@end

@implementation TradeRecordViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=[UIColor clearColor];
    self.directionAdress.text=LocalizationKey(@"dealNum");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
