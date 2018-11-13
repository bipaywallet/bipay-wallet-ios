//
//  BIPayCustom.h
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#ifndef BIPayCustom_h
#define BIPayCustom_h
//https://changelly.com,货币兑换
#define APIKEY @"21fa7faea69b44e7bc1d0dc054aa923a"
#define Secret @"7b7d8bb0047ad94db11eeaec4b7752f8e5c471728f5ff761263077468ff5fb2f"
 #define ChangellyHOST   @"https://api.changelly.com"
// 微信 APPID
#define WeChatID            @"wxa9abf55c581d97cf"
#define WeChatSecret            @"cd7cc22155800a0edd159d659d441f87"
//#define HOST                 @"http://36.7.147.3:9333/"//测试环境
// 域名
#define HOST               @"http://api.bipay.wxmarket.cn:9333/"//正式环境
#define RedColor   RGB(252,88,88,1)   //红跌
#define GreenColor RGB(60,188,152,1)  //绿涨 
#define BtnColor RGB(227,187,102,1)  //黄色按钮
#define OrangeColor RGB(217,169,67,1)  //黄色按钮
#define HomeNavColor RGB(1,7,50,1)
#define NavColor RGB(27,29,57,1)  //导航颜色，主题背景颜色
#define AseetColor RGB(5,186,186,1)  //资产余额颜色

#define kRequestSucceed   [[NSString stringWithFormat:@"%@",resultObject[@"code"]] isEqualToString:@"0"]
// 后台返回的 message
#define MESSAGE             @"message"

// 数据本地保存
#define USERINFO            @"USERINFO"

// 取字符串对应数字
#define INTAGER(name)       [name integerValue]


// keyWindow
#define  ToastWindows       [UIApplication sharedApplication].delegate.window

#define APPLICATION         [UIApplication sharedApplication].delegate

// weak 弱引用
#define DNWeak(name)        __weak typeof(name) weak##name = name

// 图片
#define IMAGE(name)         [UIImage imageNamed:name]

// 颜色
#define RGB(r, g, b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#define TFTextColor RGB(255,255,255,1)  //输入框字体颜色
#define TFPlaceHolderColor RGB(81,84,113,1)  //输入框占位符颜色
#define TFContactPlaceHolderColor RGB(119,119,131,1)
#define TVPlaceHolderColor RGB(106,107,121,1)  //输入框占位符颜色
#define FeeLabColor RGB(225,226,229,1)
#define DealTitleColor RGB(141,150,183,1) //
#define DealSubTitleColor RGB(188,206,222,1)
#define SubTitleColor RGB(97,98,114,1) //按钮标题颜色 不可用
#define BtnTitleDisableColor RGB(97,98,114,1) //按钮标题颜色 不可用
#define BtnTitleEnableColor RGB(255,255,255,1) //按钮标题颜色 可用
#define ServiceBtnTitleColor RGB(13,173,244, 1.0)//服务按钮标题颜色 可用
#define BtnBackDisableColor RGB(43,45,71,1) //按钮标题颜色 不可用
#define BtnBackGrayDisableColor RGB(198,198,198,1)
#define HomeCellBackColor RGB(29,34,73,1) //home cell 背景颜色
#define CellBackColor RGB(27,29,57,1) //cell 背景颜色
#define ContanctLabBackColor RGB(48,51,88,1)
#define TransferCellBackColor RGB(25,27,55,1) //cell 背景
#define HomeViewBackColor RGB(1,7,50,1)
#define ViewBackColor RGB(22,24,53,1)
#define BGViewBackColor RGB(21,21,47,1)
#define HeadViewBackColor RGB(22,30,59,1) //表头背景
#define tableViewBackColor  ViewBackColor
#define tableViewColor      RGB(22,24,53, 0.6)
#define BtnBlue RGB(13,173,244, 1.0)
// barTinColor
#define barColor            RGB(28, 28, 28, 1.0)
// barTitle
#define barTitle            RGB(255, 255, 255, 1.0)
#define barUnSelectTitle    RGB(126,140,171, 1.0)
#define barUnderLineColor   RGB(7,160,251,1)
// 分割线颜色
#define lineColor           RGB(35,37,64, 1.0)
#define ConfirmBtnTitleColor RGB(13,173,244, 1.0)



// 屏幕宽高
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

// 自适应字体大小
#define fontSize(size)      size*(SCREEN_WIDTH/375.0)
#define systemFont(size)    [UIFont systemFontOfSize:fontSize(size)]

// 边距
#define spaceSize(size)     size*(SCREEN_WIDTH/375.0)

// tableView 的行高
#define tableHeight         SCREEN_WIDTH <= 320 ? 50 : 55

// iPhoneX适配
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

//Iphone4S
#define iPhone4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)

// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)

// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)

// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

// 空字符串
#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 || [string isEqual:@"NULL"] ||  [string isEqual:NULL]||[[string class] isSubclassOfClass:[NSNull class]] || string == NULL || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])

// 空数组
#define NUllArr(array) (array.count <= 0 || [array isKindOfClass:[NSNull class]] || array == nil)

// 空字典
#define NUllDict(dict) (dict == nil || [dict isKindOfClass:[NSNull class]] || dict.count <= 0)

#endif /* BIPayCustom_h */
