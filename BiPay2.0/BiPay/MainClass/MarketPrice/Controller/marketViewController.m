//
//  marketViewController.m
//  BiPay
//
//  Created by sunliang on 2018/9/4.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "marketViewController.h"
#import "marketModel.h"
#import "marketCell.h"
#import "headerView.h"


@interface marketViewController ()
@property(nonatomic,strong)NSArray*contentArray;
@end

@implementation marketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getMarketPrice];
    [self.tableView registerNib:[UINib nibWithNibName:@"marketCell" bundle:nil] forCellReuseIdentifier:@"marketCell"];
    self.tableView.separatorColor=lineColor;
    self.tableView.tableFooterView=[UIView new];
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"notrade" titleStr:LocalizationKey(@"nodata")];
    self.tableView.ly_emptyView = emptyView;
    [self headRefreshWithScrollerView:self.tableView];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title= LocalizationKey(@"market");
}
-(void)action{
    
    [self getMarketPrice];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    marketModel*model=self.contentArray[indexPath.row];
    marketCell*cell=[tableView dequeueReusableCellWithIdentifier:@"marketCell"];
    cell.coinKind.text=@"HUOBI";
    [cell configMode:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headerView*view=[headerView instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 30)];
    view.aNewsPriceLab.text = LocalizationKey(@"newPrice");;
    view.assetNameLAb.text = LocalizationKey(@"assetName");
    view.appliesLab.text = LocalizationKey(@"applies");
    return view;
}
/**
 火币数据
 */
-(void)getMarketPrice{

    // 请求头
    [RequestManager postRequestWithURLPath: @"http://www.qkljw.com/app/Kline/get_currency_data" withParamer:[[NSMutableDictionary alloc]init] completionHandler:^(id responseObject) {
      
        self.contentArray = [marketModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
          [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
    }];
      
}
/** 下拉刷新
 */
- (void)refreshHeaderAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    [self getMarketPrice];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
