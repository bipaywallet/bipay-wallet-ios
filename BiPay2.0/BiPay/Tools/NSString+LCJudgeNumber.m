//
//  NSString+LCJudgeNumber.m
//  ios_demo
//
//  Created by 刘翀 on 16/6/6.
//  Copyright © 2016年 xinhuo. All rights reserved.
//

#import "NSString+LCJudgeNumber.h"

@implementation NSString (LCJudgeNumber)

+ (BOOL)stringIsNull:(NSString *)string{
    //判断用户名是否为空
    if(string == nil){
        return YES;
    }
    NSString *str = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""]) {
        return YES;
    }
    return NO;//不为空
}

+ (BOOL)checkPassword:(NSString *)password{
    //判断是否是6-16位
    if (password.length >= 6 && password.length <=16) {
        return YES;
    }
    return NO;
}
//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

#pragma mark 正则表达式／判断第一个是否以中文开头的方法
+(BOOL)pipeizimu:(NSString *)string
{
    NSString *firstStr = [string substringToIndex:1];
    //判断是否以字母开头
    NSString *ZIMU = @"/^[a-zA-z]/";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:firstStr] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)isChineseFirst:(NSString *)string
{
    NSString *firstStr = [string substringToIndex:1];
    //是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    //判断是不是中文开头的,buffer->获取字符的字节数据 maxLength->buffer的最大长度 usedLength->实际写入的长度，不需要的话可以传递NULL encoding->字符编码常数，不同编码方式转换后的字节长是不一样的，这里我用了UTF16 Little-Endian，maxLength为2字节，如果使用Unicode，则需要4字节 options->编码转换的选项，有两个值，分别是NSStringEncodingConversionAllowLossy和NSStringEncodingConversionExternalRepresentation range->获取的字符串中的字符范围,这里设置的第一个字符 remainingRange->建议获取的范围，可以传递NULL
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
}
+(NSString *)reviseString:(NSString *)str
{
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    //NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
//MARK:--科学计数法转具体数字 ,如果传输的就是具体数据，可控制其小数点后面最多保留length位
+(NSString *)formartScientificNotationWithString:(NSString *)str withLength:(int)length{
    NSRange eSite;
    BOOL flag;
    NSString *feeStr;
    if ([str containsString:@"E"]) {
        eSite = [str rangeOfString:@"E"];
        flag = YES;
    }else if ([str containsString:@"e"]){
        eSite = [str rangeOfString:@"e"];
        flag = YES;
    }else{
        flag = NO;
    }
    if (flag) {
        double fund = [[str substringWithRange:NSMakeRange(0, eSite.location)] doubleValue];  //把E前面的数截取下来当底数
        double top = [[str substringFromIndex:eSite.location + 1] doubleValue];   //把E后面的数截取下来当指数
        double result = fund * pow(10.0, top);
        feeStr = [NSString stringWithFormat:@"%@",[self stringFromNumber:result withlimit:length]];
    }else{
        feeStr = [self judgeStringForDecimalPlaces:str withLength:length];
    }
    return feeStr;
}
//doubleNumber,原数据，decimalNum,保留的小数位数
+(NSString*)stringFromNumber:(double)doubleNumber withlimit:(int)decimalNum{
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterNoStyle];
    [nFormat setPositiveFormat:@"#####0.000;"];
    [nFormat setMinimumFractionDigits:decimalNum];
    [nFormat setMaximumFractionDigits:decimalNum];
    return [nFormat stringFromNumber:[NSNumber numberWithDouble:doubleNumber]];
}
//MARK:--判断字符串后有几位小数，超过length位就省略
+(NSString *)judgeStringForDecimalPlaces:(NSString *)string withLength:(int)length{
    NSString *numStr = @"";
    NSArray *array = [string componentsSeparatedByString:@"."];
    if (array.count == 2) {
        NSString *str = array[1];
        if (str.length > length) {
            numStr = [NSString stringWithFormat:@"%@",[self stringFromNumber:[string floatValue] withlimit:length]];
        }else{
            numStr = string;
        }
    }else{
        numStr = string;
    }
    return numStr;
}
@end
