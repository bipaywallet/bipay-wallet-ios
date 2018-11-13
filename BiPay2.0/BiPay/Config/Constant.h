//
//  Constant.h
//  BaseProject
//
//  Created by YLCai on 16/11/11.
//  Copyright © 2016年 YLCai. All rights reserved.
//

#ifndef Constant_h
#define Constant_h
#define USERINFO @"USERINFO"

//自定义block
typedef void(^ResultBlock)(id resultObject,int isSuccessed);
typedef void(^ResultNameBlock)(id resultObject,int isSuccessed, NSString*coinName);//增加币种名字段
//国际化
#define  CurrentWalletID       @"WalletnameID" //当前选择的钱包ID
#define  LocalLanguageKey    @"LocalLanguageKey" //当前语言
#define  LanguageChange      @"LanguageChange" //切换语言
#define  MoneyChange         @"moneyChange"    //切换币种
#define  WalletChange        @"walletChange"    //切换钱包
#define  AddAssets           @"addAseets"    //添加资产
#define  BusinessID          @"20180829144210448"    //币付钱包商务号
#define LocalizationKey(key) [[ChangeLanguage bundle]  localizedStringForKey:key value:nil table:@"Language"]

#define MESSAGE @"message"
//设备唯一标识符
#define UUID            [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define UUIDKey         @"UUIDKey"
#define USENAMEPASSWORD         @"USENAMEPASSWORD"//用户名和密码
#define HIDEMONEY   @"HIDEMONEY" //是否隐藏总金额
#define kWindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define kWindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

//button点击事件
#define kAddEventDefault(OBJ,SELECTOR)  [OBJ addTarget:self action:@selector(SELECTOR) forControlEvents:UIControlEventTouchUpInside]

//Push和Pop
#define kPopViewController          [self.navigationController popViewControllerAnimated:YES]
#define kPushViewController(VC)     [self.navigationController pushViewController:VC animated:YES]


#pragma mark --------屏幕尺寸适配－－－－－－－
#define autoScaleW(width) [(AppDelegate *)[UIApplication sharedApplication].delegate autoScaleW:width]
#define autoScaleH(height) [(AppDelegate *)[UIApplication sharedApplication].delegate autoScaleH:height]

//图片
#define UIIMAGE(name) [UIImage imageNamed:name]
#define kStoryboard(StoryboardName)     [UIStoryboard storyboardWithName:StoryboardName bundle:nil]
#define INT2STRING(intValue) [NSString stringWithFormat:@"%d", intValue]
//通过Storyboard ID 在对应Storyboard中获取场景对象
#define kVCFromSb(VCID, SbName)     [[UIStoryboard storyboardWithName:SbName bundle:nil] instantiateViewControllerWithIdentifier:VCID]

//移除iOS7之后，cell默认左侧的分割线边距
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\
// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}
//新版导航栏高度
#define NEW_NavHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define IOS_VERSION_11_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=11.0)? (YES):(NO))
//新版状态栏高度
#define NEW_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
 #define SafeAreaTopHeight   (kWindowH == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (kWindowH == 812.0 ? 34 : 0)
#define SafeIS_IPHONE_X      (kWindowH == 812.0 ? 50 : 30)
//iPhoneX机型判断
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?  CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NavigationBarAdapterContentInsetTop (IS_IPHONE_X? 88.0f:64.0f) //顶部偏移

#define APPLICATION     [UIApplication sharedApplication].delegate

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
///字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//定义X系列手机
#define kISIPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#define kISIPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define kISIphoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kISIPhoneXS kISIphoneX

#define ISiPhoneX (( kISIPhoneXR || kISIphoneX || kISIPhoneXSMax || kISIPhoneXS) ? YES : NO)
//
//打印相关
#ifdef DEBUG
#define DLog( s, ... )                          NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif


#endif /* Constant_h */
