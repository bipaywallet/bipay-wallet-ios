//
//  confirmTransferView.h
//  BiPay
//
//  Created by sunliang on 2018/10/10.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface confirmTransferView : UIView
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (weak, nonatomic) IBOutlet UILabel *confirmTitle;
@property (weak, nonatomic) IBOutlet UIButton *confirmbtn;
@property (weak, nonatomic) IBOutlet UILabel *amountlabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarklabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heghtConstant;

-(void)hideView;
@end

NS_ASSUME_NONNULL_END

