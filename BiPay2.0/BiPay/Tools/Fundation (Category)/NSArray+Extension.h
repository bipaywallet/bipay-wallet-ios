//
//  NSArray+Extension.h
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSArray (Extension)

/** 数组转 json 字符串*/
- (nullable NSString *)dn_toJsonStrng;

/** 数组倒序 */
- (NSArray *)dn_reverse;

@end

@interface NSMutableArray (Extension)

@end

NS_ASSUME_NONNULL_END
