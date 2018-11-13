//
//  BaseController.h
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController 
-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock;
//model转化为字典
- (NSDictionary *)dicFromObject:(NSObject *)object;
-(NSString*)transferClassNameFromtitle:(NSString*)title;
- (UIViewController *)getActivityViewController:(NSString *)controllerName;
- (void)showError:(NSString*)str andTitle:(NSString *)title;
//获取当前时间戳  （以毫秒为单位）
-(NSString *)getNowTimeTimestamp;
//判断字符串是否为空
- (BOOL)isBlankString:(NSString *)aStr;
@end
