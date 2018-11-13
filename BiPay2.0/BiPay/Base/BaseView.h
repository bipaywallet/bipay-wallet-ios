//
//  BaseView.h
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

/** 找到该视图的super ViewController */
- (UIViewController *)viewForSuperBaseView;
@end
