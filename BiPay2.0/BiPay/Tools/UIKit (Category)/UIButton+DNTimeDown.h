//
//  UIButton+DNTimeDown.h
//  DNProject
//
//  Created by zjs on 2018/5/16.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DNTimeDown)
/**
 *  @brief 倒计时按钮
 
 *  @param time        倒计时时间
 *  @param title       未开始时title
 *  @param downTitle   开始倒计时标题
 */
- (void)startWithTime:(NSInteger)time title:(NSString *)title downTitle:(NSString *)downTitle;

@end
