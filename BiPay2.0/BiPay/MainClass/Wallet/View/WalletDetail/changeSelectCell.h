//
//  changeSelectCell.h
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "changeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface changeSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
-(void)configModel:(changeModel*)model withButton:(UIButton*)button withFrom:(NSString*)from withTo:(NSString*)to;
@end

NS_ASSUME_NONNULL_END
