//
//  ImportDetailController.h
//  BiPay
//
//  Created by sunliang on 2018/6/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

@interface ImportDetailController : BaseController
@property (weak, nonatomic) IBOutlet UIView *mnemonicContainer;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *passwordPrompt;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *userTerms;
@property (weak, nonatomic) IBOutlet UIButton *leadInBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *bg_scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgview;

- (id)initWithType:(NSString *)type;

@end
