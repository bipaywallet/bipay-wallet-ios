//
//  WalletManagerController.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "WalletManagerController.h"
#import "ImageButton.h"
#import "WalletManagerViewCell.h"
#import "CreatWalletController.h"
#import "ImportWalletController.h"
#import "walletDetailController.h"
@interface WalletManagerController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ImageButton * createWallet;
@property (nonatomic, strong) ImageButton * inputWallet;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation WalletManagerController
#pragma mark -- LifeCycle

-(NSMutableArray*)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"packetManage");
    self.view.backgroundColor = ViewBackColor;
    [self setControlForSuper];
    [self addConstrainsForSuper];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = ViewBackColor;
    NSMutableArray*dataArray=(NSMutableArray*)[walletModel bg_findAll:nil];
    DNWeak(self);
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        walletModel*wallet=dataArray[idx];
        NSLog(@"钱包id--%@",wallet.bg_id);
        if ([wallet.bg_id isEqual:[UserinfoModel shareManage].wallet.bg_id]) {
            [dataArray removeObject:wallet];
            [dataArray insertObject:wallet atIndex:0];
            weakself.dataArray=dataArray;
            *stop=YES;
        }
    }];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
}

-(void)viewDidDisappear:(BOOL)animated {
[super viewDidDisappear:animated];
}



#pragma mark -- DidReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SetControlForSuper
- (void)setControlForSuper
{
    self.createWallet = [[ImageButton alloc]init];
    [self.createWallet.titleLabel setFont:systemFont(16)];
    self.createWallet.backgroundColor=RGB(43, 45, 71, 1);
    [self.createWallet setTitle:LocalizationKey(@"createPacket") forState:UIControlStateNormal];
    [self.createWallet setImage:IMAGE(@"钱包管理 (1)") forState:UIControlStateNormal];
   
    __weak WalletManagerController*weakSelf=self;
    [self.createWallet  dn_addActionHandler:^{
        
        [weakSelf.navigationController pushViewController:[[CreatWalletController alloc]init] animated:YES];
    }];
    self.inputWallet = [[ImageButton alloc]init];
    [self.inputWallet.titleLabel setFont:systemFont(16)];
    [self.inputWallet setTitle:LocalizationKey(@"importPacket") forState:UIControlStateNormal];
    [self.inputWallet setImage:IMAGE(@"钱包管理 (2)") forState:UIControlStateNormal];
    [self.inputWallet setBackgroundImage:UIIMAGE(@"btnBackground") forState:UIControlStateNormal];
    [self.inputWallet dn_addActionHandler:^{
        
            [weakSelf.navigationController pushViewController:[[ImportWalletController alloc]init] animated:YES];
        
    }];
    self.tableView.backgroundColor = [UIColor clearColor];
  
    [self.tableView registerNib:[UINib nibWithNibName:@"WalletManagerViewCell" bundle:nil] forCellReuseIdentifier:@"walletManager"];
    [self.view addSubview:self.createWallet];
    [self.view addSubview:self.inputWallet];
    [self.view addSubview:self.tableView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    [self.createWallet mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.mas_equalTo(self.view);
        make.width.mas_offset(SCREEN_WIDTH * 0.5);
        make.height.mas_offset(SCREEN_WIDTH*0.12);
    }];
    
    [self.inputWallet mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.mas_equalTo(self.view);
        make.width.mas_offset(SCREEN_WIDTH * 0.5);
        make.height.mas_offset(SCREEN_WIDTH*0.12);
    }];
    UIEdgeInsets edge = UIEdgeInsetsMake(0,
                                         0,
                                         SCREEN_WIDTH*0.12,
                                         0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view).insets(edge);
    }];


}

#pragma mark -- Target Methods

#pragma mark -- Private Methods

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    walletModel*wallet=self.dataArray[indexPath.section];
    WalletManagerViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"walletManager"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSArray* modelArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id],[NSObject bg_sqlKey:@"collect"],[NSObject bg_sqlValue:@(1)]]];
    cell.walletName.text=wallet.name;
    cell.coinAmount.text=[NSString stringWithFormat:@"%@%lu%@",LocalizationKey(@"walletContain"),(unsigned long)modelArray.count,LocalizationKey(@"currencyCount")];
    cell.detailBtn.tag=indexPath.section;
    [cell.detailBtn addTarget:self action:@selector(detailVC:) forControlEvents:UIControlEventTouchUpInside];
    if ([wallet.bg_id isEqual:[UserinfoModel shareManage].wallet.bg_id]) {
        cell.walletImage.image=UIIMAGE(@"walletmangerselected");
        cell.coinAmount.textColor=[UIColor whiteColor];
        cell.walletMoney.textColor=RGB(11, 81, 131, 1);
        [cell.detailBtn setBackgroundImage:UIIMAGE(@"walletdrop") forState:UIControlStateNormal];
    }else{
        cell.walletImage.image=UIIMAGE(@"walletmangernomal");
        cell.coinAmount.textColor=RGB(122, 134, 164, 1);
        cell.walletMoney.textColor=RGB(19, 168, 215, 1);
        [cell.detailBtn setBackgroundImage:UIIMAGE(@"guanlidetail") forState:UIControlStateNormal];

    }
    return cell;
}
//查看详情
-(void)detailVC:(UIButton*)sender{
    
    walletModel*model=self.dataArray[sender.tag];
    walletDetailController*detailVC=[[walletDetailController alloc]init];
    detailVC.wallet=model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    walletModel*model=self.dataArray[indexPath.section];
    [UserinfoModel shareManage].wallet=model;
    [NSUserDefaultUtil PutNumberDefaults:CurrentWalletID Value:model.bg_id];//存储到本地
    [[NSNotificationCenter defaultCenter] postNotificationName:WalletChange object:nil];
    [self.navigationController popViewControllerAnimated:YES];
   
}
///===========================================================================
///                              HeaderView
///===========================================================================
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (iPhone6_Plus) {
        return 20;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = ViewBackColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor=lineColor;
        LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"noblance" titleStr:LocalizationKey(@"noWallet")];
        _tableView.ly_emptyView = emptyView;
        _tableView.backgroundColor =RGB(1, 7, 50, 1);
        if(@available(iOS 11.0,*)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
      
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        

    }
    return _tableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
