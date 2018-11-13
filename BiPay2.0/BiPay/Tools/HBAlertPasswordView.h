//
//  HBAlertPasswordView.h
//  TestPassward
//
//  Created by JING XU on 17/5/21.
//  Copyright © 2017年 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBAlertPasswordView;

@protocol HBAlertPasswordViewDelegate <NSObject>

/**
 确定按钮的执行方法
 */
- (void)sureActionWithAlertPasswordView:(HBAlertPasswordView *)alertPasswordView password:(NSString *)password;

@end

@interface HBAlertPasswordView : UIView

/** 协议 */
@property (nonatomic, assign) id<HBAlertPasswordViewDelegate> delegate;

@end
