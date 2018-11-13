//
//  confirmTransferView.m
//  BiPay
//
//  Created by sunliang on 2018/10/10.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "confirmTransferView.h"
@interface confirmTransferView ()
@property (weak, nonatomic) IBOutlet UILabel *amountTitle;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;
@property (weak, nonatomic) IBOutlet UILabel *feeTitle;

@end
@implementation confirmTransferView

-(void)hideView{
    CGAffineTransform translates = CGAffineTransformTranslate(CGAffineTransformIdentity,0,self.boardView.frame.size.height);
    self.boardView.transform =CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    [UIView animateWithDuration:0.01 delay:0.01 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.boardView.transform = translates;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)closeClick:(id)sender {
    [self hideView];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.amountTitle.text=LocalizationKey(@"transferMoney");
    self.addressTitle.text=LocalizationKey(@"inAddress");
    self.feeTitle.text=LocalizationKey(@"fee");
    self.tipsLabel.text=LocalizationKey(@"Remarkssee");
    [self.confirmbtn setTitle:LocalizationKey(@"confirmBtn") forState:UIControlStateNormal];
}

@end
