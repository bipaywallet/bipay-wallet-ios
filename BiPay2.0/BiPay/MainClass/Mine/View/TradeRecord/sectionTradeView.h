//
//  sectionTradeView.h
//  BiPay
//
//  Created by sunliang on 2018/9/27.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface sectionTradeView : UIView
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(sectionTradeView *)instancesectionHeaderViewWithFrame:(CGRect)Rect;
-(void)setconerLayers;
@end

NS_ASSUME_NONNULL_END
