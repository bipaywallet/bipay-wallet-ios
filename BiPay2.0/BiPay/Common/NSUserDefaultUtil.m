//
//  NSUserDefaultUtil.m
//  siLuBi
//
//  Created by sunliang on 2018/1/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "NSUserDefaultUtil.h"

@implementation NSUserDefaultUtil
//存储布尔数据
+(void)PutBoolDefaults:(NSString *)key Value:(BOOL)value{
    if (key!=NULL) {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setBool:value forKey:key];
        [userDefaults synchronize];//同步存储数据
    }
}
+(void)PutDefaults:(NSString *)key Value:(id)value{
    if (key!=NULL&&value!=NULL) {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:value forKey:key];
        [userDefaults synchronize];//同步存储数据
        
    }
}
+(id)GetDefaults:(NSString *)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    id obj;
    if (key!=NULL) {
        obj=[userDefaults objectForKey:key];
    }
    return obj;
}
//存储NSNumber类型数据
+(void)PutNumberDefaults:(NSString *)key Value:(NSNumber*)ID{
    if (key!=NULL) {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setObject: ID  forKey:key];
        [userDefaults synchronize];//同步存储数据
    }
}
//取出NSNumber类型数据
+(NSNumber*)GetNumberDefaults:(NSString *)key {
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSNumber* obj;
    if (key!=NULL) {
        obj=[userDefaults objectForKey:key];
        
    }
    return obj;
}

@end
