//
//  NoBalanceView.m
//  BiPay
//
//  Created by sunliang on 2018/9/9.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "NoBalanceView.h"

@implementation NoBalanceView

+(NoBalanceView *)instanceViewWithFrame:(CGRect)Rect{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"NoBalanceView" owner:nil options:nil];
    NoBalanceView*View=[nibView objectAtIndex:0];
    View.backgroundColor=[UIColor clearColor] ;
    View.frame=Rect;
    return View;
}

@end
