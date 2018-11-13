//
//  changeSelectCell.m
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "changeSelectCell.h"
#import "UIImageView+WebCache.h"
@implementation changeSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configModel:(changeModel*)model withButton:(UIButton*)button withFrom:(NSString*)from withTo:(NSString*)to{
  //  NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)model.image, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));//解决中文编码问题
   // [self.headIcon sd_setImageWithURL:[NSURL URLWithString:encodedString]];
    self.headIcon.image=UIIMAGE([model.name uppercaseString]);
    self.nameLabel.text=[model.name uppercaseString];
    self.fullNameLabel.text=model.fullName;
    if (button.tag==1) {
        if ([self.nameLabel.text isEqualToString:from] ) {
            self.selectedImage.hidden=NO;
        }else{
            self.selectedImage.hidden=YES;
        }
        
    }else{
        if ([self.nameLabel.text isEqualToString:to] ) {
            self.selectedImage.hidden=NO;
        }else{
            self.selectedImage.hidden=YES;
        }
    }
}
@end
