//
//  changellyView.h
//  BiPay
//
//  Created by sunliang on 2018/10/24.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface changellyView : UIView
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;

-(void)hideView;
@end

NS_ASSUME_NONNULL_END
