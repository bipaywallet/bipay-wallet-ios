//
//  HomeHeaderView.m
//  BiPay
//
//  Created by sunliang on 2018/9/28.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "HomeHeaderView.h"

@implementation HomeHeaderView
+(HomeHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:nil options:nil];
    HomeHeaderView*headerView=[nibView objectAtIndex:0];
    headerView.frame=Rect;
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
}

@end
