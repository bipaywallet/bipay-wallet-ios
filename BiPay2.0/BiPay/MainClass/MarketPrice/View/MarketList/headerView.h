//
//  headerView.h
//  BiPay
//
//  Created by sunliang on 2018/9/4.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headerView : UIView
@property (weak, nonatomic) IBOutlet UILabel *assetNameLAb;
@property (weak, nonatomic) IBOutlet UILabel *aNewsPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *appliesLab;
+(headerView *)instancesectionHeaderViewWithFrame:(CGRect)Rect;
@end
