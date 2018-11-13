//
//  MessageCenterController.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MessageCenterController.h"
#import "MessageViewCell.h"
#import "MessageDetailController.h"
#import "NoticeModel.h"
#import "PlatformMessageDetailViewController.h"


@interface MessageCenterController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _pageNo;
}
@property(nonatomic,strong)NSMutableArray*noticeArray;

@end

@implementation MessageCenterController
static NSString * identifier = @"cell";
#pragma mark -- LifeCycle
-(NSMutableArray*)noticeArray{
    if (_noticeArray == nil) {
        _noticeArray = [NSMutableArray array];
    }
    return _noticeArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"msgNotification");
    _pageNo=1;
    self.view.backgroundColor=ViewBackColor;
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    [self setControlForSuper];
    [self addConstrainsForSuper];
    [self PostAfNWithtype:1];
   //[self setRightBarButtonItem];
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
 公告信息
 */
-(void)PostAfNWithtype:(int)type{
    [SVProgressHUD show];
    // 请求参数字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[NSNumber numberWithInt:_pageNo] forKey:@"pageIndex"];
    [params setValue:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [params setValue:@"id" forKey:@"sortFields"];
    [params setValue:[NSArray array] forKey:@"queryList"];
    
    [RequestManager postRequestWithURLPath:@"http://om.xinhuokj.com/getway/api/cms/notice/findBy" withParamer:params completionHandler:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"responseCode"] intValue]==200) {
            if (type==1) {
                [self.noticeArray removeAllObjects];
            }
            NSArray*contentArray = [NoticeModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"pageList"]];
            [self.noticeArray addObjectsFromArray:contentArray];
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
    [self.tableView registerClass:[MessageViewCell class] forCellReuseIdentifier:@"message"];
    [self.view addSubview:self.tableView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark -- Target Methods

- (void)rightButtonitemClick
{
    NSLog(@"全部已读");
}

#pragma mark -- Private Methods

- (void)setRightBarButtonItem
{
    UIButton * rightItem = [[UIButton alloc]init];
    [rightItem.titleLabel setFont:systemFont(15)];
    [rightItem setTitle:LocalizationKey(@"allRead") forState:UIControlStateNormal];
    [rightItem setTitleColor:barTitle forState:UIControlStateNormal];
    [rightItem dn_addActionHandler:^{
       
        [self rightButtonitemClick];
    }];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noticeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    if (!cell)
    {
        cell = [[MessageViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"message"];
    }
    [cell configModel:self.noticeArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeModel*model=self.noticeArray[indexPath.row];
    PlatformMessageDetailViewController *detailVC=[[PlatformMessageDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.content = model.content;
    detailVC.navtitle = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
        LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"notrade" titleStr:LocalizationKey(@"noMsg")];
        _tableView.ly_emptyView = emptyView;
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
/** 上拉加载
 */
- (void)refreshFooterAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
    _pageNo+=1;
    [self PostAfNWithtype:0];
}
/** 下拉刷新
 */
- (void)refreshHeaderAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    _pageNo=1;
    [self PostAfNWithtype:1];
}
#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter


@end
