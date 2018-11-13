//
//  changeHistoryCell.h
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "changeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface changeHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fromCoin;
@property (weak, nonatomic) IBOutlet UILabel *toCoin;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
@property (weak, nonatomic) IBOutlet UILabel *fromAddress;
@property (weak, nonatomic) IBOutlet UILabel *toAddress;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *status;

-(void)configModel:(changeModel*)model;
@end

NS_ASSUME_NONNULL_END
