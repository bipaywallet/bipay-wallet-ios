//
//  shareView.h
//  BiPay
//
//  Created by sunliang on 2018/11/5.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface shareView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *ercodeImageV;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
+(shareView *)instancesViewWithFrame:(CGRect)Rect;
@end

NS_ASSUME_NONNULL_END
