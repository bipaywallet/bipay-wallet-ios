//
//  UIButton+Extension.m
//  DNProject
//
//  Created by zjs on 2018/5/18.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@implementation UIButton (Extension)

static char touchKey;


// 按钮点击
- (void)dn_addActionHandler:(TouchHandler)touchHandler{
    
    objc_setAssociatedObject(self, &touchKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dn_addActionHandler:(TouchHandler)touchHandler forCntrolEvents:(UIControlEvents)events{
    
    objc_setAssociatedObject(self, &touchKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(touchClick:) forControlEvents:events];
}
- (void)touchClick:(id)sender{
    
    TouchHandler block = (TouchHandler)objc_getAssociatedObject(self, &touchKey);
    if (block) {
        block();
    }
}

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)dn_layoutButtonEdgeInset:(DNButtonEdgeInsetStyle)style space:(CGFloat)space
{
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat imageH = self.imageView.frame.size.height;

    CGFloat titleW = self.titleLabel.frame.size.width;

    CGFloat titleIntrinsicContentSizeW = self.titleLabel.intrinsicContentSize.width;
    CGFloat titleIntrinsicContentSizeH = self.titleLabel.intrinsicContentSize.height;

    switch (style)
    {
        case DNButtonEdgeInsetStyleTop:
        {
            self.imageEdgeInsets = UIEdgeInsetsMake(- titleIntrinsicContentSizeH - space,
                                                    0,
                                                    0,
                                                    - titleIntrinsicContentSizeW);
            self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                    - imageW,
                                                    - imageH - space,
                                                    0);
        }
            break;
        case DNButtonEdgeInsetStyleLeft:
        {
            switch (self.contentHorizontalAlignment)
            {
                case UIControlContentHorizontalAlignmentLeft:
                {
                    self.titleEdgeInsets = UIEdgeInsetsMake(0, space, 0, 0);
                }
                    break;
                case UIControlContentHorizontalAlignmentRight:
                {
                    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, space);
                }
                    break;

                default:
                {
                    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0.5 * space);
                    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0.5 * space, 0, 0);
                }
                    break;
            }
        }
            break;

        case DNButtonEdgeInsetStyleBottom:
        {
            self.imageEdgeInsets = UIEdgeInsetsMake(titleIntrinsicContentSizeH + space,
                                                    0,
                                                    0,
                                                    - titleIntrinsicContentSizeW);
            self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                    - imageW,
                                                    imageH + space,
                                                    0);
        }
            break;
        case DNButtonEdgeInsetStyleRight:
        {
            switch (self.contentHorizontalAlignment)
            {
                case UIControlContentHorizontalAlignmentLeft:
                {
                    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW + space, 0, 0);
                    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageW, 0, 0);
                }
                    break;
                case UIControlContentHorizontalAlignmentRight:
                {
                    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleW);
                    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageW + space);
                }
                    break;

                default:
                {
                    CGFloat imageOffset = titleW + 0.5 * space;
                    CGFloat titleOffset = imageW + 0.5 * space;

                    self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                            imageOffset,
                                                            0,
                                                            - imageOffset);
                    self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                            - titleOffset,
                                                            0,
                                                            titleOffset);
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)startWithTime:(NSInteger)time startBlock:(void(^)(NSString * timeStr))startBlock finishBlock:(void(^)(void))finishBlock{
    
    // 倒计时时间
    __block NSInteger timeOut = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每秒执行一次
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_time, ^{
        // 倒计时结束  关闭
        if (timeOut <= 0)
        {
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finishBlock) {
                    finishBlock();
                }
                self.userInteractionEnabled = YES;
            });
        }
        else
        {
            int seconds = timeOut % 90;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新获取", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (startBlock) {
                    startBlock(strTime);
                }
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_time);
}

@end
