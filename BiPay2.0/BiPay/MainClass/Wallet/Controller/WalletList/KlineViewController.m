//
//  KlineViewController.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "KlineViewController.h"
#import "ReceivablesController.h"
#import "TransferController.h"
#import "TradeRecordViewCell.h"
#import "TradeDetailController.h"
#import "HomeNetManager.h"
#import "TradeModel.h"
#import "TransferModel.h"
#import "tradeHeaderView.h"
#import "sectionTradeView.h"

@interface KlineViewController ()
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UILabel *collectTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *transferLab;
@property(nonatomic,strong)NSArray*contentArray;
@property(nonatomic,strong)tradeHeaderView*headerView;
@end

@implementation KlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=self.coinModel.brand;
    [self.tableView registerNib:[UINib nibWithNibName:@"TradeRecordViewCell" bundle:nil] forCellReuseIdentifier:@"record"];
    [self.tableView registerNib:[UINib nibWithNibName:@"latelyTradeCell" bundle:nil] forCellReuseIdentifier:@"latelycell"];
    [self headRefreshWithScrollerView:self.tableView];
    self.tableView.separatorColor=lineColor;
    self.tableView.tableFooterView=[UIView new];
   
    LYEmptyView*emptyView=[LYEmptyView emptyActionViewWithImageStr:@"noRecord" titleStr:nil detailStr:LocalizationKey(@"notransation") btnTitleStr:nil btnClickBlock:nil];;
    emptyView.contentViewOffset = 90;//设置偏移量
    self.tableView.ly_emptyView = emptyView;
    self.tableView.backgroundColor =ViewBackColor;
    self.tableView.rowHeight=120;
    self.tableView.separatorInset=UIEdgeInsetsMake(0,15, 0, 15);
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0];

}

-(void)delayMethod{
    self.headerView=[tradeHeaderView instancesectionHeaderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    self.tableView.tableHeaderView=self.headerView;
    self.headerView.totalMoney.text=[NSString stringWithFormat:@"%.8f",[self.coinModel.totalAmount doubleValue]];
    if ([[NSUserDefaultUtil  GetDefaults:MoneyChange] isEqualToString:@"CNY"]) {
        self.headerView.cnyLabel.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.coinModel.closePrice doubleValue]*[self.coinModel.totalAmount doubleValue]];
    }else{
        self.headerView.cnyLabel.text=[NSString stringWithFormat:@"≈%.2f USD",[self.coinModel.usdPrice doubleValue]*[self.coinModel.totalAmount doubleValue]];
    }
    self.headerView.addressLabel.text=[NSString stringWithFormat:@"%@%@",LocalizationKey(@"currentAddress"),self.coinModel.address];
    [self.headerView.AddressBtn addTarget:self action:@selector(copyAddress) forControlEvents:UIControlEventTouchUpInside];
}
/**
 复制地址
 */
-(void)copyAddress{
    
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:self.coinModel.address];
    if (pab == nil) {
        [self.view makeToast:LocalizationKey(@"copyFail") duration:1.5 position:CSToastPositionCenter];
    }else
    {
        [self.view makeToast:LocalizationKey(@"copySuccess") duration:1.5 position:CSToastPositionCenter];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = ViewBackColor;
    self.transferLab.text = LocalizationKey(@"transfer");
    self.collectTitleLab.text = LocalizationKey(@"collection");
    [self reloadAllLocalData];
    [self checkBlockHeight];
}
#pragma mark-查看最新区块高度
- (void)extracted {
    NSString*coinName;
    if (self.coinModel.fatherCoin) {//代币
        if ([self.coinModel.fatherCoin isEqualToString:@"ETH"]) {
            coinName=self.coinModel.fatherCoin;
            
        }else if ([self.coinModel.fatherCoin isEqualToString:@"BTC"]) {
            coinName=self.coinModel.fatherCoin;
        }
        
    }else{//非代币
       coinName=self.coinModel.brand;
    }
    DNWeak(self);
    [HomeNetManager latestblockHeightcoinName:coinName CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                long BlockHeight=[resPonseObj[@"data"] longLongValue];
                if (weakself.coinModel.blockHeight<BlockHeight) {
                    [weakself getDatafromstart:[NSString stringWithFormat:@"%ld",weakself.coinModel.blockHeight] withEnd:[NSString stringWithFormat:@"%ld",BlockHeight]];//查询最新的交易记录
                }
            }else{
                [weakself.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [weakself.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
}

-(void)checkBlockHeight{
    [self extracted];
}


#pragma mark-转账或收款点击事件
- (IBAction)touchEvent:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            //转账
            TransferController*transf=[[TransferController alloc]init];
            transf.coin=self.coinModel;
            [self.navigationController pushViewController:transf animated:YES];
        }
            break;
        case 1:
        {
            //收款
            ReceivablesController*receive=[[ReceivablesController alloc]init];
            receive.coin=self.coinModel;
            [self.navigationController pushViewController:receive animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark-查询某一地址交易记录

-(void)getDatafromstart:(NSString*)startheight withEnd:(NSString*)endheight{
    DNWeak(self);
    if (self.coinModel.fatherCoin) {//代币
        if ([self.coinModel.fatherCoin isEqualToString:@"ETH"]) {
            [SVProgressHUD show];
            [HomeNetManager TokenblockHeightchecksingleAddress:self.coinModel.address WithAddress:self.coinModel.contractAddress coinName:self.coinModel.fatherCoin confirmations:1 startHeight:startheight endHeight:endheight CompleteHandle:^(id resPonseObj, int code) {
                [SVProgressHUD dismiss];
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
                        NSArray*modelArray=[TradeModel mj_objectArrayWithKeyValuesArray:[NSDictionary changeType:trades]];//将NSArray中的Null类型的项目转化成@""
                        
                        if (modelArray.count!=0) {
                            [weakself saveTrademodelToCoin:modelArray];
                        }
                        
                    }else{
                        [weakself.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                    }
                }else{
                    [weakself.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
                }
                
      
                
            }];
   
        }else if ([self.coinModel.fatherCoin isEqualToString:@"BTC"])
        { //USDT
            [SVProgressHUD show];
            [HomeNetManager blockHeightchecksingleAddress:self.coinModel.address coinName:@"OMNI" confirmations:1 startHeight:startheight endHeight:endheight CompleteHandle:^(id resPonseObj, int code) {
               [SVProgressHUD dismiss];
                if (code) {
                    if ([resPonseObj[@"code"] integerValue] == 0) {
                        NSArray*DataArray=resPonseObj[@"data"];
                       
                        NSMutableArray *trades = [NSMutableArray arrayWithArray:DataArray];
                        NSSortDescriptor *priceDescriptor = [NSSortDescriptor
                                                             sortDescriptorWithKey:@"blockTime"
                                                             ascending:YES
                                                             selector:@selector(compare:)];
                        NSSortDescriptor *modelDescriptor = [NSSortDescriptor
                                                             sortDescriptorWithKey:@"model"
                                                             ascending:YES
                                                             selector:@selector(caseInsensitiveCompare:)];
                        
                        NSArray *descriptors = @[priceDescriptor, modelDescriptor];
                        //给字典按照时间排序
                        [trades sortUsingDescriptors:descriptors];
                        NSArray*modelArray=[TradeModel mj_objectArrayWithKeyValuesArray:[NSDictionary changeType:trades]];//将NSArray中的Null类型的项目转化成@""
                        if (modelArray.count!=0) {
                            [weakself saveTrademodelToCoin:modelArray];
                        }
                        
                    }else{
                        [weakself.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                    }
                }else{
                    [weakself.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
                }
                
            } ];
            
            
            
            
            
            
            
        }
    
        else{//其他代币
            
            
        }
        
    }else{//非代币
        [SVProgressHUD show];
        [HomeNetManager blockHeightchecksingleAddress:self.coinModel.address coinName:self.coinModel.brand  confirmations:1 startHeight:startheight endHeight:endheight CompleteHandle:^(id resPonseObj, int code) {
            [SVProgressHUD dismiss];
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
                    NSArray*modelArray=[TradeModel mj_objectArrayWithKeyValuesArray:[NSDictionary changeType:trades]];//将NSArray中的Null类型的项目转化成@""
                    if (modelArray.count!=0) {
                        [weakself saveTrademodelToCoin:modelArray];
                    }
                    
                }else{
                    [weakself.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [weakself.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
            
        } ];
    }
    
   
}
#pragma mark-存储币种的交易记录

-(void)saveTrademodelToCoin:(NSArray*)tradeArray{
    DNWeak(self);
    if (self.coinModel.fatherCoin) {//代币
        if ([self.coinModel.fatherCoin isEqualToString:@"ETH"]) {
            [tradeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TradeModel*model=tradeArray[idx];
                //代币时，取Value
               model.amount= [NSString stringWithFormat:@"%.8f",[model.value doubleValue]/(pow(10, [weakself.coinModel.decimals intValue]))];
                model.fee= [NSString stringWithFormat:@"%.8f",[model.fee doubleValue]/(pow(10, 18))];
                if (![model.contractAddress isEqualToString:@""]) {//过滤contractAddress
                    
                    if ([model.from isEqualToString:weakself.coinModel.address]) {
                        //我转给别人
                        model.amount= [NSString stringWithFormat:@"- %.8f",[model.amount doubleValue]];
                    }else{
                        model.amount= [NSString stringWithFormat:@"+ %.8f",[model.amount doubleValue]];
                    }
                    model.walletID=[UserinfoModel shareManage].wallet.bg_id;
                    //如果有相同的txid，则更新本地model
                    __block BOOL _isContinue=NO;
                    NSArray*localArray=(NSMutableArray*) [TradeModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                    
                    [ localArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        TradeModel*trade=localArray[idx];
                        if ([trade.txid isEqualToString:model.txid]) {
                            trade.blockHeight=model.blockHeight;
                            trade.amount=model.amount;
                            trade.fee=model.fee;
                            trade.time=model.time;
                            _isContinue=YES;
                            [trade bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" , [NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:weakself.coinModel.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:trade.bg_id]]];
                            *stop=YES;
                        }
                    }];
                    if (!_isContinue) {
                        NSLog(@"添加新交易记录model");
                        model.own_id=weakself.coinModel.bg_id;
                        [model bg_save];
                    }
                    if (idx==tradeArray.count-1) {//记录最近一条数据的区块高度
                        self.coinModel.blockHeight=[model.blockHeight longLongValue];
                        [self.coinModel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                    }
                }
                
            }];
            
        }else if([self.coinModel.fatherCoin isEqualToString:@"BTC"]){
        //USDT类
            
            [tradeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TradeModel*model=tradeArray[idx];
                model.amount=  [NSString stringWithFormat:@"%.8f",[model.amount doubleValue]/pow(10, 8)];
                model.fee=  [NSString stringWithFormat:@"%.8f",[model.fee doubleValue]/pow(10, 8)];
                model.from=model.sendingAddress;
                model.to=model.referenceAddress;
                model.time=[ToolUtil dateTodateStringWithtime:model.blockTime];
                if ([model.from isEqualToString:weakself.coinModel.address]) {
                    //我转给别人
                    model.amount= [NSString stringWithFormat:@"- %.8f",[model.amount doubleValue]];
                }else{
                    model.amount= [NSString stringWithFormat:@"+ %.8f",[model.amount doubleValue]];
                }
                model.walletID=[UserinfoModel shareManage].wallet.bg_id;
                //如果有相同的txid，则更新本地model
                __block BOOL _isContinue=NO;
                NSArray*localArray=(NSMutableArray*) [TradeModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                
                [ localArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TradeModel*trade=localArray[idx];
                    if ([trade.txid isEqualToString:model.txid]) {
                        trade.blockHeight=model.blockHeight;
                        trade.amount=model.amount;
                        trade.fee=model.fee;
                        trade.time=model.time;
                        _isContinue=YES;
                        [trade bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" , [NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.coinModel.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:trade.bg_id]]];
                        *stop=YES;
                    }
                }];
                if (!_isContinue) {
                    NSLog(@"添加新交易记录model");
                    model.own_id=weakself.coinModel.bg_id;
                    [model bg_save];
                }
                if (idx==tradeArray.count-1) {//记录最近一条数据的区块高度
                    self.coinModel.blockHeight=[model.blockHeight longLongValue];
                    [self.coinModel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                }
                
            }];
            
            
        }else{
            
          
            
            
            
        }
        
    }else{//非代币
        if ([self.coinModel.recordType intValue]==0) {//BTC等
            
            [tradeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __block BOOL _IsFrom=NO;
                TradeModel*model=tradeArray[idx];
                model.amount=  [NSString stringWithFormat:@"%.8f",[model.amount doubleValue]/pow(10, 8)];
                model.fee=  [NSString stringWithFormat:@"%.8f",[model.fee doubleValue]/pow(10, 8)];
                model.walletID=[UserinfoModel shareManage].wallet.bg_id;
                [model.inputs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TransferModel*transModel=model.inputs[idx];
                    if ([transModel.address isEqualToString:weakself.coinModel.address]) {
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
                        transModel.amount=  [NSString stringWithFormat:@"%.8f",[transModel.amount doubleValue]/pow(10, 8)];
                        if (![transModel.address isEqualToString:weakself.coinModel.address]) {
                            total=total+[transModel.amount doubleValue];
                            model.Toaddress=transModel.address;
                        }
                    }];
                    if ([model.Toaddress isEqualToString:@""]||!model.Toaddress) {
                        model.Toaddress=self.coinModel.address;
                    }
                    model.amount=[NSString stringWithFormat:@"- %.8f",total];
                    
                }else{
                    //别人转给自己
                    __block double total=0;
                    [model.outputs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        TransferModel*transModel=model.outputs[idx];
                         transModel.amount=  [NSString stringWithFormat:@"%.8f",[transModel.amount doubleValue]/pow(10, 8)];
                        if ([transModel.address isEqualToString:weakself.coinModel.address]) {
                            total=[transModel.amount doubleValue];
                            model.Toaddress=weakself.coinModel.address;
                        }
                    }];
                    model.amount= [NSString stringWithFormat:@"+ %.8f",total];
                    
                }
                //如果有相同的txid，则更新本地model
                __block BOOL _isContinue=NO;
                
                NSArray*localArray=(NSMutableArray*) [TradeModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.coinModel.bg_id]]];
                [ localArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TradeModel*trade=localArray[idx];
                    if ([trade.txid isEqualToString:model.txid]) {
                        trade.blockHeight=model.blockHeight;
                        trade.amount=model.amount;
                        trade.fee=model.fee;
                        trade.time=model.time;
                        _isContinue=YES;
                        [trade bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" , [NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.coinModel.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:trade.bg_id]]];
                        
                        *stop=YES;
                    }
                }];
                if (!_isContinue) {
                    NSLog(@"添加model");
                    model.own_id=self.coinModel.bg_id;
                    [model bg_save];
                }
                if (idx==tradeArray.count-1) {//记录最近一条数据的区块高度
                    self.coinModel.blockHeight=[model.blockHeight longLongValue];
                    [self.coinModel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                }
            }];
            
        }if ([self.coinModel.recordType intValue]==1){//ETH等
            
            [tradeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TradeModel*model=tradeArray[idx];
                  model.amount=  [NSString stringWithFormat:@"%.8f",[model.amount doubleValue]/pow(10, 18)];
                 model.fee=  [NSString stringWithFormat:@"%.8f",[model.fee doubleValue]/pow(10, 18)];
                if ([model.from isEqualToString:weakself.coinModel.address]) {
                    //我转给别人
                    model.amount= [NSString stringWithFormat:@"- %.8f",[model.amount doubleValue]];
                }else{
                    model.amount= [NSString stringWithFormat:@"+ %.8f",[model.amount doubleValue]];
                }
                model.walletID=[UserinfoModel shareManage].wallet.bg_id;
                //如果有相同的txid，则更新本地model
                __block BOOL _isContinue=NO;
                NSArray*localArray=(NSMutableArray*) [TradeModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                
                [ localArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TradeModel*trade=localArray[idx];
                    if ([trade.txid isEqualToString:model.txid]) {
                        trade.blockHeight=model.blockHeight;
                        trade.amount=model.amount;
                        trade.fee=model.fee;
                        trade.time=model.time;
                        _isContinue=YES;
                        [trade bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" , [NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.coinModel.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:trade.bg_id]]];
                        *stop=YES;
                    }
                }];
                if (!_isContinue) {
                    NSLog(@"添加新交易记录model");
                    model.own_id=self.coinModel.bg_id;
                    [model bg_save];
                }
                if (idx==tradeArray.count-1) {//记录最近一条数据的区块高度
                    self.coinModel.blockHeight=[model.blockHeight longLongValue];
                    [self.coinModel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                }
                
            }];
        }
        else{//其他类型币种
            
            
        }
    }
    
    [self reloadAllLocalData];
}


#pragma mark-本地获取交易记录并刷新单元格
-(void)reloadAllLocalData{
    NSArray*localArray=(NSMutableArray*) [TradeModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.coinModel.bg_id]]];
    self.contentArray=(NSMutableArray*)[[localArray reverseObjectEnumerator] allObjects];//倒序排列
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TradeModel*model=self.contentArray[indexPath.row];
    TradeRecordViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"record"];
    cell.recordTitle.text=model.txid;
    cell.recordDate.text=model.time;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.recordMoney.text=model.amount;

    if ([model.blockHeight isEqualToString:@"--"]) {
        cell.recordStatus.text=LocalizationKey(@"waitConfirm");
        cell.recordStatus.textColor=RedColor;
    }else{
        cell.recordStatus.text=LocalizationKey(@"completed");
        cell.recordStatus.textColor=DealTitleColor;
    }
    if ([self.coinModel.recordType intValue]==0) {//BTC类型
        if ([model.amount  containsString:@"-"]) {
            cell.recordImage.image = UIIMAGE(@"outorder");
            cell.directionLabel.text=LocalizationKey(@"transfer");
        }else{
            cell.recordImage.image =UIIMAGE(@"inorder");
            cell.directionLabel.text=LocalizationKey(@"collection");
        }
    }else if ([self.coinModel.recordType intValue]==1){//ETH类型
        
        if ([model.from isEqualToString:self.coinModel.address]) {
            cell.recordImage.image =UIIMAGE(@"outorder");//我转给别人
            cell.directionLabel.text=LocalizationKey(@"transfer");
        }else{
            cell.recordImage.image =UIIMAGE(@"inorder");
            cell.directionLabel.text=LocalizationKey(@"collection");
        }
        
    }else if ([self.coinModel.recordType intValue]==2){//USDT类型
        
        if ([model.from isEqualToString:self.coinModel.address]) {
            cell.recordImage.image =UIIMAGE(@"outorder");//我转给别人
            cell.directionLabel.text=LocalizationKey(@"transfer");
        }else{
            cell.recordImage.image =UIIMAGE(@"inorder");
            cell.directionLabel.text=LocalizationKey(@"collection");
        }
        
    }else{
    
        
    }
    if ((indexPath.row==self.contentArray.count-1)) {
        cell.lineView.hidden=YES;//去除最后一行分割线

    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.contentArray.count> 0) {
        sectionTradeView*sectionView=[sectionTradeView instancesectionHeaderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [sectionView setconerLayers];
        return sectionView;
    }else{
        return nil;
    }
    
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeModel*model=self.contentArray[indexPath.row];
    TradeDetailController * vc = [[TradeDetailController alloc]init];
    vc.coin=self.coinModel;
    vc.model=model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark--下拉刷新
-(void)refreshHeaderAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    [self checkBlockHeight];
    [self updateTatalMoney];
}

//更新总额
-(void)updateTatalMoney{
    DNWeak(self);
    //代币
    if (self.coinModel.fatherCoin) {
    if ([self.coinModel.fatherCoin isEqualToString:@"ETH"]) {
       
        [HomeNetManager coinNameTokenchecksingleAddress:self.coinModel.address WithcontractAddress:self.coinModel.contractAddress coinName:self.coinModel.fatherCoin CompleteHandle:^(id resPonseObj, int code, NSString *coinName) {
            if (code) {
                if ([resPonseObj[@"code"] integerValue] == 0) {
                    NSDictionary*dic=(NSDictionary*)[resPonseObj[@"data"] firstObject];
                  
                    weakself.coinModel.totalAmount= [NSString stringWithFormat:@"%.8f",[[dic[@"totalAmount"] description] doubleValue]/(pow(10, [weakself.coinModel.decimals intValue]))];
                    
                    [weakself.coinModel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                    [weakself resetTitleMoneyWith:weakself.coinModel.totalAmount];
                    
                }else{
                    [weakself.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [weakself.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
            
        }];
        
        
        
    }else if ([self.coinModel.fatherCoin isEqualToString:@"BTC"])
    {//USDT
      
        [HomeNetManager coinNamechecksingleAddress:self.coinModel.address coinName:@"OMNI" CompleteHandle:^(id resPonseObj, int code,NSString*coinName) {//查询地址余额
            if (code) {
                if ([resPonseObj[@"code"] integerValue] == 0) {
                    if (![resPonseObj[@"data"] isKindOfClass:[NSArray class]]) {
                        [weakself.view makeToast:LocalizationKey(@"responseErro") duration:1.5 position:CSToastPositionCenter];
                        return ;
                    }
                    NSDictionary*dic=[resPonseObj[@"data"] firstObject];
              
                    weakself.coinModel.totalAmount=  [NSString stringWithFormat:@"%.8f",[dic[@"totalAmount"] doubleValue]/pow(10, 8)];
                    [weakself.coinModel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                     [weakself resetTitleMoneyWith:weakself.coinModel.totalAmount];
                }else{
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                
            }
        }];
        
        
    }else{ //其他代币
        
        
        
    }
        
    }else{
       //非代币
        [HomeNetManager coinNamechecksingleAddress:self.coinModel.address coinName:self.coinModel.brand CompleteHandle:^(id resPonseObj, int code,NSString*coinName) {//查询地址余额
            if (code) {
                if ([resPonseObj[@"code"] integerValue] == 0) {
                    if (![resPonseObj[@"data"] isKindOfClass:[NSArray class]]) {
                        [weakself.view makeToast:LocalizationKey(@"responseErro") duration:1.5 position:CSToastPositionCenter];
                        return ;
                    }
                    NSDictionary*dic=[resPonseObj[@"data"] firstObject];
              
                    if ([weakself.coinModel.recordType intValue]==1) {//ETH类
                        weakself.coinModel.totalAmount=  [NSString stringWithFormat:@"%.8f",[dic[@"totalAmount"] doubleValue]/pow(10, 18)];
                    }else{
                        
                          weakself.coinModel.totalAmount=  [NSString stringWithFormat:@"%.8f",[dic[@"totalAmount"] doubleValue]/pow(10, 8)];
                    }
                    
                    [weakself.coinModel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:weakself.coinModel.bg_id]]];
                    [weakself resetTitleMoneyWith:weakself.coinModel.totalAmount];
                    
                }else{
                    [weakself.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                
            }
        }];
        
    }
  
}

-(void)resetTitleMoneyWith:(NSString*)totalAmount{
     self.headerView.totalMoney.text=[NSString stringWithFormat:@"%.8f",[self.coinModel.totalAmount doubleValue]];
    if ([[NSUserDefaultUtil  GetDefaults:MoneyChange] isEqualToString:@"CNY"]) {
        
        self.headerView.cnyLabel.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.coinModel.closePrice doubleValue]*[totalAmount doubleValue]];
    }else{
        self.headerView.cnyLabel.text=[NSString stringWithFormat:@"≈%.2f USD",[self.coinModel.usdPrice doubleValue]*[totalAmount doubleValue]];
    }
}

-(void)dealloc{
    
    
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
