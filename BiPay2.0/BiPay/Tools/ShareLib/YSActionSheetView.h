//
//  YSActionSheetView.h
//  ShareAlertDemo
//
//  Created by dev on 2018/5/23.
//  Copyright © 2018年 nys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YSActionSheetButton.h"

@protocol PlatformButtonClickDelegate <NSObject>

- (void) customActionSheetButtonClick:(YSActionSheetButton *) btn;

@end


@interface YSActionSheetView : UIView

//- (void)showInView:(UIView *)superView;

-(instancetype)initNYSView;


@property (nonatomic, weak) id<PlatformButtonClickDelegate> delegate;



@end
