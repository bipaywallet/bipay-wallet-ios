//
//  UIButton+indexPath.m
//  BiPay
//
//  Created by zsm on 2018/9/29.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UIButton+indexPath.h"

static NSString *Key = @"indexPath";
@implementation UIButton (indexPath)
- (void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, &Key, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, &Key);
}
@end
