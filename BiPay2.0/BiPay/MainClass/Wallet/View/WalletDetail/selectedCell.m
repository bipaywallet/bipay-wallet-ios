//
//  selectedCell.m
//  BiPay
//
//  Created by sunliang on 2018/8/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "selectedCell.h"

@implementation selectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [ToolUtil colorWithHexString:@"#1a1e3b"];
    self.nameLabel.backgroundColor = [ToolUtil colorWithHexString:@"#303356"];

    self.nameLabel.textColor = barTitle;
    self.coinCount.backgroundColor = [ToolUtil colorWithHexString:@"#303356"];
    self.nickLabel.textColor = barTitle;
    self.FirsrtAddress.textColor = barTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configModel:(contactsModel*)model{
    self.nickLabel.text=model.name;
    NSString*name=[[self transform:model.name] uppercaseString];
    if (name.length>=1) {
        self.nameLabel.text= [name substringToIndex:1];
    }else{
        self.nameLabel.text= @"#";
    }
    NSArray*coinArray=[[ContactsDataBase sharedDataBase] getAllCoinsFromContact:model];
    self.coinCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)coinArray.count];
    coinModel*coin=[coinArray firstObject];
    self.FirsrtAddress.text=[NSString stringWithFormat:@"%@:%@",coin.brand,coin.address];
    
}
- (NSString *)transform:(NSString *)chinese{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //NSLog(@"%@", pinyin);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    //NSLog(@"%@", pinyin);
    //返回最近结果
    return pinyin;
}
@end
