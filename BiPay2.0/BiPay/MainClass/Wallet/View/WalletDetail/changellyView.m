//
//  changellyView.m
//  BiPay
//
//  Created by sunliang on 2018/10/24.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "changellyView.h"

@implementation changellyView

-(void)hideView{
    [self removeFromSuperview];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.topLabel.text=LocalizationKey(@"Reminder");
    [self.knowBtn setTitle:LocalizationKey(@"knowBtn") forState:UIControlStateNormal];
     self.heightConstant.constant=[self getLabelHeightWithText:LocalizationKey(@"changeinfo") width:260 font:13]+150;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
       
        
    }
    return self;
}
- (IBAction)IKonw:(id)sender {
    [self hideView];
    
}


- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    return rect.size.height;
}

@end
