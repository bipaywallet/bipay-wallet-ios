//
//  changeHistoryCell.m
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "changeHistoryCell.h"
@interface changeHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fasonglabel;
@property (weak, nonatomic) IBOutlet UILabel *shoudaoLabel;

@end
@implementation changeHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeLabel.text=LocalizationKey(@"dealTime");
    self.fasonglabel.text=LocalizationKey(@"Sendaddress");
    self.shoudaoLabel.text=LocalizationKey(@"Receivingaddress");
    // Initialization code
}
-(void)configModel:(changeModel*)model{
   
    self.fromCoin.text=[NSString stringWithFormat:@"%@ %@",model.fromCoin,model.fromAmount];
    self.toCoin.text=[NSString stringWithFormat:@"%@ %@",model.toCoin,model.toAmount];
    self.creatTime.text=model.time;
    self.fromAddress.text=model.fromAddress;
    self.toAddress.text=model.toAddress;
    self.rate.text=[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"exchangeRate"),[self getsingleRate:model.rate WithTocoin:model.toCoin]];
    if ([model.status intValue]==0) {
        self.status.text=LocalizationKey(@"waitConfirm");
        self.status.textColor=RedColor;
    }else if ([model.status intValue]==1)
    {
        self.status.text=LocalizationKey(@"Inexchange");
         self.status.textColor=RedColor;
    }
    else if ([model.status intValue]==2)
    {
        self.status.text=LocalizationKey(@"waitConfirm");
         self.status.textColor=RedColor;
    }
    else if ([model.status intValue]==3)
    {
        self.status.text=LocalizationKey(@"Exchangesuccess");
         self.status.textColor=RGB(19, 126, 174, 1);
    }else{
        self.status.text=LocalizationKey(@"Exchangefail");
         self.status.textColor=RedColor;
    }
    
}
-(NSString*)getsingleRate:(NSString*)rate WithTocoin:(NSString*)tocoin{
    NSArray *array = [rate componentsSeparatedByString:@"≈"];
    NSMutableString* str=[[NSMutableString alloc]initWithString:[array lastObject]];
    NSRange ange={1,str.length-1-tocoin.length};
    NSString* lastStr=[str substringWithRange:ange];
    return lastStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
