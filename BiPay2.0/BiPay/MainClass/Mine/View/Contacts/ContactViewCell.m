//
//  ContactViewCell.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ContactViewCell.h"

@interface ContactViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ContactViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [ToolUtil colorWithHexString:@"#1a1e3b"];
    self.nameLabel.backgroundColor = [ToolUtil colorWithHexString:@"#303356"];
    self.coinCount.backgroundColor = [ToolUtil colorWithHexString:@"#303356"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configModel:(contactsModel*)model{
    self.userName.text = model.name;
    NSString*name=[[self transform:model.name] uppercaseString];
    if (name.length>=1) {
         self.nameLabel.text= [name substringToIndex:1];
    }else{
        self.nameLabel.text= @"#";
    }
}
- (NSString *)transform:(NSString *)chinese{
        //将NSString装换成NSMutableString
         NSMutableString *pinyin = [chinese mutableCopy];
         //将汉字转换为拼音(带音标)
         CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
        // NSLog(@"%@", pinyin);
         //去掉拼音的音标
         CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
        // NSLog(@"%@", pinyin);
         //返回最近结果
         return pinyin;
     }
@end
