//
//  BIPayTools.h
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BIPayTools : NSObject

/**
 常见 Label 创建
 
 @param    text          内容
 @param    color         字体颜色
 @param    fontSize      字体大小
 @param    textAlignment 对齐方式
 */
+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)color
                  fontSize:(CGFloat)fontSize
             textAlignment:(NSTextAlignment)textAlignment;
@end
