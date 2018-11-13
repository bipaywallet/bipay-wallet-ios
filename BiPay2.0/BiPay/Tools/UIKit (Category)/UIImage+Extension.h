//
//  UIImage+Extension.h
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

/** 颜色返回一张图片 */
+ (nullable UIImage *)dn_imageWithColor:(UIColor *)color;

/** 颜色返回一张图片(图片大小) */
+ (nullable UIImage *)dn_imageWithColor:(UIColor *)color size:(CGSize)size;

/** 图片滤镜效果 */
- (nullable UIImage *)dn_addFillter:(NSString *)filterName;

/** 图片不透明度 */
- (nullable UIImage *)dn_imageAlpha:(CGFloat)alpha;

/** 设置图片圆角 */
- (nullable UIImage *)dn_imageCornerRadius:(CGFloat)radius;

/**
 *  @brief  图片圆角、边框、边框颜色
 *
 *  @param  radius      圆角半径
 *  @param  borderWidth 边框宽度
 *  @param  borderColor 边框颜色
 */
- (nullable UIImage *)dn_imageCornerRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                boderColor:(nullable UIColor *)borderColor;
@end

NS_ASSUME_NONNULL_END
