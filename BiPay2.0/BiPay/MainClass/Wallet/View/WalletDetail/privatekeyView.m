//
//  privatekeyView.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "privatekeyView.h"

@implementation privatekeyView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //[self removeFromSuperview];
}
- (IBAction)close:(id)sender {
    [self hideView];
}
-(void)hideView{
    CGAffineTransform translates = CGAffineTransformTranslate(CGAffineTransformIdentity,0,self.boardView.frame.size.height);
    self.boardView.transform =CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    [UIView animateWithDuration:0.01 delay:0.01 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.boardView.transform = translates;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/**
 复制
 */
- (IBAction)copyClick:(UIButton *)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:self.keyLabel.text];
    if (pab == nil) {
        [self makeToast:LocalizationKey(@"copyFail") duration:1.5 position:CSToastPositionCenter];
    }else
    {
        [self makeToast:LocalizationKey(@"copySuccess") duration:1.5 position:CSToastPositionCenter];
        sender.backgroundColor=BtnBackGrayDisableColor;
        sender.userInteractionEnabled=NO;
        [sender setTitle:LocalizationKey(@"copyed") forState:UIControlStateNormal];
        [sender setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
