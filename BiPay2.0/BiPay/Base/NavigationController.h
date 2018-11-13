//
//  NavigationController.h
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController

/**
 *  @brief  自定义初始化方法
 *
 *  @param  root        控制器
 *  @param  title       标题
 *  @param  nomalImage  未选中状态图片
 *  @param  selectImage 选中状态图片
 */
- (instancetype)initWithRootViewController:(UIViewController *)root
                                     title:(NSString *)title
                               normalImage:(NSString *)nomalImage
                               selectImage:(NSString *)selectImage;
@end
