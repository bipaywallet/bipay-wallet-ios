//
//  TabBarController.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"
#import "WalletController.h"
#import "MineController.h"
#import "marketViewController.h"
@interface TabBarController ()

@end

@implementation TabBarController

#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTabBarTheme];
    [self setControlForSuper];
    
}
#pragma mark -- didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- setControlForSuper
- (void)setControlForSuper
{
    WalletController * wallet = [[WalletController alloc]init];
    NavigationController * walletVc = [[NavigationController alloc]initWithRootViewController:wallet
                                                                                        title:LocalizationKey(@"wallet")
                                                                                  normalImage:@"首页灰色_03"
                                                                                  selectImage:@"首页-0"];
    
    marketViewController * market = [[marketViewController alloc]init];
    NavigationController * marketVc = [[NavigationController alloc]initWithRootViewController:market
                                                                                        title:LocalizationKey(@"market")
                                                                                  normalImage:@"行情灰色"
                                                                                  selectImage:@"行情_07"];
    
   
    
    MineController * mine = [[MineController alloc]init];
    NavigationController * mineVc = [[NavigationController alloc]initWithRootViewController:mine
                                                                                      title:LocalizationKey(@"mine")
                                                                                  normalImage:@"设置灰色"
                                                                                  selectImage:@"设置_31"];
    
    self.viewControllers = @[walletVc,marketVc,mineVc];
}

#pragma mark -- addConstrainsForSuper
- (void)addConstrainsForSuper{
    
    
}

#pragma mark -- target Methods

- (void)setupTabBarTheme
{
    UITabBar * tabBar = [UITabBar appearance];
    tabBar.tintColor  = barColor;
}

//MARK:--重置tabar标题 国际化
-(void)resettabarItemsTitle{
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    item1.title=LocalizationKey(@"wallet");
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    item2.title=LocalizationKey(@"market");
    UITabBarItem *item3 = [tabBar.items objectAtIndex:2];
    item3.title=LocalizationKey(@"fastNews");
    UITabBarItem *item4 = [tabBar.items objectAtIndex:3];
    item4.title=LocalizationKey(@"mine");
    
}
#pragma mark -- UITableView Delegate && DataSource

#pragma mark -- other Deleget

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
