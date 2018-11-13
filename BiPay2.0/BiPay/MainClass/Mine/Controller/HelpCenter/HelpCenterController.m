//
//  HelpCenterController.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "HelpCenterController.h"
#import "NoticeModel.h"
#import "PlatformMessageDetailViewController.h"


@interface HelpCenterController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray * titleArray;
@end

@implementation HelpCenterController
static NSString * identifier = @"cell";
#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ViewBackColor;
    self.title = LocalizationKey(@"helpCenter");
    
  //  self.titleArray = @[@"1.0新手必读",@"钱包安全",@"基础教程",@"转账 / 收款",@"币币兑换 ",@"区块链知识",@"数字货币知识"];
    
    [self setControlForSuper];
    [self addConstrainsForSuper];
    [self getNotice];
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
/**
 帮助中心
 */
-(void)getNotice{
    [SVProgressHUD show];
    // 请求参数字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    [params setValue:[NSNumber numberWithInt:20] forKey:@"pageSize"];
    [params setValue:@"id" forKey:@"sortFields"];
    [params setValue:[NSArray array] forKey:@"queryList"];
    [RequestManager postRequestWithURLPath: @"http://om.xinhuokj.com/getway/api/cms/article/findBy" withParamer:params completionHandler:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"responseCode"] intValue]==200) {
            self.titleArray=[NoticeModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"pageList"]];
            [self.tableView reloadData];
        }
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        [SVProgressHUD dismiss];
        [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
    }];
   
    
}

#pragma mark -- DidReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SetControlForSuper
- (void)setControlForSuper
{
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    UIEdgeInsets edge = UIEdgeInsetsMake(0,
                                         SCREEN_WIDTH*0.04,
                                         0,
                                         SCREEN_WIDTH*0.04);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self.view).insets(edge);
    }];
}

#pragma mark -- Target Methods

#pragma mark -- Private Methods

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeModel*model=self.titleArray[indexPath.section];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"help"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"help"];
        cell.textLabel.textColor = barTitle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = CellBackColor;
    cell.layer.cornerRadius = 6.0f;
    cell.layer.masksToBounds = YES;
    cell.textLabel.text = model.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeModel*model=self.titleArray[indexPath.section];
    PlatformMessageDetailViewController *detailVC=[[PlatformMessageDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.content = model.content;
    detailVC.navtitle = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}
///===========================================================================
///                           HeaderView
///===========================================================================
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableHeight;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = tableViewColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorColor=lineColor;
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        if(@available(iOS 11.0,*)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"notrade" titleStr:LocalizationKey(@"nodata")];
        _tableView.ly_emptyView = emptyView;
    }
    return _tableView;
}

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter


@end
