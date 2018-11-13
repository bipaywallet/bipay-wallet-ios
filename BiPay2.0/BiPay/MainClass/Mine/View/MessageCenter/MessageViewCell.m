//
//  MessageViewCell.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MessageViewCell.h"


@interface MessageViewCell ()

@property (nonatomic, strong) UIImageView * msgImage;
@property (nonatomic, strong) UILabel     * msgTitle;
@property (nonatomic, strong) UILabel     * msgDetail;
@property (nonatomic, strong) UILabel     * msgDate;
@end

@implementation MessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- SetControlForSuper
- (void)setControlForSuper
{
    self.backgroundColor = CellBackColor;
    self.msgImage = [UIImageView dn_imageWithName:@"消息"];
    
    self.msgTitle = [BIPayTools labelWithText:LocalizationKey(@"msgTitleTip")
                                    textColor:barTitle
                                     fontSize:fontSize(16)
                                textAlignment:NSTextAlignmentLeft];
    
    self.msgDetail = [BIPayTools labelWithText:LocalizationKey(@"msgTitleTip")
                                     textColor:barTitle
                                      fontSize:fontSize(12)
                                 textAlignment:NSTextAlignmentLeft];
    
    self.msgDate = [BIPayTools labelWithText:@"11:55:89"
                                   textColor:barTitle
                                    fontSize:fontSize(13)
                               textAlignment:NSTextAlignmentRight];
    
    [self.contentView addSubview:self.msgImage];
    [self.contentView addSubview:self.msgTitle];
    [self.contentView addSubview:self.msgDetail];
    [self.contentView addSubview:self.msgDate];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    [self.msgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).inset(spaceSize(15));
        make.width.mas_equalTo(@(19));
        make.height.mas_equalTo(@(14));
    }];
    
    [self.msgDate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.mas_top).inset(SCREEN_WIDTH*0.06);
        make.right.mas_equalTo(self.contentView.mas_right).inset(spaceSize(15));
        //make.width.mas_offset(SCREEN_WIDTH * 0.2);
    }];
    
    [self.msgTitle mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.contentView.mas_top).inset(SCREEN_WIDTH*0.03);
        make.right.mas_equalTo(self.msgDate.mas_left).mas_offset(-8);
        make.left.mas_equalTo(self.msgImage.mas_right).mas_offset(10);
    }];

    [self.msgDetail mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.msgTitle.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self.msgDate.mas_left).mas_offset(-8);
        make.left.mas_equalTo(self.msgImage.mas_right).mas_offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(SCREEN_WIDTH*0.03);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self)
    {
        [self setControlForSuper];
        [self addConstrainsForSuper];
    }
    return self;
}
-(void)configModel:(NoticeModel*)model{
    self.msgTitle.text=model.title;
    self.msgDetail.text=model.updateTime;
    self.msgDate.text=@"";
    
}

@end
