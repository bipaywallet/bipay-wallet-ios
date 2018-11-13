//
//  marketCell.m
//  BiPay
//
//  Created by sunliang on 2018/7/27.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "marketCell.h"

@implementation marketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configMode:(marketModel*)model{
    self.coinName.text=model.name;
    self.cnyLabel.text=[NSString stringWithFormat:@"¥ %@",model.close_rmb];
    self.dollarLabel.text=[NSString stringWithFormat:@"$ %@",model.close];
    self.changelabel.text=[NSString stringWithFormat:@"%@%%",model.rise];
    if ([model.rise doubleValue]>=0) {
        self.changelabel.backgroundColor=GreenColor;
    }else{
        self.changelabel.backgroundColor=RedColor;
    }
}
@end
