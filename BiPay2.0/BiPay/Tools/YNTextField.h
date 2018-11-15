//
//  YNTextField.h
//  payWallet
//
//  Created by sunliang on 2018/1/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@class YNTextField;



@protocol YNTextFieldDelegate <NSObject>

- (void)ynTextFieldDeleteBackward:(YNTextField *)textField;

@end



@interface YNTextField : UITextField

@property (nonatomic, assign) id <YNTextFieldDelegate> yn_delegate;


@end
