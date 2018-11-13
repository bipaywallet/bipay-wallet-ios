//
//  ContactViewCell.h
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseViewCell.h"
#import "contactsModel.h"
@interface ContactViewCell : BaseViewCell
-(void)configModel:(contactsModel*)model;
@property (weak, nonatomic) IBOutlet UILabel *coinCount;

@end
