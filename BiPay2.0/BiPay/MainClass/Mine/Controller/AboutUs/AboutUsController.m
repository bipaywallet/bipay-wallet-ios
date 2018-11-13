//
//  AboutUsController.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "AboutUsController.h"
#import "webViewprotocolVC.h"
@interface AboutUsController ()

@property (nonatomic, strong) UIScrollView * mainScroll;
// 当控件超出屏幕是用来撑开 ScrollView
@property (nonatomic, strong) UIView       * bgView;
@property (nonatomic, strong) UIImageView  * logo;
@property (nonatomic, strong) UILabel      * projectName;
@property (nonatomic, strong) UILabel      * introduce;
@property (nonatomic, strong) UILabel      * contactitle;
@property (nonatomic, strong) UITextField  * email;
@property (nonatomic, strong) UITextField  * weChat;
// 隐私服务
@property (nonatomic, strong) UIButton     * secreat;
// 服务条款
@property (nonatomic, strong) UIButton     * service;
// 授权声明
@property (nonatomic, strong) UIButton     * accredit;
@property (nonatomic, strong) UILabel      * endLabel;
@end

@implementation AboutUsController

#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ViewBackColor;
    self.title = LocalizationKey(@"aboutUs");
    
    [self setControlForSuper];
    [self addConstrainsForSuper];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = ViewBackColor;
}
/**

- (void)viewWillAppear:(BOOL)animated {
[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
[super viewDidDisappear:animated];
}
*/

#pragma mark -- DidReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SetControlForSuper
- (void)setControlForSuper
{    
    self.mainScroll  = [[UIScrollView alloc]init];
    self.bgView      = [[UIView alloc]init];
    self.bgView.userInteractionEnabled=YES;
    
    self.logo        = [UIImageView dn_imageWithName:@"关于我们_03"];
    self.logo.contentMode = UIViewContentModeScaleAspectFit;
    
    self.projectName = [BIPayTools labelWithText:[NSString stringWithFormat:@"%@ V%@",LocalizationKey(@"projectName"),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]
                                       textColor:barTitle
                                        fontSize:fontSize(15)
                                   textAlignment:NSTextAlignmentCenter];
    
    self.introduce   = [BIPayTools labelWithText:LocalizationKey(@"produce")
                                       textColor:barTitle
                                        fontSize:fontSize(15)
                                   textAlignment:NSTextAlignmentLeft];
    self.introduce.numberOfLines = 0;
 
    
    DNWeak(self);
 
    self.service = [[UIButton alloc]init];
    [self.service.titleLabel setFont:systemFont(15)];

    [self.service setTitle:LocalizationKey(@"serviceAndPrivacy") forState:UIControlStateNormal];
    [self.service setTitleColor:RGB(122, 134, 164, 1) forState:UIControlStateNormal];
  
    [self.service dn_addActionHandler:^{

        [weakself serviceMethodClick];
    }];
 
    [self.view       addSubview:self.mainScroll];
    [self.mainScroll addSubview:self.bgView];
    [self.bgView     addSubview:self.logo];
    [self.bgView     addSubview:self.projectName];
    [self.bgView     addSubview:self.introduce];
 
    [self.bgView     addSubview:self.service];
 
}


#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.mainScroll);
        make.width.mas_equalTo(self.mainScroll);
    }];
    
    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.bgView.mas_top).inset(SCREEN_WIDTH*0.15);
        make.width.height.mas_offset(SCREEN_WIDTH*0.2);
    }];
    
    [self.projectName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.logo.mas_bottom).mas_offset(10);
        make.width.mas_offset(SCREEN_WIDTH*0.9);
    }];
    
    [self.introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.projectName.mas_bottom).mas_offset(SCREEN_WIDTH*0.1);
        make.width.mas_offset(SCREEN_WIDTH*0.94);
    }];
    
    [self.service mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        //make.height.mas_offset(SCREEN_WIDTH*0.1);

        make.width.mas_offset(SCREEN_WIDTH-40);

//        make.width.mas_offset(SCREEN_WIDTH/3);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).mas_offset(-50);
        make.top.mas_equalTo(self.introduce.mas_bottom).mas_offset(kWindowW*0.8);
    }];

 
}

#pragma mark -- Target Methods


- (void)serviceMethodClick
{
    
    webViewprotocolVC *vc = [[webViewprotocolVC alloc] init];
    vc.navTitle=LocalizationKey(@"serviceAndPrivacy");
    [self presentViewController:vc animated:true completion:nil];
}


#pragma mark -- Private Methods

#pragma mark -- UITableView Delegate && DataSource

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter


@end
