//
//  NSObject+BGKVTool.m
//  BGFMDBTest
//
//  Created by zsm on 2018/9/18.
//  Copyright © 2018年 zsm. All rights reserved.
//

#import "NSObject+BGKVTool.h"
#import "BGTool.h"
@implementation NSObject (BGKVTool)

+ (NSString*)bg_sqlKey:(NSString* )key{
    return [NSString stringWithFormat:@"%@%@",@"BG_",key];
}

/**
 转换OC对象成数据库数据.
 */
+ (NSString*)bg_sqlValue:(id)value{
    
    if([value isKindOfClass:[NSNumber class]]) {
        return value;
    }else if([value isKindOfClass:[NSString class]]){
        return [NSString stringWithFormat:@"'%@'",value];
    }else{
        NSString* type = [NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([value class])];
        value = [BGTool getSqlValue:value type:type encode:YES];
        if ([value isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"'%@'",value];
        }else{
            return value;
        }
    }
}
@end
