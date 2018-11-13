//
//  NSString+Extension.h
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString  *const XCColorKey = @"color";
static NSString  *const XCFontKey = @"font";
static NSString  *const XCRangeKey = @"range";

/**
 * @brief range的校验结果
 */
typedef enum
{
    RangeCorrect = 0,
    RangeError = 1,
    RangeOut = 2,
    
}RangeFormatType;

@interface NSString (Extension)

/**
 *  汉字的拼音
 *
 *  @return 拼音
 */
- (NSString *)pinyin;

/** 验证字符串是否为空 */
+(BOOL)stringIsNull:(NSString *)string;

/** 判断是否是有效的(非空/非空白)字符串 */
- (BOOL)dn_isValidString;

/** 判断是否包含指定字符串 */
- (BOOL)dn_containsString:(NSString *)string;

/* 修剪字符串（去掉头尾两边的空格和换行符）*/
- (NSString *)dn_stringByTrim;

/** md5加密 */
- (nullable NSString *)dn_md5String;

/**
 *  @brief  获取文本的大小
 *
 *  @param  font           文本字体
 *  @param  maxSize        文本区域的最大范围大小
 *  @param  linewdeakMode  字符截断类型
 *
 *  @return 文本大小
 */
- (CGSize)dn_getTextSize:(UIFont *)font
                 maxSize:(CGSize)maxSize
                    mode:(NSLineBreakMode)linewdeakMode;

/**
 *  @brief  获取文本的宽度
 *
 *  @param  font    文本字体
 *  @param  height  文本高度
 *
 *  @return 文本宽度
 */
- (CGFloat)dn_getTextWidth:(UIFont *)font height:(CGFloat)height;

/**
 *  @brief  获取文本的高度
 *
 *  @param  font   文本字体
 *  @param  width  文本宽度
 *
 *  @return 文本高度
 */
- (CGFloat)dn_getTextHeight:(UIFont *)font width:(CGFloat)width;


///==================================================
///             正则表达式
///==================================================

/** 判断是否是有效的手机号 */
- (BOOL)dn_isValidPhoneNumber;

/** 判断是否是有效的用户密码 */
- (BOOL)dn_isValidPassword;

/** 判断是否是有效的用户名（20位的中文或英文）*/
- (BOOL)dn_isValidUserName;

/** 判断是否是有效的邮箱 */
- (BOOL)dn_isValidEmail;

/** 判断是否是有效的URL */
- (BOOL)isValidUrl;

/** 判断是否是有效的银行卡号 */
- (BOOL)dn_isValidBankNumber;

/** 判断是否是有效的身份证号 */
- (BOOL)dn_isValidIDCardNumber;

/** 判断是否是有效的IP地址 */
- (BOOL)dn_isValidIPAddress;

/** 判断是否是纯汉字 */
- (BOOL)dn_isValidChinese;

/** 判断是否是邮政编码 */
- (BOOL)dn_isValidPostalcode;

/** 判断是否是工商税号 */
- (BOOL)dn_isValidTaxNo;

/** 判断是否是车牌号 */
- (BOOL)dn_isCarNumber;

/** 通过身份证获取性别（1:男, 2:女） */
- (nullable NSNumber *)dn_getGenderFromIDCard;

/** 隐藏证件号指定位数字（如：360723********6341） */
- (nullable NSString *)dn_hideCharacters:(NSUInteger)location length:(NSUInteger)length;

#pragma mark - 改变单个范围字体的大小和颜色
/**
 *  @brief 改变字体的颜色
 *
 *  @param color 颜色（UIColor）
 *  @param range 范围（NSRange）
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeColor:(UIColor *)color
                                  andRange:(NSRange)range;


/**
 *  @brief 改变字体大小
 *
 *  @param font  字体大小(UIFont)
 *  @param range 范围(NSRange)
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeFont:(UIFont *)font
                                 andRange:(NSRange)range;


/**
 *  @brief 改变字体的颜色和大小
 *
 *  @param color      字符串的颜色
 *  @param colorRange 需要改变颜色的字符串范围
 *  @param font       字体大小
 *  @param fontRange  需要改变字体大小的字符串范围
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */

- (NSMutableAttributedString *)changeColor:(UIColor *)color
                              andColorRang:(NSRange)colorRange
                                   andFont:(UIFont *)font
                              andFontRange:(NSRange)fontRange;


#pragma mark - 改变多个范围内的字体和颜色

/**
 *  @brief 改变多段字符串为一种颜色
 *
 *  @param color  字符串的颜色
 *  @param ranges 范围数组:[NSValue valueWithRange:NSRange]
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeColor:(UIColor *)color andRanges:(NSArray<NSValue *> *)ranges;

/**
 *  @brief 改变多段字符串为同一大小
 *
 *  @param font   字体大小
 *  @param ranges 范围数组:[NSValue valueWithRange:NSRange]
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeFont:(UIFont *)font andRanges:(NSArray<NSValue *> *)ranges;
/**
 *  @brief 用于多个位置颜色和大小改变
 *
 *  @param changes 对应属性改变的数组.示例:@[@{XCColorKey:UIColor,XCFontKey:UIFont,XCRangeKey:NSArray<NSValue *>}];
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeColorAndFont:(NSArray<NSDictionary *> *)changes;

#pragma mark - 给字符串添加中划线
/**
 *  @brief  添加中划线
 *
 *  @return 富文本
 */
- (NSMutableAttributedString *)addCenterLine;

#pragma mark - 给字符串添加下划线
/**
 *  @brief  添加下划线
 *
 *  @return 富文本
 */
- (NSMutableAttributedString *)addDownLine;

@end
NS_ASSUME_NONNULL_END
