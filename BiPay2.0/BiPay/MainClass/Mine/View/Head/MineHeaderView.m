//
//  MineHeaderView.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MineHeaderView.h"
#import "ImageButton.h"
#import "ContactController.h"
#import "TradeRecordController.h"
#import "WalletManagerController.h"
@interface MineHeaderView ()

@property (nonatomic, strong) UIView      * line;
@property (nonatomic, strong) UIView      * bgView;
@property (nonatomic, strong) UIView      * bgImage;
@property (nonatomic, strong) ImageButton * contact;
@property (nonatomic, strong) ImageButton * record;
@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setControlForSuper];
        [self addConstraintsForSuper];
        //MARK:--注册国际化通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNotificaiton:) name:LanguageChange object:nil];
    }
    return self;
}

- (void)languageChangeNotificaiton:(NSNotification *)notification{
    [self.contact setTitle:LocalizationKey(@"contanctMan") forState:UIControlStateNormal];
    [self.record setTitle:LocalizationKey(@"dealRecord") forState:UIControlStateNormal];

}
- (void)setControlForSuper
{
//    self.backgroundColor = [UIColor redColor];
    
    
    self.line = [[UIView alloc]init];
    self.line.backgroundColor =lineColor;
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    // 设置圆角
    self.bgView.layer.cornerRadius  = 8.0f;
    self.bgView.layer.masksToBounds = YES;
    
    self.bgImage = [[UIView alloc]init];
    self.bgImage.backgroundColor = ViewBackColor;
    
    self.contact = [[ImageButton alloc]init];
    [self.contact.titleLabel setFont:systemFont(17)];

    [self.contact setTitle:LocalizationKey(@"contanctMan") forState:UIControlStateNormal];
    [self.contact setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.contact setImage:IMAGE(@"设置_03") forState:UIControlStateNormal];
    self.contact.layoutStyle = WDLayoutButtonStyleUpImageDownTitle;
    DNWeak(self);
    
    [self.contact dn_addActionHandler:^{
       
        [weakself contactClick];
    }];
    
    self.record = [[ImageButton alloc]init];
    [self.record.titleLabel setFont:systemFont(17)];
    [self.record setTitle:LocalizationKey(@"packetManage") forState:UIControlStateNormal];
    [self.record setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.record setImage:IMAGE(@"钱包管理") forState:UIControlStateNormal];
    self.record.layoutStyle = WDLayoutButtonStyleUpImageDownTitle;
    [self.record dn_addActionHandler:^{
       
        [weakself recordClick];
    }];
    
    [self addSubview:self.bgImage];
    [self insertSubview:self.bgView aboveSubview:self.bgImage];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.contact];
    [self.bgView addSubview:self.record];
}

- (void)addConstraintsForSuper
{
    [self. bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(self);
        make.height.mas_offset(SCREEN_WIDTH*0.38);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).inset(SCREEN_WIDTH*0.28);
        make.width.mas_offset(SCREEN_WIDTH * 0.92);
        make.height.mas_offset(SCREEN_WIDTH*0.25);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.bottom.mas_equalTo(self.bgView).inset(SCREEN_WIDTH*0.05);
        make.width.mas_offset(0.8);
    }];
    
    [self.contact mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.mas_equalTo(self.bgView).inset(SCREEN_WIDTH*0.03);
        make.left.mas_equalTo(self.bgView.mas_left).inset(SCREEN_WIDTH*0.14);
        make.right.mas_equalTo(self.line.mas_left).mas_offset(-SCREEN_WIDTH*0.13);
    }];
    
    [self.record mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.bgView).inset(SCREEN_WIDTH*0.03);
        make.right.mas_equalTo(self.bgView.mas_right).inset(SCREEN_WIDTH*0.14);
        make.left.mas_equalTo(self.line.mas_right).mas_offset(SCREEN_WIDTH*0.13);
    }];
}

- (void)contactClick
{
    //NSLog(@"我是联系人");
    
    // 可通过 [self viewForSuperBaseView] 获取到父视图的控制器进行 push 跳转
    
    ContactController * vc = [[ContactController alloc]init];
    [[self viewForSuperBaseView].navigationController pushViewController:vc animated:YES];
}

- (void)recordClick
{
    NSLog(@"我是交易记录");
    if ([[walletModel bg_findAll:nil] count]==0) {
        [[self viewForSuperBaseView].view makeToast:LocalizationKey(@"noWallet") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    WalletManagerController * vc = [[WalletManagerController alloc]init];
    [[self viewForSuperBaseView].navigationController pushViewController:vc animated:YES];
}

@end
