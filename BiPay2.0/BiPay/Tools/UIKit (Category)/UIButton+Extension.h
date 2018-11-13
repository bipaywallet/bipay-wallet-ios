//
//  UIButton+Extension.h
//  DNProject
//
//  Created by zjs on 2018/5/18.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TouchHandler)(void);

typedef NS_ENUM(NSInteger, DNButtonEdgeInsetStyle) {
    // 图片在上，文字在下
    DNButtonEdgeInsetStyleTop,
    // 图片在左，文字在右
    DNButtonEdgeInsetStyleLeft,
    // 图片在下，文字在上
    DNButtonEdgeInsetStyleBottom,
    // 图片在右，文字在左
    DNButtonEdgeInsetStyleRight
};

@interface UIButton (Extension)

/**
 *  @brief  按钮点击事件
 *
 *  @param  touchHandler 点击回调
 */
- (void)dn_addActionHandler:(TouchHandler)touchHandler;

- (void)dn_addActionHandler:(TouchHandler)touchHandler forCntrolEvents:(UIControlEvents)events;


/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


/**
 *  @brief  按钮图文显示
 *
 *  @param  style   图文排列方式
 *  @prama  space   图文相距间隔
 */

- (void)dn_layoutButtonEdgeInset:(DNButtonEdgeInsetStyle)style space:(CGFloat)space;

/**
 *  @brief  倒计时按钮
 *
 *  @param time        倒计时时间
 *  @param startBlock  开始回调
 *  @param finishBlock 完成回调
 */
- (void)startWithTime:(NSInteger)time startBlock:(void(^)(NSString * timeStr))startBlock finishBlock:(void(^)(void))finishBlock;

@end

NS_ASSUME_NONNULL_END
