//
//  ConfirmMnemonicController.h
//  BiPay
//
//  Created by 褚青骎 on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

@interface ConfirmMnemonicController : BaseController
@property (nonatomic, strong) NSArray *mnemonicWord;//助记词列表
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *bg_scrollView;
@property(nonatomic,strong)walletModel*model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;

@end
