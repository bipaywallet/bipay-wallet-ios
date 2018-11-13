//
//  BaseController.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"
#import "NavigationController.h"
#import "TabBarController.h"


@interface BaseController ()

@end

@implementation BaseController

#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.subviews
     enumerateObjectsUsingBlock:^(UIView
                                  *view, NSUInteger idx,
                                  BOOL *stop) {
         if ([[UIDevice currentDevice].systemVersion intValue]>=10){
             //iOS10,改变了导航栏的私有接口为_UIBarBackground
             if ([view
                  isKindOfClass:NSClassFromString(@"_UIBarBackground")])
             {
                 [view.subviews
                  lastObject].hidden = YES;
             }
             
         }else{
             //iOS10之前使用的是_UINavigationBarBackground
             if ([view
                  isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
             {
                 [view.subviews lastObject].hidden = YES;
             }
         }
         
     }];
}

#pragma mark -- didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalizationKey(@"warmTip") message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        actionBlock();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock();
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController: alert animated: YES completion: nil];
    });
}
//model转化为字典
- (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
            
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return [dic copy];
}
//将可能存在model数组转化为普通数组
- (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}

-(NSString*)transferClassNameFromtitle:(NSString*)title{
    
    if ([title isEqualToString:LocalizationKey(@"richscan")]) {
        return @"MMScanViewController";
    }else if ([title isEqualToString:LocalizationKey(@"contanctMan")]){
        return @"ContactController";
    }else if ([title isEqualToString:LocalizationKey(@"msgCenter")]){
        return @"MessageCenterController";
    }else if ([title isEqualToString:LocalizationKey(@"selectCoin")]){
        return @"SettingDetailController";
    }else if ([title isEqualToString:LocalizationKey(@"selectLanguage")]){
        return @"SettingDetailController";
    }
    else if ([title isEqualToString:LocalizationKey(@"helpCenter")]){
        return @"HelpCenterController";
    }else if ([title isEqualToString:LocalizationKey(@"aboutUs")]){
        return @"AboutUsController";
    }else if ([title isEqualToString:LocalizationKey(@"versionUpdate")]){
        return @"";
    }
    else if ([title isEqualToString:LocalizationKey(@"Pursemanagement")]){
        return @"WalletManagerController";
        
    }else {
        return @"";
    }
   
}
- (UIViewController *)getActivityViewController:(NSString *)controllerName {
    // 类名
    NSString *class = controllerName;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass)
    {
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    return instance;
  
    
}

- (void)showError:(NSString*)str andTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action1 = ({
        UIAlertAction *action = [UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        action;
    });
    
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

//获取当前时间戳  （以毫秒为单位）
-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* string=[dateFormat stringFromDate:[NSDate date]];
    
    return string;
    
}
//判断字符串是否为空
- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

@end
