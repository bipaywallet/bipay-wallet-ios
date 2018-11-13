//
//  NSObject+BGKVTool.h
//  BGFMDBTest
//
//  Created by zsm on 2018/9/18.
//  Copyright © 2018年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BGKVTool)
+ (NSString*)bg_sqlKey:(NSString* )key;

/**
 转换OC对象成数据库数据.
 */
+ (NSString*)bg_sqlValue:(id)value;
@end
