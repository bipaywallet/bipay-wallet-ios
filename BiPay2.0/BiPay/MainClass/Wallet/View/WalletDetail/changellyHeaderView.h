//
//  changellyHeaderView.h
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalProgressView.h"
NS_ASSUME_NONNULL_BEGIN

@interface changellyHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic)  HorizontalProgressView *horizontalProgressView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageV;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIImageView *circleimageV1;
@property (weak, nonatomic) IBOutlet UIImageView *cicleImageV2;
@property (weak, nonatomic) IBOutlet UILabel *fromAmount;
@property (weak, nonatomic) IBOutlet UILabel *toAmount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property(nonatomic,assign) BOOL isContinuePop;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;

+(changellyHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect;
-(void)setProgressWithLevel:(int)Level WithfromCoin:(NSString*)fromCoin WithToCoin:(NSString*)toCoin;

/**
 上下跳动动画
 */
-(void)ImageSpring;
/**
 旋转动画
 */
-(void)rotate;
@end

NS_ASSUME_NONNULL_END
