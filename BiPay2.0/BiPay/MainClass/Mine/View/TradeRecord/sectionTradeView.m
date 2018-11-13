//
//  sectionTradeView.m
//  BiPay
//
//  Created by sunliang on 2018/9/27.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "sectionTradeView.h"

@implementation sectionTradeView

+(sectionTradeView *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"sectionTradeView" owner:nil options:nil];
    sectionTradeView*headerView=[nibView objectAtIndex:0];
    headerView.frame=Rect;
    headerView.titleLabel.text=LocalizationKey(@"Recent");
    return headerView;
}
-(void)setconerLayers{
    
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.0];
    
}
-(void)delayMethod{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.topView.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.topView.layer.mask = maskLayer;
}
@end
