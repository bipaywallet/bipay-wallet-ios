//
//  TextFieldView.h
//  yy
//
//  Created by sunliang on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNTextField.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^GetBackBlock)(NSString * string);
@interface TextFieldView : UIView<UITextFieldDelegate,YNTextFieldDelegate>

@property (weak, nonatomic) IBOutlet YNTextField *TF1;
@property (weak, nonatomic) IBOutlet YNTextField *TF2;
@property (weak, nonatomic) IBOutlet YNTextField *TF3;
@property (weak, nonatomic) IBOutlet YNTextField *TF4;
@property (weak, nonatomic) IBOutlet YNTextField *TF5;
@property (weak, nonatomic) IBOutlet YNTextField *TF6;
@property (weak, nonatomic) IBOutlet YNTextField *TF7;
@property (weak, nonatomic) IBOutlet YNTextField *TF8;
@property (weak, nonatomic) IBOutlet YNTextField *TF9;
@property (weak, nonatomic) IBOutlet YNTextField *TF10;
@property (weak, nonatomic) IBOutlet YNTextField *TF11;
@property (weak, nonatomic) IBOutlet YNTextField *TF12;
@property (nonatomic, copy) GetBackBlock getBackBlock;
@property (weak, nonatomic) IBOutlet UILabel *alertlabel;

-(NSString*)checkstring:(UIView*)view;
@end

NS_ASSUME_NONNULL_END
