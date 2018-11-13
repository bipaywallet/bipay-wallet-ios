//
//  MarketPriceController.h
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

@class MarketPriceController;

@protocol LYSSlideMenuControllerDelegate<NSObject>

/**
 子视图第一次加载页面,和系统的viewDidLoad方法具有一样的效果,视图第一次加载时执行,因此在使用这个第三方的时候,要把viewDidLoad里面的操作放到这个代理方法里面执行,避免出现一些布局错乱的问题
 
 @param slideMenuController 主视图控制器
 @param index 页面下标
 */
- (void)slideMenuController:(MarketPriceController *)slideMenuController didViewDidLoad:(NSInteger)index;

@optional
// 页面生命周期方法
- (void)slideMenuController:(MarketPriceController *)slideMenuController viewWillAppear:(NSInteger)index;
- (void)slideMenuController:(MarketPriceController *)slideMenuController viewDidAppear:(NSInteger)index;
- (void)slideMenuController:(MarketPriceController *)slideMenuController viewWillDisappear:(NSInteger)index;
- (void)slideMenuController:(MarketPriceController *)slideMenuController viewDidDisappear:(NSInteger)index;

@end

@interface MarketPriceController : UIViewController

@property (nonatomic,strong,readonly)UIScrollView *menuScrollView;
@property (nonatomic,strong,readonly)UIScrollView *contentScrollView;

/**
 一个页面显示几个按钮
 */
@property (nonatomic,assign)NSInteger pageNumberOfItem;

@property (nonatomic,assign)NSInteger currentItem;
@property (nonatomic,assign)CGFloat menuHeight;

/**
 顶部菜单数据
 */
@property (nonatomic,strong)NSArray<NSString *> *titles;

@property (nonatomic,assign)BOOL showBottomLine;
@property (nonatomic,assign)CGFloat bottomLineHeight;
@property (nonatomic,assign)CGFloat bottomLineWidth;
@property (nonatomic,strong)UIColor *bottomLineColor;

@property (nonatomic,strong)UIFont *titleFont;
@property (nonatomic,strong)UIFont *titleSelectFont;

@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *titleSelectColor;

/**
 内容页面控制器菜单(为了避免页面显示时候,同时加载多个页面数据,可以遵循LYSSlideMenuControllerDelegate代理,在代理方法里面进行数据加载)
 */
@property (nonatomic,strong)NSArray<UIViewController<LYSSlideMenuControllerDelegate> *> *controllers;
@end

