//
//  tradeHeaderView.h
//  BiPay
//
//  Created by sunliang on 2018/9/27.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface tradeHeaderView : UIView
+(tradeHeaderView *)instancesectionHeaderViewWithFrame:(CGRect)Rect;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *AddressBtn;

@end

NS_ASSUME_NONNULL_END
