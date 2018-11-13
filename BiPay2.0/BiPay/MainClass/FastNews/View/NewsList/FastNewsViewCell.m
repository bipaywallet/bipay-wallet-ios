//
//  FastNewsViewCell.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "FastNewsViewCell.h"
#import "ImageButton.h"
#import "BIPayTools.h"

@interface FastNewsViewCell ()

@property (nonatomic, strong) UIView  * empty;
@property (nonatomic, strong) UILabel * time;
@property (nonatomic, strong) UILabel * date;
@property (nonatomic, strong) UILabel * content;
@property (nonatomic, strong) UITextField * readNum;
@property (nonatomic, strong) ImageButton * shareBtn;

@end

@implementation FastNewsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setControlForSuper
{
    self.empty = [[UIView alloc]init];
    
    self.time = [BIPayTools labelWithText:@"12:06"
                                textColor:[UIColor grayColor]
                                 fontSize:fontSize(14)
                            textAlignment:NSTextAlignmentCenter];
    
    self.date = [BIPayTools labelWithText:@"06-15"
                                textColor:[UIColor lightGrayColor]
                                 fontSize:fontSize(14)
                            textAlignment:NSTextAlignmentCenter];
    
    self.content = [BIPayTools labelWithText:@"---"
                                   textColor:[UIColor darkGrayColor]
                                    fontSize:fontSize(15)
                               textAlignment:NSTextAlignmentLeft];
    self.content.lineBreakMode=NSLineBreakByCharWrapping;
    // 最多显示四行
    self.content.numberOfLines = 4;
    
    self.readNum = [[UITextField alloc]init];
    [self.readNum setEnabled:NO];
    self.readNum.text = @"123";
    self.readNum.font=[UIFont systemFontOfSize:14];
    self.readNum.textColor    = [UIColor lightGrayColor];
    UIImageView * leftImage   = [UIImageView dn_imageWithName:@"readNum"];
    self.readNum.leftView     = leftImage;
    self.readNum.leftViewMode = UITextFieldViewModeAlways;
    
    self.shareBtn = [[ImageButton alloc]init];
    self.shareBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.shareBtn setTitle:LocalizationKey(@"share") forState:UIControlStateNormal];
    [self.shareBtn setImage:IMAGE(@"share") forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.shareBtn.layoutStyle = WDLayoutButtonStyleLeftTitleRightImage;
    
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.date];
    [self.contentView addSubview:self.empty];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.readNum];
    [self.contentView addSubview:self.shareBtn];
}

- (void)addConstraintsForSuper
{
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.mas_top).inset(spaceSize(10));
        make.left.mas_equalTo(self.contentView.mas_left);
        make.width.mas_offset(SCREEN_WIDTH*0.15);
    }];
    
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.time.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.width.mas_offset(SCREEN_WIDTH*0.15);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.mas_top).inset(spaceSize(10));
        make.left.mas_equalTo(self.time.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).inset(spaceSize(10));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.contentView.mas_right).inset(spaceSize(12));
        make.top.mas_equalTo(self.content.mas_bottom).mas_offset(10);
        make.width.mas_offset(SCREEN_WIDTH*0.15);
        make.height.mas_offset(spaceSize(30));
    }];
    
    [self.readNum mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.shareBtn.mas_left).mas_offset(-20);
        make.top.mas_equalTo(self.content.mas_bottom).mas_offset(10);
        make.height.mas_offset(spaceSize(30));
    }];
    
    [self.empty mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.shareBtn.mas_bottom).mas_offset(0);
    }];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setControlForSuper];
        [self addConstraintsForSuper];
    }
    return self;
}
-(void)configModel:(FastNewModel*)model{
   
    self.date.text=[model.create_time substringWithRange:NSMakeRange(5,5)];
    self.time.text=[model.create_time substringWithRange:NSMakeRange(11,5)];
    NSString*content=[NSString stringWithFormat:@"[%@]  %@",model.title,model.content];
     NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,model.title.length+2)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0] range:NSMakeRange(0, model.title.length+2)];
    self.content.attributedText=str;
}
@end
