//
//  YNTextField.m
//  payWallet
//
//  Created by sunliang on 2018/1/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "YNTextField.h"

@implementation YNTextField

- (void)deleteBackward {
  
    [super deleteBackward];
    
    if ([self.yn_delegate respondsToSelector:@selector(ynTextFieldDeleteBackward:)]) {
        [self.yn_delegate ynTextFieldDeleteBackward:self];
    }
}


@end
