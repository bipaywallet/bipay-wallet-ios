//
//  shareView.m
//  BiPay
//
//  Created by sunliang on 2018/11/5.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "shareView.h"

@implementation shareView

+(shareView *)instancesViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"shareView" owner:nil options:nil];
    shareView*shareview=[nibView objectAtIndex:0];
    shareview.frame=Rect;
    return shareview;
    
}

@end
