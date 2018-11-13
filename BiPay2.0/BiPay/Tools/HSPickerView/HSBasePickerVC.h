//
//  HSBasePickerVC.h
//  HSPickerViewDemo
//
//  Created by husong on 2017/10/27.
//  Copyright © 2017年 husong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBasePickerVC : UIViewController
// 设置中间title
@property(nonatomic,copy) NSString *pickerTitle;
// pickerview
@property (strong, nonatomic) UIPickerView *pickView;
// 数据源
@property(nonatomic,strong) NSArray<NSMutableArray*> *dataArray;
// 取消
-(void)cancleAction;
// 确认
-(void)ensureAction;
@end
