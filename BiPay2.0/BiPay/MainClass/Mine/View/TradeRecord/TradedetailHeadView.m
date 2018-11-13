//
//  TradedetailHeadView.m
//  BiPay
//
//  Created by zjs on 2018/6/20.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "TradedetailHeadView.h"

@implementation TradedetailHeadView

- (void)setControlForSuper
{
    self.tradetype = [UIImageView dn_imageWithName:@"行情详情_11"];
    
    self.tradeTitle = [BIPayTools labelWithText:LocalizationKey(@"transfer")
                                      textColor:DealTitleColor
                                       fontSize:fontSize(14)
                                  textAlignment:NSTextAlignmentLeft];
    
    self.trademoney = [BIPayTools labelWithText:@"+1900000.00"
                                      textColor:[UIColor whiteColor]
                                       fontSize:fontSize(26)
                                  textAlignment:NSTextAlignmentCenter];
    
    
   
    
    self.tradeStatu = [BIPayTools labelWithText:LocalizationKey(@"completed")
                                      textColor:DealTitleColor
                                       fontSize:fontSize(14)
                                  textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.tradetype];
    [self addSubview:self.tradeTitle];
    [self addSubview:self.trademoney];
    [self addSubview:self.tradeStatu];
}

- (void)addConstraintsForSuper
{
    [self.trademoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.width.mas_offset(SCREEN_WIDTH*0.8);
    }];
    
    [self.tradeStatu mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.trademoney.mas_bottom).mas_offset(8);
        make.width.mas_offset(SCREEN_WIDTH*0.9);
    }];
    
    [self.tradetype mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.mas_right).inset(SCREEN_WIDTH*0.5);
        make.bottom.mas_equalTo(self.trademoney.mas_top).mas_offset(-8);
        make.height.width.mas_offset(spaceSize(25));
    }];
    
    
    [self.tradeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.tradetype);
        make.left.mas_equalTo(self.tradetype.mas_right).mas_offset(8);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setControlForSuper];
        [self addConstraintsForSuper];
        self.backgroundColor = CellBackColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [lineColor set];
    
    path.lineWidth = 1;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [path stroke];
}

@end
