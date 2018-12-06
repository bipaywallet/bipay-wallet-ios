//
//  TradeDetailController.m
//  BiPay
//
//  Created by zjs on 2018/6/20.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "TradeDetailController.h"
#import "TradedetailHeadView.h"
#import "tradeDetailCell.h"
#import "TxidCheckViewController.h"
@interface TradeDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * detailArray;

@property (nonatomic, strong) TradedetailHeadView * tableHeadView;
@end

@implementation TradeDetailController
#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ViewBackColor;
    self.title = LocalizationKey(@"dealDetail");
    [self setControlForSuper];
    [self addConstrainsForSuper];
    if ([self.coin.recordType intValue]==0) {//BTC,LTC类型
        if ([self.model.amount containsString:@"-"]) {
            self.tableHeadView.tradetype.image=UIIMAGE(@"outorder");
            self.tableHeadView.tradeTitle.text=LocalizationKey(@"transfer");
            //转给对方
            if ([self.model.remark isEqualToString:@""]||!self.model.remark) {
    
                self.titleArray = @[LocalizationKey(@"inAddress"),LocalizationKey(@"fee"),LocalizationKey(@"blockHeight"),LocalizationKey(@"dealNum"),LocalizationKey(@"dealTime")];
                self.detailArray = @[self.model.Toaddress,[NSString stringWithFormat:@"%.8f",[self.model.fee doubleValue]],self.model.blockHeight,self.model.txid,self.model.time];
            }else{

                self.titleArray = @[LocalizationKey(@"inAddress"),LocalizationKey(@"fee"),LocalizationKey(@"blockHeight"),LocalizationKey(@"dealNum"),LocalizationKey(@"dealTime"),LocalizationKey(@"remark")];
                self.detailArray = @[self.model.Toaddress,[NSString stringWithFormat:@"%.8f",[self.model.fee doubleValue]],self.model.blockHeight,self.model.txid,self.model.time,self.model.remark];
            }
            
        }else{
            self.tableHeadView.tradetype.image=UIIMAGE(@"inorder");
            self.tableHeadView.tradeTitle.text=LocalizationKey(@"collection");
            //对方转自己
            if ([self.model.remark isEqualToString:@""]||!self.model.remark) {
                
                self.titleArray = @[LocalizationKey(@"inAddress"),LocalizationKey(@"fee"),LocalizationKey(@"blockHeight"),LocalizationKey(@"dealNum"),LocalizationKey(@"dealTime")];
                self.detailArray = @[self.model.Toaddress,[NSString stringWithFormat:@"%.8f",[self.model.fee doubleValue]],self.model.blockHeight,self.model.txid,self.model.time];
            }else{
                
                self.titleArray = @[LocalizationKey(@"inAddress"),LocalizationKey(@"fee"),LocalizationKey(@"blockHeight"),LocalizationKey(@"dealNum"),LocalizationKey(@"dealTime"),LocalizationKey(@"remark")];
                self.detailArray = @[self.model.Toaddress,[NSString stringWithFormat:@"%.8f",[self.model.fee doubleValue]],self.model.blockHeight,self.model.txid,self.model.time,self.model.remark];
            }
        }
    }else if ([self.coin.recordType intValue]==1||[self.coin.recordType intValue]==2){//ETH类型或者USDT类型
        if ([self.coin.address isEqualToString:self.model.from]) {
            self.tableHeadView.tradetype.image=UIIMAGE(@"outorder");
            self.tableHeadView.tradeTitle.text=LocalizationKey(@"transfer");
            //转给对方
            if ([self.model.remark isEqualToString:@""]||!self.model.remark) {
                
                self.titleArray = @[LocalizationKey(@"outAddress"),LocalizationKey(@"inAddress"),LocalizationKey(@"fee"),LocalizationKey(@"blockHeight"),LocalizationKey(@"dealNum"),LocalizationKey(@"dealTime")];
                self.detailArray = @[self.model.from,self.model.to,[NSString stringWithFormat:@"%.8f",[self.model.fee doubleValue]],self.model.blockHeight,self.model.txid,self.model.time];
            }else{
                self.titleArray = @[LocalizationKey(@"outAddress"),LocalizationKey(@"inAddress"),LocalizationKey(@"fee"),LocalizationKey(@"blockHeight"),LocalizationKey(@"dealNum"),LocalizationKey(@"dealTime"),LocalizationKey(@"remark")];
                self.detailArray = @[self.model.from,self.model.to,[NSString stringWithFormat:@"%.8f",[self.model.fee doubleValue]],self.model.blockHeight,self.model.txid,self.model.time,self.model.remark];
            }
            
        }else{
           //对方转自己
            self.tableHeadView.tradetype.image=UIIMAGE(@"inorder");
            self.tableHeadView.tradeTitle.text=LocalizationKey(@"collection");
            if ([self.model.remark isEqualToString:@""]||!self.model.remark) {
                self.titleArray = @[LocalizationKey(@"outAddress"),LocalizationKey(@"inAddress"),LocalizationKey(@"fee"),LocalizationKey(@"blockHeight"),LocalizationKey(@"dealNum"),LocalizationKey(@"dealTime")];
                self.detailArray = @[self.model.from,self.model.to,[NSString stringWithFormat:@"%.8f",[self.model.fee doubleValue]],self.model.blockHeight,self.model.txid,self.model.time];
            }else{
                self.titleArray = @[LocalizationKey(@"outAddress"),LocalizationKey(@"inAddress"),LocalizationKey(@"fee"),LocalizationKey(@"blockHeight"),LocalizationKey(@"dealNum"),LocalizationKey(@"dealTime"),LocalizationKey(@"remark")];
                self.detailArray = @[self.model.from,self.model.to,[NSString stringWithFormat:@"%.8f",[self.model.fee doubleValue]],self.model.blockHeight,self.model.txid,self.model.time,self.model.remark];
            }
        
            
        }
     
        
    }else{
      
        
        
        
        
    }
 
    
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
    self.tableHeadView = [[TradedetailHeadView alloc]initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              SCREEN_WIDTH,
                                                                              SCREEN_WIDTH*0.4)];
    //MARK:--处理数据
    NSString * amount = self.model.amount;
    NSString * coin = self.coin.brand;
    NSString * appendStr = [NSString stringWithFormat:@"%@ %@",amount,coin];
    NSRange amountRange = [appendStr rangeOfString:coin];
    NSAttributedString * atr = [appendStr changeFont:systemFont(26) andRange:amountRange];
    self.tableHeadView.trademoney.attributedText=atr;
    self.tableView.tableHeaderView = self.tableHeadView;
    if ([self.model.blockHeight isEqualToString:@"--"]) {
        self.tableHeadView.tradeStatu.text=LocalizationKey(@"waitConfirm");
        self.tableHeadView.tradeStatu.textColor=RedColor;
    }else{
        self.tableHeadView.tradeStatu.text=LocalizationKey(@"completed");
        self.tableHeadView.tradeStatu.textColor=DealTitleColor;
    }
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
    tradeDetailCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleLabel.text            = self.titleArray[indexPath.row];
    cell.detailLabel.text      = self.detailArray[indexPath.row];
    cell.textLabel.textColor       = [UIColor lightGrayColor];
    cell.detailLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([cell.titleLabel.text isEqualToString:LocalizationKey(@"dealNum")]) {
        cell.hightConstant.constant=20;
        [cell.checkBtn addTarget:self action:@selector(Tocheck:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.hightConstant.constant=0;
    }
    return cell;
}
#pragma mark---交易号，区区块浏览器查看
-(void)Tocheck:(UIButton*)sender{
    
    TxidCheckViewController*txidVC=[[TxidCheckViewController alloc]init];
    txidVC.txid=self.model.txid;//交易号
    txidVC.coin=self.coin;
    if ([self.coin.brand isEqualToString:@"XNE"]||[self.coin.brand isEqualToString:@"GCA"]||[self.coin.brand isEqualToString:@"GCB"]||[self.coin.brand isEqualToString:@"GCC"]||[self.coin.brand isEqualToString:@"STO"]||[self.coin.brand isEqualToString:@"QTUM"]||[self.coin.brand isEqualToString:@"DASH"]) {
         [self.view makeToast:@"该币种暂不支持查询" duration:1.5 position:CSToastPositionCenter];
    }else{
        [self.navigationController pushViewController:txidVC animated:YES];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString*title=self.titleArray[indexPath.row];
    if ([title isEqualToString:LocalizationKey(@"dealNum")]||[title isEqualToString:LocalizationKey(@"inAddress")]||[title isEqualToString:LocalizationKey(@"outAddress")])  {
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:self.detailArray[indexPath.row]];
        if (pab == nil) {
            [self.view makeToast:LocalizationKey(@"copyFail") duration:1.5 position:CSToastPositionCenter];
        }else
        {
            [self.view makeToast:LocalizationKey(@"copySuccess") duration:1.5 position:CSToastPositionCenter];
        }
    }
        else{
                   
                   
        }
    
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
        [_tableView registerNib:[UINib nibWithNibName:@"tradeDetailCell" bundle:nil] forCellReuseIdentifier:@"cell"];
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
-(void)dealloc{
    
    
}
@end
