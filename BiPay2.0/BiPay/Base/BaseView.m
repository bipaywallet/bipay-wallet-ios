//
//  BaseView.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (UIViewController *)viewForSuperBaseView{
    
    for (UIView * next = self.superview; next; next = next.superview)
    {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
