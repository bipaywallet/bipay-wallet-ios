//
//  tradeHeaderView.m
//  BiPay
//
//  Created by sunliang on 2018/9/27.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "tradeHeaderView.h"

@implementation tradeHeaderView

+(tradeHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"tradeHeaderView" owner:nil options:nil];
    tradeHeaderView*headerView=[nibView objectAtIndex:0];
    headerView.frame=Rect;
    [headerView.AddressBtn setTitle:LocalizationKey(@"copy") forState:UIControlStateNormal];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
}

@end
