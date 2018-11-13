//
//  WalletAlertPickerView.h
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseView.h"

// 代理传递点击的 tableView 的某一行的 indexPath
@protocol WallerAlertDelegate <NSObject>

- (void)walletAlertPickerSelectIndexPath:(NSIndexPath *)indexPath;
@end

@interface WalletAlertPickerView : BaseView
/** 标题数组 */
@property (nonatomic, strong) NSArray * titleArray;
/** 图片数组 */
@property (nonatomic, strong) NSArray * imageArray;

@property (nonatomic, assign) id <WallerAlertDelegate> delegate;

+ (instancetype)shareView;

- (void)show;
- (void)dismiss;
@end
