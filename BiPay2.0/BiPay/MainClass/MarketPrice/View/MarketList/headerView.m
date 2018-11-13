//
//  headerView.m
//  BiPay
//
//  Created by sunliang on 2018/9/4.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "headerView.h"

@implementation headerView
+(headerView *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"headerView" owner:nil options:nil];
    
    headerView*headerView=[nibView objectAtIndex:0];
    return headerView;
    
}

@end
