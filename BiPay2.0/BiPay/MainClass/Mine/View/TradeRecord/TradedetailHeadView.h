//
//  TradedetailHeadView.h
//  BiPay
//
//  Created by zjs on 2018/6/20.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseView.h"

@interface TradedetailHeadView : BaseView

@property (nonatomic, strong) UIImageView * tradetype;
@property (nonatomic, strong) UILabel     * tradeTitle;
@property (nonatomic, strong) UILabel     * trademoney;
@property (nonatomic, strong) UILabel     * tradeStatu;
@end
