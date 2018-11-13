//
//  UIButton+DNTimeDown.m
//  DNProject
//
//  Created by zjs on 2018/5/16.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UIButton+DNTimeDown.h"

@implementation UIButton (DNTimeDown)

- (void)startWithTime:(NSInteger)time title:(NSString *)title downTitle:(NSString *)downTitle{
    // 倒计时时间
    __block NSInteger timeOut = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每秒执行一次
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_time, ^{
        // 倒计时结束  关闭
        if (timeOut <= 0) {
            
            dispatch_source_cancel(_time);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时开始时按钮的标题
                [self setTitle:title forState:UIControlStateNormal];
                // 倒计时结束，按钮可交互
                self.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时开始时按钮的标题
                [self setTitle: [NSString stringWithFormat:@"%@%@",strTime,downTitle] forState:UIControlStateNormal];
                // 倒计时开始，按钮不可交互
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_time);
}

@end
