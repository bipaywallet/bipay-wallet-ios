//
//  ShareTableViewCell.m
//  ShareAlertDemo
//
//  Created by dev on 2018/5/23.
//  Copyright © 2018年 nys. All rights reserved.
//

#import "ShareTableViewCell.h"

#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)


@implementation ShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        
        
        
        
        //分享到
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = LocalizationKey(@"share");
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor =[UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
        titleLabel.frame = CGRectMake(0, 10, SCREENWIDTH-20, 30);
        [self addSubview:titleLabel];
        
        
        CGFloat btnW = 75;
        CGFloat btnH = 80;
        
       /*
        NSArray *contentArray = @[
                                  @{@"name":@"微信好友",@"icon":@"share_weixin_icon"},
                                  @{@"name":@"朋友圈",@"icon":@"share_friends_icon"},
                                  @{@"name":@"QQ好友",@"icon":@"share_QQ_icon"},
                                  @{@"name":@"QQ空间",@"icon":@"share_QQSpace_icon"},
                                  ];
        */
        NSArray *contentArray = @[
                                  @{@"name":LocalizationKey(@"weChatFriend"),@"icon":@"share_weixin_icon"},
                                  @{@"name":LocalizationKey(@"friendCircle"),@"icon":@"share_friends_icon"},
                                
                                  ];
        
        
        for (int i = 0; i < 2; i++)
        {
            
            
            NSDictionary *dic = [contentArray objectAtIndex:i];
            NSString *name = dic[@"name"];
            NSString *icon = dic[@"icon"];
            YSActionSheetButton *btn = [YSActionSheetButton buttonWithType:UIButtonTypeCustom];
            
            btn.tag = i;
            [btn setTitle:name forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
            
            
            CGFloat marginX = (SCREENWIDTH-20 - 4 * btnW) / (4 + 1);
            int col = i % 4;
            
            CGFloat btnX = marginX + (marginX + btnW) * col;
            
            
            btn.frame = CGRectMake(btnX, 45, btnW, btnH);
            btn.transform = CGAffineTransformMakeTranslation(0, 100);
            
            
            switch (i) {
                case 0:
                {
                    self.shareBtn1=btn;
                    
                }
                    break;
                case 1:
                {
                    
                    self.shareBtn2=btn;
                }
                    break;
                case 2:
                {
                    self.shareBtn3=btn;
                }
                    break;
                case 3:
                {
                    self.shareBtn4=btn;
                }
                    break;
                    
                default:
                    break;
            }
            
            [self addSubview:btn];
        }
        
        
    }
    
    
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
