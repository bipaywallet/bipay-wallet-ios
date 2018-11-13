//
//  UIColor+Extension.m
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)dn_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
}

+ (UIColor *)dn_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}


#pragma mark - 创建颜色对象（16进制的RGB值）

+ (UIColor *)dn_colorWithRGB:(uint32_t)rgbValue
{
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1.0];
}

#pragma mark - 创建颜色对象（颜色的16进制字符串值）
// 有效格式：#RRGGBB、#RGB、#RRGGBBAA、#RGBA、0xRGB、RRGGBB ...（"#"和"0x"前缀可以省略不写）
+ (instancetype)dn_colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (dn_hexStrToRGBA(hexStr, &r, &g, &b, &a))
    {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

static BOOL dn_hexStrToRGBA(NSString *str, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a)
{
    str = [[str dn_stringByTrim] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB, RGBA, RRGGBB, RRGGBBAA
    if (length < 5) {
        *r = dn_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = dn_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = dn_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = dn_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = dn_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = dn_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = dn_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = dn_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

static inline NSUInteger dn_hexStrToInt(NSString *str)
{
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}
@end
