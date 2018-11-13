//
//  UIImage+Extension.m
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)dn_imageWithColor:(UIColor *)color{
    
    return [self dn_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)dn_imageWithColor:(UIColor *)color size:(CGSize)size{
    
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  滤镜名字：OriginImage(原图)、CIPhotoEffectNoir(黑白)、CIPhotoEffectInstant(怀旧)、CIPhotoEffectProcess(冲印)、CIPhotoEffectFade(褪色)、CIPhotoEffectTonal(色调)、CIPhotoEffectMono(单色)、CIPhotoEffectChrome(铬黄)
 *
 *  灰色：CIPhotoEffectNoir //黑白
 */
- (UIImage *)dn_addFillter:(NSString *)filterName
{
    if ([filterName isEqualToString:@"OriginImage"]) {
        return self;
    }
    // 将 UIImage 装成 CIImage
    CIImage * ciImage = [[CIImage alloc]initWithImage:self];
    // 创建滤镜
    CIFilter * filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey,ciImage, nil];
    // 已有值不变，其他的设置为默认值
    [filter setDefaults];
    // 获取绘制上下文
    CIContext * context = [CIContext contextWithOptions:nil];
    // 渲染并输出 CIImage
    CIImage * outputImage = [filter outputImage];
    // 创建 CGImage 句柄
    CGImageRef cgImgaeRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    // 获取图片
    UIImage * image = [UIImage imageWithCGImage:cgImgaeRef];
    // 释放 CGImage 句柄
    CGImageRelease(cgImgaeRef);
    return image;
}
/** 图片透明度 */
- (UIImage *)dn_imageAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, - rect.size.height);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextSetAlpha(context, alpha);
    CGContextDrawImage(context, rect, self.CGImage);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
/** 设置圆角 */
- (UIImage *)dn_imageCornerRadius:(CGFloat)radius
{
    return [self dn_imageCornerRadius:radius borderWidth:0.0f boderColor:nil];
    
}
/** 设置圆角、边框 */
- (UIImage *)dn_imageCornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth boderColor:(UIColor *)borderColor
{
    
    return [self dn_imageByRoundCornerRadius:radius
                                     corners:UIRectCornerAllCorners
                                 borderWidth:borderWidth
                                 borderColor:borderColor
                              borderLineJoin:kCGLineJoinMiter];
}

#pragma mark - 设置圆角图片
// corners：需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
- (UIImage *)dn_imageByRoundCornerRadius:(CGFloat)radius
                                 corners:(UIRectCorner)corners
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor
                          borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
