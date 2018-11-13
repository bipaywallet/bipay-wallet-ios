//
//  HomePlaceholderView.h
//  BiPay
//
//  Created by sunliang on 2018/8/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePlaceholderView : UIView
+(HomePlaceholderView *)instancesViewWithFrame:(CGRect)Rect;
@property (weak, nonatomic) IBOutlet UIButton *creatBtn;
@property (weak, nonatomic) IBOutlet UIButton *importBtn;

@end
