//
//  changeHistoryController.m
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "changeHistoryController.h"
#import "changeHistoryCell.h"
#import "changeDetailController.h"
#import "changeModel.h"
@interface changeHistoryController ()
@property(nonatomic,strong)NSArray*contentArray;
@end

@implementation changeHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=LocalizationKey(@"history");
    [self headRefreshWithScrollerView:self.tableView];
    self.tableView.backgroundColor =ViewBackColor;
    self.tableView.separatorColor=lineColor;
    self.tableView.tableFooterView=[UIView new];
    self.tableView.rowHeight=190;
    self.tableView.separatorInset=UIEdgeInsetsMake(0,15, 0, 15);
    [self.tableView registerNib:[UINib nibWithNibName:@"changeHistoryCell" bundle:nil] forCellReuseIdentifier:@"changeHistoryCell"];
    LYEmptyView*emptyView=[LYEmptyView emptyActionViewWithImageStr:@"noRecord" titleStr:nil detailStr:LocalizationKey(@"nochangelly") btnTitleStr:nil btnClickBlock:nil];;
    self.tableView.ly_emptyView = emptyView;
    
   
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self reloadAllLocalData];//加载本地数据
}
#pragma mark-本地获取交易记录并刷新单元格
-(void)reloadAllLocalData{
    NSArray*localArray=(NSMutableArray*) [changeModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id]]];
    self.contentArray=(NSMutableArray*)[[localArray reverseObjectEnumerator] allObjects];//倒序排列
    [self.tableView reloadData];
 
    NSArray*requiredArray=(NSMutableArray*) [changeModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@<>%@",[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"status"],@"3"]];
    [requiredArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        changeModel*model=localArray[idx];
        [self getStatusWithID:model];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      changeHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"changeHistoryCell"];
      changeModel*model=self.contentArray[indexPath.row];
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
      [cell configModel:model];
      return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    changeDetailController * vc = [[changeDetailController alloc]init];
    changeModel*model=self.contentArray[indexPath.row];
    vc.model=model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark--下拉刷新
-(void)refreshHeaderAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    [self reloadAllLocalData];
}



/**
 刷新兑币进度状态
 */
-(void)getStatusWithID:(changeModel*)model{
   
    [SVProgressHUD show];
    // 请求头
    NSString *accessPath = ChangellyHOST;
    // 请求参数字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"Bipay" forKey:@"id"];
    [params setValue:@"2.0" forKey:@"jsonrpc"];
    [params setValue:@"getStatus" forKey:@"method"];
    [params setValue:@{@"id":model.txid} forKey:@"params"];
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    [manager.requestSerializer setValue:APIKEY forHTTPHeaderField:@"api-key"];
    [manager.requestSerializer setValue:[ToolUtil hmac:params withKey:Secret] forHTTPHeaderField:@"sign"];
    [manager.requestSerializer setValue:model.txid forHTTPHeaderField:@"custom"];
    //post请求
    [manager POST:accessPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary*dic= task.currentRequest.allHTTPHeaderFields;
       
        if ([dic[@"custom"] isEqualToString:model.txid]) {
            
            if ([responseObject[@"result"] isEqualToString:@"confirming"]||[responseObject[@"result"] isEqualToString:@"waiting"]) {
                model.status=@"0";
                
            }else if ([responseObject[@"result"] isEqualToString:@"exchanging"]) {
                model.status=@"1";
            }
            else if ([responseObject[@"result"] isEqualToString:@"sending"]) {
                model.status=@"2";
              
            }
            else if ([responseObject[@"result"] isEqualToString:@"finished"]) {
                model.status=@"3";
                
            }else{
                model.status=@"4";
            }
            [model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:model.bg_id]]];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
    }];
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
