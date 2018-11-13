//
//  UIImageView+Extension.m
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)


+ (UIImageView *)dn_imageWithName:(NSString *)imageName{
    
    return [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
}

#pragma mark -- 使用 CAShapeLayer 和 UIBezierPath 设置圆角
- (void)dn_setBezierPathCornerRadius:(CGFloat)radius{
    
    // 创建BezierPath 并设置角 和 半径 这里只设置了 左上 和 右上
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                     cornerRadius:radius];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bounds;
    layer.path  = path.CGPath;
    
    self.layer.mask = layer;
}

- (void)dn_setGraphicsCornerRadius:(CGFloat)radius{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius] addClip];
    [self drawRect:self.bounds];
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束绘制
    UIGraphicsEndImageContext();
}
@end
