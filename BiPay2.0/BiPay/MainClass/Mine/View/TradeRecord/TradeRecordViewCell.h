//
//  TradeRecordViewCell.h
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseViewCell.h"

@interface TradeRecordViewCell : BaseViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recordImage;
@property (weak, nonatomic) IBOutlet UILabel *recordDate;
@property (weak, nonatomic) IBOutlet UILabel *recordStatus;
@property (weak, nonatomic) IBOutlet UILabel *recordMoney;
@property (weak, nonatomic) IBOutlet UILabel *recordTitle;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionAdress;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
