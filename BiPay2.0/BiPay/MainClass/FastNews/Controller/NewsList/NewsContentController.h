//
//  NewsContentController.h
//  BiPay
//
//  Created by 褚青骎 on 2018/7/3.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"
#import "FastNewModel.h"
@interface NewsContentController : BaseController
@property(nonatomic,strong)FastNewModel*model;
@property (strong, nonatomic) IBOutlet UIView *newsContent;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
