//
//  ImageButton.h
//  CloudNestLock
//
//  Created by Vincent Yang on 2018/5/4.
//  Copyright © 2018年 HangZhou Huiyou Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WDLayoutButtonStyle) {
    WDLayoutButtonStyleLeftImageRightTitle,
    WDLayoutButtonStyleLeftTitleRightImage,
    WDLayoutButtonStyleUpImageDownTitle,
    WDLayoutButtonStyleUpTitleDownImage
};

@interface ImageButton : UIButton

/// 布局方式
@property (nonatomic, assign) WDLayoutButtonStyle layoutStyle;
/// 图片和文字的间距，默认值8
@property (nonatomic, assign) CGFloat midSpacing;
/// 指定图片size
@property (nonatomic, assign) CGSize imageSize;

@end
