//
//  changellyHeaderView.m
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "changellyHeaderView.h"

@implementation changellyHeaderView

+(changellyHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"changellyHeaderView" owner:nil options:nil];
    changellyHeaderView*headerView=[nibView objectAtIndex:0];
    headerView.middleLabel.text=LocalizationKey(@"Inexchange");
    return headerView;
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
       
    }
    return self;
}


-(void)setProgressWithLevel:(int)Level WithfromCoin:(NSString*)fromCoin WithToCoin:(NSString*)toCoin{
   
    self.fromAmount.text=fromCoin;
    self.toAmount.text=toCoin;
    [self.bottomImageV.layer removeAnimationForKey:@"transform.rotation.z"];//先移除之前的动画
    self.headImageV.frame=CGRectMake(SCREEN_WIDTH/2.0-10, 40-20*27/19.0, 20, 20*27/19.0);//先恢复坐标
    if (Level==0) {//确认中
        
        self.lineView1.backgroundColor=lineColor;
        self.lineView2.backgroundColor=lineColor;
        self.circleimageV1.image=UIIMAGE(@"cicleUnacheiver");
        self.cicleImageV2.image=UIIMAGE(@"cicleUnacheiver");
        self.statusLabel.text=LocalizationKey(@"waitConfirm");
        self.headImageV.hidden=NO;
        self.bottomImageV.image=UIIMAGE(@"exchangeComfirming");
        self.topDistance.constant=8;
        [self ImageSpring];
    }else if (Level==1)//兑换中
    {
        self.lineView1.backgroundColor=RGB(27, 176, 230, 1);
        self.lineView2.backgroundColor=lineColor;
        self.circleimageV1.image=UIIMAGE(@"cicleUnacheiver");
        self.cicleImageV2.image=UIIMAGE(@"cicleUnacheiver");
        self.statusLabel.text=LocalizationKey(@"Inexchange");
        self.headImageV.hidden=YES;
        self.bottomImageV.image=UIIMAGE(@"exchangechanging");
        self.topDistance.constant=0;
        [self rotate];
        
        
    }else if (Level==2)//确认中
    {
        self.lineView1.backgroundColor=RGB(27, 176, 230, 1);
        self.lineView2.backgroundColor=lineColor;
        self.circleimageV1.image=UIIMAGE(@"cicleAcheiver");
        self.cicleImageV2.image=UIIMAGE(@"cicleUnacheiver");
        self.statusLabel.text=LocalizationKey(@"waitConfirm");
        self.headImageV.hidden=NO;
        self.bottomImageV.image=UIIMAGE(@"exchangeComfirming");
        [self ImageSpring];
        self.topDistance.constant=8;
        [self.bottomImageV.layer removeAnimationForKey:@"transform.rotation.z"];//先移除之前的动画
        
        
    }else if (Level==3)//兑换成功
    {
        
        self.lineView1.backgroundColor=RGB(27, 176, 230, 1);
        self.lineView2.backgroundColor=RGB(27, 176, 230, 1);
        self.circleimageV1.image=UIIMAGE(@"cicleAcheiver");
        self.cicleImageV2.image=UIIMAGE(@"cicleAcheiver");
        self.statusLabel.text=LocalizationKey(@"Exchangesuccess");
        self.headImageV.hidden=YES;
        self.bottomImageV.image=UIIMAGE(@"changeSuccess");
        self.topDistance.constant=-6;
         [self.bottomImageV.layer removeAnimationForKey:@"transform.rotation.z"];//先移除之前的动画
        
    }else{//失败
        self.lineView1.backgroundColor=lineColor;
        self.lineView2.backgroundColor=lineColor;
        self.circleimageV1.image=UIIMAGE(@"cicleUnacheiver");
        self.cicleImageV2.image=UIIMAGE(@"cicleUnacheiver");
        self.statusLabel.text=LocalizationKey(@"Exchangefail");
        self.headImageV.hidden=YES;
        self.bottomImageV.image=UIIMAGE(@"changeFail");
        [self ImageSpring];
        self.topDistance.constant=-6;
        [self.bottomImageV.layer removeAnimationForKey:@"transform.rotation.z"];//先移除之前的动画
    }
   
}
/**
  上下跳动动画
  */
-(void)ImageSpring{
   
    if (self.isContinuePop) {
        return;//已经跳动的话，禁止跳动
    }
      [self popAnimation];
      self.isContinuePop=YES;
}

-(void)popAnimation{
    
    [UIView animateWithDuration:0.8 animations:^{
        self.headImageV.frame = CGRectMake(self.headImageV.frame.origin.x, self.headImageV.frame.origin.y+10, 20, 20*27/19.0);
    }];
    
    [UIView animateWithDuration:0.8 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.headImageV.frame = CGRectMake(self.headImageV.frame.origin.x, self.headImageV.frame.origin.y-10, 20, 20*27/19.0);
    } completion:^(BOOL finished) {
        [self popAnimation];
    }];
}


/**
 旋转动画
 */
-(void)rotate{
    [self.bottomImageV.layer removeAnimationForKey:@"transform.rotation.z"];//先移除之前的动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 1.5;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion=NO;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.bottomImageV.layer addAnimation:animation forKey:@"transform.rotation.z"];
    
}

@end
