//
//  ChangeWalletController.m
//  BiPay
//
//  Created by zjs on 2018/6/20.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ChangeWalletController.h"

@interface ChangeWalletController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray * titleArray;
@end

@implementation ChangeWalletController

#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.title = LocalizationKey(@"switchWallet");
    
    self.titleArray = [walletModel bg_findAll:nil];
    [self setControlForSuper];
    [self addConstrainsForSuper];
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
     [self.view addSubview:self.tableView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark -- Target Methods

#pragma mark -- Private Methods

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"wallet"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wallet"];
    }
    walletModel*wallet=self.titleArray[indexPath.row];
    cell.textLabel.text = wallet.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    walletModel*wallet=self.titleArray[indexPath.row];
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.walletBlock)
    {
        self.walletBlock(wallet);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
///===========================================================================
///                           行高
///===========================================================================
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
        
       
    }
    return _tableView;
}
#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
