//
//  LeftMenuViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^BackBlock) (UIButton *);
@interface UIViewController (LeftSlide)<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,assign) BOOL isOpen;
//返回按钮
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, copy) BackBlock backBlock;
-(void)show;
-(void)hide;
-(void)initSlideFoundation;
-(void)backBtnNoNavBar:(BOOL)noNavBar normalBack:(BOOL)normalBack;
@end
