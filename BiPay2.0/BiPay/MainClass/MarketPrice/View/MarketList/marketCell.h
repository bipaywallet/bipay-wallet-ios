//
//  marketCell.h
//  BiPay
//
//  Created by sunliang on 2018/7/27.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "marketModel.h"
@interface marketCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *coinKind;
@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *changelabel;
-(void)configMode:(marketModel*)model;
@end
