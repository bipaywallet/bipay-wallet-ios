//
//  YSActionSheetButton.m
//  ShareAlertDemo
//
//  Created by dev on 2018/5/23.
//  Copyright © 2018年 nys. All rights reserved.
//

#import "YSActionSheetButton.h"

#define kTitlePrecent 0.4
#define kImageViewWH 46  //55

//#define RGB(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@implementation YSActionSheetButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:RGB(40, 40, 40,1) forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark 调整文字的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height * kTitlePrecent;
    CGFloat titleX = 2;
    CGFloat titleY = self.frame.size.height * (1 - kTitlePrecent) + 7;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

#pragma mark 调整图片的位置和尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = kImageViewWH;
    CGFloat imageH = kImageViewWH;
    CGFloat imageX = (self.frame.size.width - kImageViewWH) * 0.5;
    CGFloat imageY = 2;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
