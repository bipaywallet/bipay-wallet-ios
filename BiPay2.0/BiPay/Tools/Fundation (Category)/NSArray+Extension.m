//
//  NSArray+Extension.m
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

#pragma mark -- 数组转 json 字符串
- (NSString *)dn_toJsonStrng
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        
        NSError * error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&error];
        if (error)
        {
            NSLog(@"数组转JSON字符串失败：%@", error);
        }
        return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark -- 数组倒序
- (NSArray *)dn_reverse
{
    return [[self reverseObjectEnumerator] allObjects];
}

@end

@implementation NSMutableArray (Extension)



//static inline BOOL dn_isEmpty(id thing)
//{
//    return thing == nil ||
//    [thing isEqual:[NSNull null]] ||
//    [thing isEqualToString:@"null"] ||
//    [thing isEqualToString:@"(null)"] ||
//    ([thing respondsToSelector:@selector(length)]
//     && [(NSData *)thing length] == 0) ||
//    ([thing respondsToSelector:@selector(count)]
//     && [(NSArray *)thing count] == 0);
//}
@end
