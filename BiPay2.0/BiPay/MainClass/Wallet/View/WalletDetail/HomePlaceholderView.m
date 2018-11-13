//
//  HomePlaceholderView.m
//  BiPay
//
//  Created by sunliang on 2018/8/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "HomePlaceholderView.h"

@implementation HomePlaceholderView

+(HomePlaceholderView *)instancesViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HomePlaceholderView" owner:nil options:nil];
    HomePlaceholderView*placeView=[nibView objectAtIndex:0];
    placeView.frame=Rect;
    placeView.backgroundColor=HomeNavColor;
    return placeView;
    
}

@end
