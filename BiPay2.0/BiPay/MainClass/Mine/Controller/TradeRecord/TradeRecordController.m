//
//  TradeRecordController.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "TradeRecordController.h"
#import "TradeRecordViewCell.h"
#import "ChangeWalletController.h"
#import "TradeDetailController.h"
#import "HomeNetManager.h"
@interface TradeRecordController ()<UITableViewDelegate,UITableViewDataSource>
{
    walletModel*_currentWallet;
}
@property (nonatomic,strong) UIView *Topview;
@property (nonatomic,weak) UIButton *Selectbutton;
@property(nonatomic,strong)NSMutableArray*contentArray;
@property(nonatomic,strong)coinModel*currentCoin;
@end

@implementation TradeRecordController
static NSString * identifier = @"cell";
#pragma mark -- LifeCycle


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = [UserinfoModel shareManage].wallet.name;
    [self creatBtn:[UserinfoModel shareManage].wallet];
    [self setRightBarButtonItem];
    [self setControlForSuper];
}

-(void)creatBtn:(walletModel*)wallet{
    _currentWallet=wallet;
    [self.Topview removeFromSuperview];
    self.Topview = [[UIView alloc] init];
    self.Topview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    self.Topview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.Topview];
        NSMutableArray *titlearray =[[NSMutableArray alloc]init];
     NSArray*coinArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:_currentWallet.bg_id]]];
    [coinArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        coinModel*model=coinArray[idx];
        if (model.collect==1) {
             [titlearray addObject:model.brand];
        }
    }];
    if (titlearray.count>0) {
        _currentCoin=[titlearray firstObject];
    }else{
        [self.contentArray removeAllObjects];
        [self.tableView reloadData];
    }
    int col = 4;
    int margin = 10;
    for (int i = 0; i < titlearray.count; i++) {
        int page = i/col;
        int index = i%col;
        UIButton *BtnSearch = [[UIButton alloc]initWithFrame:CGRectMake(margin + index*(SCREEN_WIDTH - (col + 1)*margin)/col + margin*index,40*page + 10,(SCREEN_WIDTH - (col + 1)*margin)/col,30 )];
        
        BtnSearch.layer.cornerRadius = 5;
        
        BtnSearch.layer.masksToBounds = YES;
        
        BtnSearch.layer.shadowOffset=CGSizeMake(1, 1);
        
        BtnSearch.layer.shadowOpacity = 0.8;
        
        BtnSearch.layer.shadowColor=[UIColor blackColor].CGColor;
        
        BtnSearch.backgroundColor = [UIColor lightGrayColor];
        BtnSearch.tag = i;
        [BtnSearch setTitle:titlearray[i] forState:UIControlStateNormal];
        [BtnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [BtnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        BtnSearch.titleLabel.font = [UIFont systemFontOfSize:16];
        [BtnSearch addTarget:self action:@selector(SelectBtnSearch:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            BtnSearch.backgroundColor = barTitle;
            BtnSearch.selected = YES;
            self.Selectbutton = BtnSearch;
            [self SelectBtnSearch:BtnSearch];
        }
        [self.Topview addSubview:BtnSearch];
    }
    self.Topview.height = ceil(titlearray.count/4.0)*40+10;

    self.tableView.frame=CGRectMake(0, CGRectGetMaxY(self.Topview.frame), kWindowW,kWindowH-SafeAreaTopHeight-SafeAreaBottomHeight-self.Topview.height);
    
    
}

-(void)SelectBtnSearch:(UIButton*)sender{
    
    if (!sender.isSelected) {
        self.Selectbutton.selected = !self.Selectbutton.selected;
        
        self.Selectbutton.backgroundColor = [UIColor lightGrayColor];
        
        sender.selected = !sender.selected;
        
        sender.backgroundColor = barTitle;
        
        self.Selectbutton = sender;
        
    }
    NSArray*coinArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:_currentWallet.bg_id]]];
    [coinArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        coinModel*model=coinArray[idx];
        if ([model.brand isEqualToString:sender.titleLabel.text]) {
            [self reloadAllLocalDataWithCoinmodel:model];//本地数据填充
            [self checkBlockHeightwithCoinmodel:model];
            self.currentCoin=model;
            *stop=YES;
        }
    }];
}


#pragma mark-查看最新区块高度
-(void)checkBlockHeightwithCoinmodel:(coinModel*)model{
    [HomeNetManager latestblockHeightcoinName:model.brand CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                long BlockHeight=[resPonseObj[@"data"]longLongValue];
                if (model.blockHeight<BlockHeight) {
                    [self getDataWithCoin:model fromstart:[NSString stringWithFormat:@"%ld",model.blockHeight] withEnd:[NSString stringWithFormat:@"%ld",BlockHeight]];//查询最新的交易记录
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            //  [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
}
#pragma mark- 查询某一地址交易记录
-(void)getDataWithCoin:(coinModel*)model fromstart:(NSString*)startheight withEnd:(NSString*)endheight{
    [HomeNetManager blockHeightchecksingleAddress:model.address coinName:model.brand  confirmations:1 startHeight:startheight endHeight:endheight CompleteHandle:^(id resPonseObj, int code) {
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSArray*DataArray=resPonseObj[@"data"];
                NSArray*normalTransactionsArray=[[DataArray lastObject] objectForKey:@"normalTransactions"];
                NSMutableArray *trades = [NSMutableArray arrayWithArray:normalTransactionsArray];
                NSSortDescriptor *priceDescriptor = [NSSortDescriptor
                                                     sortDescriptorWithKey:@"time"
                                                     ascending:YES
                                                     selector:@selector(compare:)];
                NSSortDescriptor *modelDescriptor = [NSSortDescriptor
                                                     sortDescriptorWithKey:@"model"
                                                     ascending:YES
                                                     selector:@selector(caseInsensitiveCompare:)];
                
                NSArray *descriptors = @[priceDescriptor, modelDescriptor];
                //给字典按照时间排序
                [trades sortUsingDescriptors:descriptors];
                NSArray*newModelArray=[TradeModel mj_objectArrayWithKeyValuesArray:trades];
                if (newModelArray.count!=0) {
                    [self saveTrademodelToCoin:newModelArray withCoinmodel:model];
                }
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            //  [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    } ];
   
}

#pragma mark-存储币种的交易记录

-(void)saveTrademodelToCoin:(NSArray*)tradeArray withCoinmodel:(coinModel*)coinModel{
    
    [tradeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL _IsFrom=NO;
        TradeModel*model=tradeArray[idx];
        [model.inputs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TransferModel*transModel=model.inputs[idx];
            if ([transModel.address isEqualToString:coinModel.address]) {
                //为自己转别人
                _IsFrom=YES;
                *stop=YES;
            }
        }];
        if (_IsFrom) {
            //inputs中有自己币种地址，为自己转别人
            __block double total=0;
            [model.outputs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TransferModel*transModel=model.outputs[idx];
                if (![transModel.address isEqualToString:coinModel.address]) {
                    total=total+[transModel.amount doubleValue];
                    model.Toaddress=transModel.address;
                }
            }];
            if ([model.Toaddress isEqualToString:@""]||!model.Toaddress) {
                model.Toaddress=coinModel.address;
            }
            model.amount=[NSString stringWithFormat:@"- %.8f",total];
            
        }else{
            //别人转给自己
            __block double total=0;
            [model.outputs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TransferModel*transModel=model.outputs[idx];
                if ([transModel.address isEqualToString:coinModel.address]) {
                    total=[transModel.amount doubleValue];
                    model.Toaddress=coinModel.address;
                }
            }];
            model.amount= [NSString stringWithFormat:@"+ %.8f",total];
            
        }
        //如果有相同的txid，则更新本地model
        __block BOOL _isContinue=NO;
        NSArray*localArray= [TradeModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:coinModel.bg_id]]];
        [ localArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TradeModel*trade=localArray[idx];
            if ([trade.txid isEqualToString:model.txid]) {
                trade.blockHeight=model.blockHeight;
                trade.amount=model.amount;
                trade.fee=model.fee;
                trade.time=model.time;
                trade.Toaddress=model.Toaddress;
                _isContinue=YES;
              //更新
               [trade bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" , [NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:coinModel.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:trade.bg_id]]];
                
                *stop=YES;
            }
        }];
        if (!_isContinue) {
            NSLog(@"添加model");
             model.own_id=coinModel.bg_id;
            [model bg_save];
        }
        if (idx==tradeArray.count-1) {//记录最近一条数据的区块高度（最近一条记录区块高度最大）
            coinModel.blockHeight=[model.blockHeight longLongValue];
             [coinModel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:coinModel.bg_id]]];
        }
    }];
    [self reloadAllLocalDataWithCoinmodel:coinModel];
    
}

#pragma mark-本地获取交易记录并刷新单元格
-(void)reloadAllLocalDataWithCoinmodel:(coinModel*)coinModel{
     NSArray*localArray= [TradeModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:coinModel.bg_id]]];
    self.contentArray=(NSMutableArray*)[[localArray reverseObjectEnumerator] allObjects];//倒序排列
    [self.tableView reloadData];
    
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



#pragma mark -- SetControlForSuper
- (void)setControlForSuper
{    
    [self.tableView registerClass:[TradeRecordViewCell class] forCellReuseIdentifier:@"record"];
    [self.view addSubview:self.tableView];
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"noRecord" titleStr:LocalizationKey(@"notransation")];
    self.tableView.ly_emptyView = emptyView;
}


#pragma mark -- Target Methods

- (void)rightButtonitemClick
{
    __block TradeRecordController*weakself=self;
    ChangeWalletController * vc = [[ChangeWalletController alloc]init];
    vc.walletBlock = ^(walletModel *wallet) {
        
        weakself.title = wallet.name;
        [weakself creatBtn:wallet];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- Private Methods

- (void)setRightBarButtonItem
{
    UIButton * rightItem = [[UIButton alloc]init];
    [rightItem setImage:IMAGE(@"交易记录_03") forState:UIControlStateNormal];
    [rightItem dn_addActionHandler:^{
        
        [self rightButtonitemClick];
    }];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeModel*model=self.contentArray[indexPath.row];
    TradeRecordViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"record"];
    cell.recordTitle.text=model.txid;
    cell.recordDate.text=model.time;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.recordMoney.text=model.amount;
    if ([model.amount  containsString:@"-"]) {
        cell.recordImage.image = UIIMAGE(@"交易记录_07");
    }else{
        cell.recordImage.image =UIIMAGE(@"交易记录_12");
    }
    if ([model.blockHeight isEqualToString:@"--"]) {
        cell.recordStatus.text=LocalizationKey(@"waitConfirm");
        cell.recordStatus.textColor=RedColor;
    }else{
        cell.recordStatus.text=LocalizationKey(@"completed");
        cell.recordStatus.textColor=DealTitleColor;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeModel*model=self.contentArray[indexPath.row];
    TradeDetailController * vc = [[TradeDetailController alloc]init];
    vc.model=model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
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
    }
    return _tableView;
}


#pragma mark -- DidReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
return <#height#>;
}
*/

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
