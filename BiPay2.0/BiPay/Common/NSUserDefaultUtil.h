//
//  NSUserDefaultUtil.h
//  siLuBi
//
//  Created by sunliang on 2018/1/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultUtil : NSObject
+(void)PutBoolDefaults:(NSString *)key Value:(BOOL)value;
+(void)PutDefaults:(NSString *)key Value:(id)value;
+(id)GetDefaults:(NSString *)key;
//存储int类型数据
+(void)PutNumberDefaults:(NSString *)key Value:(NSNumber*)ID;
//取出int类型数据
+(NSNumber*)GetNumberDefaults:(NSString *)key;
@end
