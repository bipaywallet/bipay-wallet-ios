//
//  UIColor+Extension.h
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)

/**
 *  @breif  创建颜色对象
 *
 *  @param  rgbValue  16进制的RGB值（如：0x66ccff）
 *  @return 颜色对象
 */
+ (UIColor *)dn_colorWithRGB:(uint32_t)rgbValue;

/**
 *  创建颜色对象
 *
 *  @param hexStr  颜色的16进制字符串值（格式如：@"#66ccff", @"#6cf", @"#66ccff88", @"#6cf8", @"0x66ccff", @"66ccff"...）
 *
 *  @return 颜色对象
 */
+ (nullable UIColor *)dn_colorWithHexString:(NSString *)hexStr;

/**
 *  @brief  创建颜色（默认透明度 1.0f）
 *
 *  @param  red     红色
 *  @param  green   绿色
 *  @param  blue    蓝色
 */
+ (UIColor *)dn_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/**
 *  @brief  创建颜色
 *
 *  @param  red     红色
 *  @param  green   绿色
 *  @param  blue    蓝色
 *  @param  alpha   透明度
 */
+ (UIColor *)dn_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
