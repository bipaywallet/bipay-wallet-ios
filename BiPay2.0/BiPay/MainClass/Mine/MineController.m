//
//  MineController.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MineController.h"
#import "MineHeaderView.h"
#import "WalletManagerController.h"
#import "MessageCenterController.h"
#import "SystemSettingController.h"
#import "HelpCenterController.h"
#import "AboutUsController.h"

@interface MineController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, assign) BOOL updateFlag;//版本更新标记
@property (nonatomic, strong) MineHeaderView * tableHeadView;
@property (nonatomic, copy) NSString * downloadUrl;
@end

@implementation MineController
static NSString * identifier = @"cell";
#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LocalizationKey(@"setting");
    self.view.backgroundColor = ViewBackColor;
    
    self.imageArray = @[@"设置_20",@"设置_22",@"设置_24",@"设置_26",@"设置_28"];
    
    [self setControlForSuper];
    [self addConstrainsForSuper];
    [self updateVersion];
    
    //MARK:--注册国际化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNotificaiton:) name:LanguageChange object:nil];
}
- (void)languageChangeNotificaiton:(NSNotification *)notification{
    self.navigationItem.title = LocalizationKey(@"setting");
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleArray = @[LocalizationKey(@"msgCenter"),LocalizationKey(@"sysSetting"),LocalizationKey(@"helpCenter"),LocalizationKey(@"aboutUs"),LocalizationKey(@"versionUpdate")];
    
    self.navigationController.navigationBar.translucent = YES;
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark -- didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- setControlForSuper
- (void)setControlForSuper
{
    self.tableHeadView = [[MineHeaderView alloc]init];
    [self.view addSubview:self.tableHeadView];
    [self.view addSubview:self.tableView];
}

#pragma mark -- addConstrainsForSuper
- (void)addConstrainsForSuper
{
    [self.tableHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_offset(SCREEN_WIDTH*0.58);
    }];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(SCREEN_WIDTH*0.58,
                                         SCREEN_WIDTH*0.04,
                                         0,
                                         SCREEN_WIDTH*0.04);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view).insets(edge);
    }];
}

#pragma mark -- target Methods

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = CellBackColor;
    }
    cell.textLabel.text      = self.titleArray[indexPath.row];
    cell.textLabel.textColor = barTitle;
    cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image     = IMAGE(self.imageArray[indexPath.row]);
    UILabel *oldversion= (UILabel *)[cell viewWithTag:(10086)];
    [oldversion removeFromSuperview];
    if (indexPath.row==self.titleArray.count-1) {
        if (_updateFlag) {
             UILabel *oldalert= (UILabel *)[cell viewWithTag:(10087)];
             [oldalert removeFromSuperview];
             UILabel*versionLabel=[[UILabel alloc]initWithFrame:CGRectMake(kWindowW-140, 0, 60, tableHeight)];
            versionLabel.tag=10086;
            versionLabel.text=[NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            versionLabel.textColor=[UIColor lightGrayColor];
            [cell addSubview:versionLabel];
            UILabel*alertLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(versionLabel.frame), 0, 20, 20)];
            alertLabel.backgroundColor=[UIColor redColor];
            alertLabel.text=@"!";
            alertLabel.tag=10087;
            alertLabel.textAlignment=NSTextAlignmentCenter;
            alertLabel.clipsToBounds=YES;
            alertLabel.textColor=[UIColor whiteColor];
            alertLabel.layer.cornerRadius=alertLabel.height/2.0;
            alertLabel.centerY=versionLabel.centerY;
            [cell addSubview:alertLabel];
            
        }else{
            UILabel*versionLabel=[[UILabel alloc]initWithFrame:CGRectMake(kWindowW-120, 0, 100, tableHeight)];
            versionLabel.text=[NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            versionLabel.tag=10086;
            versionLabel.textColor=[UIColor darkGrayColor];
            [cell addSubview:versionLabel];
        }
    }
    return cell;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row+1)
    {
        // 钱包管理
        case 0:
        {
            WalletManagerController * vc = [[WalletManagerController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        // 消息中心
        case 1:
        {
            MessageCenterController * vc = [[MessageCenterController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        // 系统设置
        case 2:
        {
            SystemSettingController * vc = [[SystemSettingController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        // 帮助中心
        case 3:
        {
            HelpCenterController * vc = [[HelpCenterController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        // 关于我们
        case 4:
        {
            AboutUsController * vc = [[AboutUsController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            // 版本更新
        case 5:
        {
            //版本更新
            if (_updateFlag) {
                NSURL *url = [NSURL URLWithString:self.downloadUrl];
                if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:url options:@{}
                                                     completionHandler:^(BOOL success) {
                                                         NSLog(@"Open %d",success);
                                                     }];
                        } else {
                            
                        }
                    } else {
                        BOOL success = [[UIApplication sharedApplication] openURL:url];
                        NSLog(@"Open  %d",success);
                    }
                    
                } else{
                    bool can = [[UIApplication sharedApplication] canOpenURL:url];
                    if(can){
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }else{
                [self.view makeToast:LocalizationKey(@"updated") duration:1.5 position:CSToastPositionCenter];
                return;
            }
        }
            break;
        
        default:
        {
            
        }
            break;
    }
}
#pragma mark -- other Deleget

- (UIStatusBarStyle)preferredStatusBarStyle
{
    // 状态栏字体白色
    return UIStatusBarStyleLightContent;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = ViewBackColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorColor=lineColor;
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.layer.cornerRadius=10;
        _tableView.clipsToBounds=YES;
        if(@available(iOS 11.0,*)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}


#pragma mark--版本更新

-(void)updateVersion{
    __weak MineController*welkSelf=self;
    
    [RequestManager postRequestWithURLPath:@"http://om.xinhuokj.com/getway/api/cms/appInfo/findInfo" withParamer:[[NSMutableDictionary alloc]init] completionHandler:^(id responseObject) {
        NSDictionary*dic=responseObject[@"result"][@"ios"];
        // app当前版本
        NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        welkSelf.downloadUrl=dic[@"download"];
        if ([app_Version compare:dic[@"code"]] == NSOrderedSame ||[app_Version compare:dic[@"code"]] == NSOrderedDescending) {
            //不需要更新
            welkSelf.updateFlag = NO;
        }else{
            welkSelf.updateFlag = YES;
        }
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.titleArray.count-1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        
    }];
    
}
#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
