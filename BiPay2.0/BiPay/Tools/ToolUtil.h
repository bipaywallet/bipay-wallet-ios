//
//  ToolUtil.h
//  DynamicTraffic 3.0
//
//  Created by pt on 16/6/24.
//  Copyright © 2016年 yundi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToolUtil : NSObject
//加载16进制颜色
+ (UIColor *)colorWithHexString:(NSString *)color;
//
+ (NSString*)checkNullOrEmpty:(id)obj;
+ (BOOL)checkPhoneNumInput:(NSString *)phoneStr;//电话号码匹配
//保存UUID到Keychain
+ (void)save:(NSString *)service data:(id)data;
//keychain中取出UUDI
+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

//根据时间戳取得时间 xx年xx月xx日  单位：毫秒
+ (NSString *)birthdayFormatWithStamp:(NSInteger)stamp withFormat:(NSString *)format;
//转换成code
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
//根据当前时间 ->年月日时分
+ (NSString *)printDateStringWithNowDate:(NSString *)format;

//截图
+ (UIImage *)screenShot;

//输入框只能输入中文，字母，数字
+ (BOOL)textfiledOnlyCanInputWithText:(NSString *)text;

//获取UTC时间
+ (NSString *)presentDateTransformUTCdateWithFormat:(NSString *)format;
//根据当前时间 输出
+ (NSDate *)getDatewithString:(NSString *)time;

//转换成时间戳
+ (long  long)returnHowManyMintesswithstr:(NSString *)timeStr;
//匹配6-20位的密码
+ (BOOL)matchPassword:(NSString *)password;
 //匹配邮箱帐号
+ (BOOL)matchEmail:(NSString *)email;
+(NSString *)stampFormatterWithStamp:(NSInteger)stamp;
//获取当前日期
+ (NSString *)getCurrentTime;
//当日0点
+ (NSDate *)zeroOfDate;

//判断字符串后有几位小数，超过八位就省略
+(NSString *)judgeStringForDecimalPlaces:(NSString *)string;

//判断字符串后有几位小数，超过length位就省略
+(NSString *)judgeStringForDecimalPlaces:(NSString *)string withLength:(int)length;

//MARK:--科学计数法转具体数字
+(NSString *)formartScientificNotationWithString:(NSString *)str;

//MARK:--毫秒时间戳转 HH:mm MM/dd格式
+ (NSString *)convertStrToTime:(NSString *)timeStr;

//MARK:--时间字符串格式化为 HH:mm MM/dd
+(NSString *)transformForTimeString:(NSString *)timeStr;
//doubleNumber,原数据，decimalNum,保留的小数位数
+(NSString*)stringFromNumber:(double)doubleNumber withlimit:(int)decimalNum;

//时间戳转化成年分时秒--yyyy-MM-dd HH:mm:ss
+(NSString*)dateTodateStringWithtime:(NSString*)time;
//HmacSHA512加密
+(NSString *)hmac:(NSMutableDictionary *)dic withKey:(NSString *)key;
@end
