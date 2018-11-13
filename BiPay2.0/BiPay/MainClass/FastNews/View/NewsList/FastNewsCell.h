//
//  FastNewsCell.h
//  BiPay
//
//  Created by sunliang on 2018/8/18.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastNewModel.h"
typedef void (^OpenCloseBlock)(UIButton * button);
typedef void (^ShareBlock)(UIButton *button);
@interface FastNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIButton *openOrCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic, copy) OpenCloseBlock block;
@property (nonatomic, copy) ShareBlock shareBlock;
@property (nonatomic, strong) FastNewModel*model;

@end
