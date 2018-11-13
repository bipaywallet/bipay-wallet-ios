//
//  HomeViewCell.m
//  BiPay
//
//  Created by sunliang on 2018/6/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "HomeViewCell.h"
#import "NSUserDefaultUtil.h"
#import "UIImageView+WebCache.h"
@implementation HomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=[UIColor clearColor];
    self.cellBackView.backgroundColor =HomeCellBackColor;
}
-(void)configModel:(coinModel*)model{
    if ([model.fatherCoin isEqualToString:@"ETH"]) {
        self.ERC20Btn.hidden = NO;
    }else{
        self.ERC20Btn.hidden = YES;
    }
    self.nameLabel.text=model.brand;
    self.balanceLabel.text=model.totalAmount;
    NSArray*NameArray=[UserinfoModel shareManage].Namearray;
    if ([NameArray containsObject:model.brand]) {
        self.iconImageV.image=IMAGE(model.brand);
    }else{
        if (model.fatherCoin) { //代币
            if ([model.imgUrl isEqualToString:@"NULL"]||[model.imgUrl isEqualToString:@""]||!model.imgUrl) {
                self.iconImageV.image=IMAGE(@"defaulticon");
            }else{
                NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)model.imgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));//解决中文编码问题
               [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:encodedString]];
            }
        
        }else{
            self.iconImageV.image=IMAGE(@"defaulticon");
        }
    }
    if ([[NSUserDefaultUtil GetDefaults:HIDEMONEY] boolValue]) {
        self.balanceLabel.text=@"****";
        self.totalLabel.text=@"****";
        self.priceLabel.text=[NSString stringWithFormat:@"≈%@ CNY",model.closePrice];
    }else{

        if ([[NSUserDefaultUtil  GetDefaults:MoneyChange] isEqualToString:@"CNY"]) {
            self.priceLabel.text=[NSString stringWithFormat:@"≈%@ CNY",model.closePrice];
            self.balanceLabel.text=[NSString stringWithFormat:@"%.8f",[model.totalAmount doubleValue]];
            self.totalLabel.text=[NSString stringWithFormat:@"≈%.2f CNY",[model.closePrice doubleValue]*[model.totalAmount doubleValue]];
        }else{
            self.priceLabel.text=[NSString stringWithFormat:@"≈%@ USD",model.usdPrice];
            self.balanceLabel.text=[NSString stringWithFormat:@"%.8f", [model.totalAmount doubleValue]];
            self.totalLabel.text=[NSString stringWithFormat:@"≈%.2f USD",[model.usdPrice doubleValue]*[model.totalAmount doubleValue]];
        }
       
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
