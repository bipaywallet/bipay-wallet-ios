//
//  confirmExchangeController.h
//  BiPay
//
//  Created by sunliang on 2018/10/24.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface confirmExchangeController : BaseController
@property(nonatomic,strong)coinModel*fromCoinModel;
@property(nonatomic,strong)coinModel*toCoinModel;
@property(nonatomic,copy)NSString* fromValue;
@property(nonatomic,copy)NSString* toValue;
@property (strong, nonatomic) IBOutlet UIScrollView *bgSrollView;
@property (strong, nonatomic) IBOutlet UIView *Bgview;
@property(nonatomic,copy)NSString* rate;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end

NS_ASSUME_NONNULL_END
