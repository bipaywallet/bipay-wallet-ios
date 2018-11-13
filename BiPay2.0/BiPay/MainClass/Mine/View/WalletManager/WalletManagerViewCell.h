//
//  WalletManagerViewCell.h
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseViewCell.h"

@interface WalletManagerViewCell : BaseViewCell
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UILabel *walletMoney;
@property (weak, nonatomic) IBOutlet UILabel *coinAmount;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *walletImage;

@end
