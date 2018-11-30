//
//  AppDelegate.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "NavigationController.h"
#import "shareManger.h"
#import "UMMobClick/MobClick.h"
#import "WalletController.h"
#import "gifPlayViewController.h"
@interface AppDelegate ()<UIWebViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Override point for customization after application launch.
   //[NSThread sleepForTimeInterval:1.0];//延长启动页
     [ChangeLanguage initUserLanguage];//初始化应用语言
     [self initSVProgressHUD];
     [self initKeyboardManager];
     [self initWindowManager];
     [self initUMConfigInstance];
     [self initDefalutConfig];
     [[shareManger defaultShareManger] registerClients];//初始化分享
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

     return YES;
}


-(void)initSVProgressHUD{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//当HUD显示的时候，不允许用户交互
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7] ];// 弹出框颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];// 弹出框内容颜色
}
- (void)initWindowManager
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    gifPlayViewController * walletNav = [[gifPlayViewController alloc]init];
    self.window.rootViewController = walletNav;
    [self.window makeKeyAndVisible];
}


-(void)initKeyboardManager
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;// 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES;// 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;// 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;// 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES;// 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES;// 是否显示占位文字
    keyboardManager.placeholderFont = systemFont(17); // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}

/**
 初始化友盟
 */
-(void)initUMConfigInstance{
    UMConfigInstance.appKey = @"5b7ccc80f43e4826d700000f";
    UMConfigInstance.channelId = @"iOS_Distribute";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setLogEnabled:YES];
}

/**
 初始化语言，币种配置
 */
-(void)initDefalutConfig{
    if (![NSUserDefaultUtil GetDefaults:LanguageChange]) {
        [NSUserDefaultUtil PutDefaults:LanguageChange Value:@"简体中文"];
    }
    if (![NSUserDefaultUtil  GetDefaults:MoneyChange]) {
        [NSUserDefaultUtil PutDefaults:MoneyChange Value:@"CNY"];
    }
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.isEnable) {
        
        return UIInterfaceOrientationMaskLandscape;
        
    } else {
        
        return UIInterfaceOrientationMaskPortrait;
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    ///这里设置白色
    return UIStatusBarStyleLightContent;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
