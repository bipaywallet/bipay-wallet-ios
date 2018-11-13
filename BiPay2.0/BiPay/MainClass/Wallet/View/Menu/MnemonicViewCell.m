//
//  MnemonicViewCell.m
//  BiPay
//
//  Created by 褚青骎 on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MnemonicViewCell.h"

@implementation MnemonicViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.wordCell.textColor = barTitle;
}

@end
