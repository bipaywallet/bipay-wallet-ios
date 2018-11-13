//
//  FastNewsCell.m
//  BiPay
//
//  Created by sunliang on 2018/8/18.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "FastNewsCell.h"

@implementation FastNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 1, 0)];//调整图片位置
    [self.shareBtn setTitle:LocalizationKey(@"share") forState:UIControlStateNormal];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
//MARK:--点击展开或收起
- (IBAction)openOrCloseBtn:(id)sender {
    self.model.isOpen = !self.model.isOpen;
    
    if (self.block) {
        self.block(self.openOrCloseBtn);
    }
}
//MARK:--分享
- (IBAction)shareClick:(id)sender {
    if (self.shareBlock) {
        self.shareBlock(self.shareBtn);
    }
}

- (void)setModel:(FastNewModel *)model{
    _model = model;
    NSString *content = [model.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *title = [model.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    model.title = title;
    model.content = content;
    CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 75, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
    CGFloat height = 54 + size.height + titleSize.height ;
    
    if (model.isOpen) {
        self.contentlabel.numberOfLines = 0;
        model.height = height + 10;// 10 分享加间距
    }else{
        model.height = 54 + 30 + 28 + 25; // 间距 + content + title + 10 （分享加间距）
        self.contentlabel.numberOfLines = 2;
    }
    
    
    self.dateLabel.text=[model.create_time substringWithRange:NSMakeRange(5,5)];
    self.minuteLabel.text=[model.create_time substringWithRange:NSMakeRange(11,5)];
    self.titlelabel.text=model.title;
    self.contentlabel.text=model.content;
    
}
@end
