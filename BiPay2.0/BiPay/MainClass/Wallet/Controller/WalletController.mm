//
//  WalletController.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "WalletController.h"
#import "WalletAlertPickerView.h"
#import "HomeViewCell.h"
#import "pageScrollView.h"
#import "NoBalanceView.h"
#import "LeftMenuViewController.h"
#import "MMScanViewController.h"
#import "walletDetailController.h"
#import "CreatWalletController.h"
#import "ImportWalletController.h"
#import "AddAssetsController.h"
#import "KlineViewController.h"
#import "HomeNetManager.h"
#import "HomePlaceholderView.h"
#import "TransferController.h"
#import "marketModel.h"
#import "NoticeModel.h"
#import "NSUserDefaultUtil.h"
#import "PlatformMessageDetailViewController.h"
#import "TradeModel.h"
#import "WalletManagerController.h"
#import "UIImage+GIF.h"
#import "HomeHeaderView.h"
#import "CurrencyExchangeViewController.h"
#import "SettingDetailController.h"

@interface WalletController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    
    HomePlaceholderView*_placeView;
    NoBalanceView*      _balanceView;
}
@property (nonatomic,strong) LeftMenuViewController *menu;
@property(nonatomic,strong)UITableView * mainTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;//数据源
@property (nonatomic,strong) NSMutableArray *marketArray;//行情数组
@property(nonatomic,strong)HomeHeaderView*headerView;
@property(nonatomic,strong)NSTimer*timer;
@end

@implementation WalletController

-(NSMutableArray*)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray*)marketArray{
    if (_marketArray == nil) {
        _marketArray = [NSMutableArray array];
    }
    return _marketArray;
}
#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HomeViewBackColor;
    [self setTableViewHeader];
    
}

-(void)setTableViewHeader{
    
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    self.mainTableView.backgroundColor =HomeViewBackColor;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HomeViewCell" bundle:nil] forCellReuseIdentifier:@"HomeViewCell"];
    self.mainTableView.tableFooterView=[[UIView alloc]init];
    self.mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self headRefreshWithScrollerView:_mainTableView];
    [self.view addSubview:_mainTableView];
    self.headerView=[HomeHeaderView instancesectionHeaderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH-30)*308/697+10+50)];
    self.mainTableView.tableHeaderView = self.headerView;
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap)];
    [self.headerView.headerImageV addGestureRecognizer:singleRecognizer];
    [self.headerView.eyeBtn addTarget:self action:@selector(touchEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.addAssetBtn addTarget:self action:@selector(addAsset) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.assetLabel.text=LocalizationKey(@"addProperty");
    if ([[NSUserDefaultUtil GetDefaults:HIDEMONEY] boolValue]) {
     
         self.headerView.eyeBtn.selected=YES;
    }else{
     
        self.headerView.eyeBtn.selected=NO;
    }
  
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reloadWallet) name:WalletChange object:nil];
    [center addObserver:self selector:@selector(reloadAssetKind) name:AddAssets object:nil];
    _balanceView=[NoBalanceView instanceViewWithFrame:CGRectMake(0, (SCREEN_WIDTH-30)*308/697+10+50, kWindowW, kWindowH-(SCREEN_WIDTH-30)*308/697-10-50)];
    _balanceView.hidden=YES;
    [self.view addSubview:_balanceView];
    //MARK:--注册国际化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNotificaiton:) name:LanguageChange object:nil];
   
}

/**
 收到切换语言通知
 */
- (void)languageChangeNotificaiton:(NSNotification *)notification{
    [self headRefreshWithScrollerView:_mainTableView];
    [_placeView.creatBtn setTitle:LocalizationKey(@"creatWallet") forState:UIControlStateNormal];
    [_placeView.importBtn setTitle:LocalizationKey(@"leadinWallet") forState:UIControlStateNormal];
    self.headerView.assetLabel.text=LocalizationKey(@"addProperty");
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //MARK:--复原导航栏颜色
    self.navigationController.navigationBar.barTintColor = NavColor;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //MARK:--首页导航栏颜色
    self.navigationController.navigationBar.barTintColor = HomeNavColor;
    if ([[NSUserDefaultUtil  GetDefaults:MoneyChange] isEqualToString:@"CNY"]) {
        
        self.headerView.nameLabel.text= [NSString stringWithFormat:@"%@(CNY)",LocalizationKey(@"totalAssets")];
    }else{
        self.headerView.nameLabel.text=[NSString stringWithFormat:@"%@(USD)",LocalizationKey(@"totalAssets")];
    }
   
    if ([[walletModel bg_findAll:nil] count]>0) {
        //有钱包
        if (_placeView) {
            [_placeView removeFromSuperview];
            _placeView=nil;
        }
       
       walletModel*wallet= [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]] lastObject];
        if (!wallet) {
            walletModel*model=[[walletModel bg_findAll:nil] objectAtIndex:0];
            [UserinfoModel shareManage].wallet=model;
            [NSUserDefaultUtil PutNumberDefaults:CurrentWalletID Value:model.bg_id];//存储到本地
        }else{
            [UserinfoModel shareManage].wallet=wallet;
        }
        [self setLeftBarBuutonItem];
        [self setRightBarBuutonItem];
        self.navigationItem.title = [UserinfoModel shareManage].wallet.name;
        [self TotalassetsCalculatedWithWallet:[UserinfoModel shareManage].wallet withtype:0];
        if (self.dataArray.count==0) {
            _balanceView.hidden=NO;
            _mainTableView.scrollEnabled=NO;
            self.headerView.totalLabel.text=@"----";
        }else{
            _balanceView.hidden=YES;
            _mainTableView.scrollEnabled=YES;
            
        }
        
    }else{
         [self.dataArray removeAllObjects];
        _balanceView.hidden=YES;
        //无钱包
        if (!_placeView) {
            _placeView=[HomePlaceholderView instancesViewWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-49-SafeAreaBottomHeight-SafeAreaTopHeight)];
            [_placeView.creatBtn setTitle:LocalizationKey(@"creatWallet") forState:UIControlStateNormal];
            [_placeView.importBtn setTitle:LocalizationKey(@"leadinWallet") forState:UIControlStateNormal];
            [self.view addSubview:_placeView];
            [_placeView.creatBtn addTarget:self action:@selector(walletClick:) forControlEvents:UIControlEventTouchUpInside];
            [_placeView.importBtn addTarget:self action:@selector(walletClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.navigationItem.title = @"";
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]init];
        barBtn.title=@"";
        self.navigationItem.leftBarButtonItem = barBtn;
        self.navigationItem.rightBarButtonItem = barBtn;
    }
     [_mainTableView reloadData];
    if ([[walletModel bg_findAll:nil] count]>0&&!self.timer) {
        self.timer= [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(getWalletMoney) userInfo:nil repeats:YES];//如果当前有钱包定时获取钱包余额数据
        [self.timer fire];
      
    }
    
}

#pragma mark--每30S定时查询钱包余额

-(void)getWalletMoney{
    [self getMarketPrice];
    [self checkIsHaveNewCoin:[UserinfoModel shareManage].wallet];
    [self getNewTokenMoney:[UserinfoModel shareManage].wallet];
}

/**
 刷新代币余额
 */
-(void)getNewTokenMoney:(walletModel*)wallet{
     NSArray*CoinArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id],[NSObject bg_sqlKey:@"collect"],[NSObject bg_sqlValue:@(1)]]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fatherCoin=%@",@"ETH"];
    NSArray *filteredArray = [CoinArray filteredArrayUsingPredicate:predicate];
    
    [filteredArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        coinModel*coin=filteredArray[idx];
        [HomeNetManager coinNameTokenchecksingleAddress:coin.address WithcontractAddress:coin.contractAddress coinName:coin.fatherCoin CompleteHandle:^(id resPonseObj, int code, NSString *coinName) {
            NSDictionary*dic=(NSDictionary*)[resPonseObj[@"data"] firstObject];
            if ([dic[@"address"] isEqualToString:coin.address]) {
                double totalAmount=[dic[@"totalAmount"] doubleValue];
                coin.totalAmount=[NSString stringWithFormat:@"%.8f",totalAmount/(pow(10, [coin.decimals intValue]))];
                //更新余额
                [coin bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:coin.bg_id]]];
                [self.mainTableView reloadData];
            }
           
        }];
        
    }];
 
    
}


/**
 查询是否有新的ETH代币
 */
-(void)checkIsHaveNewCoin:(walletModel*)wallet{
    
   __block coinModel*model;
     NSArray*CoinArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id],[NSObject bg_sqlKey:@"collect"],[NSObject bg_sqlValue:@(1)]]];
    [CoinArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        coinModel*coin=CoinArray[idx];
        if ([coin.brand isEqualToString:@"ETH"]) {
            model=coin;
            *stop=YES;
        }
    }];
    
    if (!model) {
        return;//首页资产未添加ETH
    }
    
    [HomeNetManager checkTokenkDetaileSingleAddress:model.address coinName:model.brand withconfirmations:1 CompleteHandle:^(id resPonseObj, int code) {
        //合约地址
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
                NSArray*modelArray=[TradeModel mj_objectArrayWithKeyValuesArray:[NSDictionary changeType:trades]];
                for (int i=0; i<modelArray.count; i++) {
                    TradeModel*trade=modelArray[i];
                    if (![trade.contractAddress isEqualToString:@""]) {//过滤无contractAddress的trade
                        //判断本地是否已经添加改代币地址
                        NSArray* coinsArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id]]];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@",trade.contractAddress];
                        NSArray *filteredArray = [coinsArray filteredArrayUsingPredicate:predicate];
                        if (filteredArray.count==0) {
                            [self checkRestMoneyForTokenAddress:model WithcontactAddress:trade.contractAddress coinName:model.brand withWallet:wallet];
                        }
                    }
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

/**
 查询某一代币地址列表余额
 @param coin ETH币
 @param contractAddress 合约地址
 @param name 币种名称
 */
-(void)checkRestMoneyForTokenAddress:(coinModel*)coin WithcontactAddress:(NSString*)contractAddress  coinName:(NSString*)name withWallet:(walletModel*)wallet{
    [HomeNetManager coinNameTokenchecksingleAddress:coin.address WithcontractAddress:contractAddress coinName:name CompleteHandle:^(id resPonseObj, int code, NSString *coinName) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSDictionary*dic=(NSDictionary*)[resPonseObj[@"data"] firstObject];
                [self QuerydetaiInformationAddress:coin WithcontactAddress:contractAddress withcoinName:name withtotalAmount:dic[@"totalAmount"]  withWallet:wallet];
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
    
}

/**
 查询合约信息1
 @param contractAddress 合约地址
 */
-(void)checkTokenInformationAddress:(coinModel*)coinmodel WithcontactAddress:(NSString*)contractAddress withcoinName:(NSString*)name  withtotalAmount:(NSString*)totalAmount withWallet:(walletModel*)wallet{
   
    [HomeNetManager checkTokeninformationWithAddress:contractAddress coinName:name CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                coinModel*coin=[[coinModel alloc]init];
                coin.brand=resPonseObj[@"data"][@"symbol"];
                if ([coin.brand isEqualToString:@""]) {
                    coin.brand=@"---";
                }
                coin.englishName=coin.brand;
                coin.address=coinmodel.address;
                coin.contractAddress=resPonseObj[@"data"][@"address"];
                coin.collect=1;
                coin.usdPrice=@"0.00";
                coin.closePrice=@"0.00";
                coin.blockHeight=coin.blockHeight;
                coin.recordType=@"2";
                coin.decimals=resPonseObj[@"data"][@"decimals"];
                coin.own_id=wallet.bg_id;
                coin.totalAmount=[NSString stringWithFormat:@"%.8f",[totalAmount doubleValue]/(pow(10, [coin.decimals intValue]))];
                coin.fatherCoin=name;
                coin.cointype=coinmodel.cointype;
                coin.recordType=coinmodel.recordType;
                coin.blockHeight=coinmodel.blockHeight;
                coin.addtime=[self getNowTimeTimestamp];
                NSArray* coinsArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id]]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@",coin.contractAddress];
                NSArray *filteredArray = [coinsArray filteredArrayUsingPredicate:predicate];
                if (filteredArray.count==0) {
                   [coin bg_save];
                }
                [self getMarketPrice];//刷新表格
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
    
}
/**
 查询合约信息2
 @param contractAddress 合约地址
 */
-(void)QuerydetaiInformationAddress:(coinModel*)coinmodel WithcontactAddress:(NSString*)contractAddress withcoinName:(NSString*)name  withtotalAmount:(NSString*)totalAmount withWallet:(walletModel*)wallet{
    [HomeNetManager QuerydetaiTokeninformationWithAddress:contractAddress CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                coinModel*coin=[[coinModel alloc]init];
                coin.brand=resPonseObj[@"data"][@"name"];
                if ([coin.brand isEqualToString:@""]) {
                    coin.brand=@"---";
                }
                coin.englishName=coin.brand;
                coin.address=coinmodel.address;
                coin.contractAddress=resPonseObj[@"data"][@"contractAddress"];
                coin.collect=1;
                coin.usdPrice=[NSString stringWithFormat:@"%.2f",[resPonseObj[@"data"][@"ustRate"] doubleValue]];
                coin.closePrice=[NSString stringWithFormat:@"%.2f",[resPonseObj[@"data"][@"cnyRate"] doubleValue]];
                coin.imgUrl=resPonseObj[@"data"][@"imgUrl"];
                coin.blockHeight=coin.blockHeight;
                coin.recordType=@"2";
                coin.decimals=resPonseObj[@"data"][@"decimals"];
                coin.own_id=wallet.bg_id;
                coin.totalAmount=[NSString stringWithFormat:@"%.8f",[totalAmount doubleValue]/(pow(10, [coin.decimals intValue]))];
                coin.fatherCoin=name;
                coin.cointype=coinmodel.cointype;
                coin.recordType=coinmodel.recordType;
                coin.blockHeight=coinmodel.blockHeight;
                coin.addtime=[self getNowTimeTimestamp];
                NSArray* coinsArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id]]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@",coin.contractAddress];
                NSArray *filteredArray = [coinsArray filteredArrayUsingPredicate:predicate];
                if (filteredArray.count==0) {
                    [coin bg_save];
                }
                [self getMarketPrice];//刷新表格
            }
            else if ([resPonseObj[@"code"] integerValue] == -1)
            {//后台查不到改币种信息，则去线上查找
               
            [self checkTokenInformationAddress:coinmodel WithcontactAddress:contractAddress withcoinName:name withtotalAmount:totalAmount  withWallet:wallet];
                
            }
            else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
    
}

#pragma mark--钱包添加或删除了资产
-(void)reloadAssetKind{
    [self TotalassetsCalculatedWithWallet:[UserinfoModel shareManage].wallet withtype:0];
    [_mainTableView reloadData];
    [self getMarketPrice];
}

#pragma mark--创建钱包
-(void)walletClick:(UIButton*)sender{
    if (sender.tag==0) {
          [self.navigationController pushViewController:[[CreatWalletController alloc]init] animated:YES];
    }else{
          [self.navigationController pushViewController:[[ImportWalletController alloc]init] animated:YES];
    }
}

#pragma mark--根据币地址查询余额
-(void)checKMoneyAddress:(walletModel*)wallet{
     DNWeak(self);
     self.dataArray=(NSMutableArray*) [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id],[NSObject bg_sqlKey:@"collect"],[NSObject bg_sqlValue:@(1)]]];
    
    //遍历数组
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        coinModel*coinmodel=self.dataArray[idx];
        [self.marketArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            marketModel*marketmodel=self.marketArray[idx];
            if ([marketmodel.name isEqualToString:coinmodel.brand]) {
                coinmodel.closePrice=marketmodel.close_rmb;
                coinmodel.usdPrice=marketmodel.close;
                //更新
                [coinmodel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:coinmodel.bg_id]]];
                [weakself.mainTableView reloadData];
                NSString*coinname;
                if ([coinmodel.brand isEqualToString:@"USDT"]) {
                    coinname=@"OMNI";
                }else{
                    coinname=coinmodel.brand ;
                }
                [HomeNetManager coinNamechecksingleAddress:coinmodel.address coinName:coinname CompleteHandle:^(id resPonseObj, int code,NSString*coinName) {//查询地址余额
                    if (code) {
                        if ([resPonseObj[@"code"] integerValue] == 0) {
                            if (![resPonseObj[@"data"] isKindOfClass:[NSArray class]]) {
                                [self.view makeToast:LocalizationKey(@"responseErro") duration:1.5 position:CSToastPositionCenter];
                                return ;
                            }
                            NSDictionary*dic=[resPonseObj[@"data"] firstObject];
                           //科学计数法转化成字符串
                            NSString*address=dic[@"address"];
                            if ([address isEqualToString:coinmodel.address]&&[[coinName uppercaseString] isEqualToString:coinname]) {
                                if ([coinmodel.recordType intValue]==1) {
                                    //ETH类
                                    coinmodel.totalAmount=[NSString stringWithFormat:@"%.8f",[dic[@"totalAmount"] doubleValue]/pow(10, 18)];
                                }else{
                                    //BTC类
                                    coinmodel.totalAmount=[NSString stringWithFormat:@"%.8f",[dic[@"totalAmount"] doubleValue]/pow(10, 8)];
                                }
                               //更新数据
                                [coinmodel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:coinmodel.bg_id]]];
                                 [self TotalassetsCalculatedWithWallet:wallet withtype:0];
                            }
                            [weakself.mainTableView reloadData];
                            
                        }else{
                            [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                        }
                    }else{
                      
                    }
                }];
            }
       
        }];
    }];
}

#pragma mark--切换钱包
-(void)reloadWallet{
    self.navigationItem.title=[UserinfoModel shareManage].wallet.name;
    [self TotalassetsCalculatedWithWallet:[UserinfoModel shareManage].wallet withtype:0];
    if (self.dataArray.count==0) {
        _balanceView.hidden=NO;
        _mainTableView.scrollEnabled=NO;
        if ([[NSUserDefaultUtil GetDefaults:HIDEMONEY] boolValue]) {
            self.headerView.totalLabel.text=@"****";
        }else{
           self.headerView.totalLabel.text=@"----";;
        }
        
    }else{
        _balanceView.hidden=YES;
        _mainTableView.scrollEnabled=YES;
    }
    [_mainTableView reloadData];
    [self getMarketPrice];
    [self getWalletMoney];//刷新代币
  
}

#pragma mark--单击进入钱包详情
-(void)SingleTap{
    walletDetailController*detailVC=[[walletDetailController alloc]init];
    detailVC.wallet=[UserinfoModel shareManage].wallet;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark--隐藏或展示资金
static void extracted(WalletController *object) {
    [object TotalassetsCalculatedWithWallet:[UserinfoModel shareManage].wallet withtype:0];
}

-(void)touchEvent:(UIButton*)sender{
    sender.selected=!sender.selected;
    
    if (!sender.selected) {
        [NSUserDefaultUtil PutBoolDefaults:HIDEMONEY Value:NO];
        [self TotalassetsCalculatedWithWallet:[UserinfoModel shareManage].wallet withtype:0];

    }else{
        [NSUserDefaultUtil PutBoolDefaults:HIDEMONEY Value:YES];
        extracted(self);
    }
       [_mainTableView reloadData];
}
#pragma mark--计算当前偏移位置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>=145) {
        [self TotalassetsCalculatedWithWallet:[UserinfoModel shareManage].wallet withtype:1];
    }else{
        self.navigationItem.title=[UserinfoModel shareManage].wallet.name;
    }
}

#pragma mark--下拉刷新
-(void)refreshHeaderAction{
     DNWeak(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.mainTableView.mj_header endRefreshing];
    });
     [self getWalletMoney];//刷新余额
}
#pragma mark -- didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- setControlForSuper
- (void)setControlForSuper{
    
}

#pragma mark -- addConstrainsForSuper
- (void)addConstrainsForSuper{
   
    
}

#pragma mark -- target Methods

- (void)setLeftBarBuutonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"首页01")
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(leftItemClick)];
}
#pragma mark 左侧展开菜单按钮
- (void)leftItemClick
{
    CurrencyExchangeViewController*manageVC=[[CurrencyExchangeViewController alloc]init];
    [self.navigationController pushViewController:manageVC animated:YES];
}
#pragma mark 右侧添加资产按钮
- (void)setRightBarBuutonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"首页02")
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(rightItemClick)];
}
#pragma mark 右侧菜单按钮
- (void)rightItemClick
{ 
    if (!self.menu) {
        self.menu = [[LeftMenuViewController alloc]initWithNibName:@"LeftMenuViewController" bundle:nil];
        CGRect frame = self.menu.view.frame;
        frame.origin.x = - CGRectGetWidth(self.view.frame);
        self.menu.view.frame = CGRectMake( 2*CGRectGetWidth(self.view.frame), 0, SCREEN_WIDTH , SCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:self.menu.view];
        DNWeak(self);
        self.menu.getBackBlock = ^(NSString *text) {
            if ([text isEqualToString:LocalizationKey(@"ShareApp")]) {
              //分享App
                [weakself shareForSystem];
                return ;
            }
            NSString*stringVC=[weakself transferClassNameFromtitle:text];
            UIViewController*controller=[weakself getActivityViewController:stringVC];
            if ([controller isKindOfClass:[MMScanViewController class]]) {
                __block coinModel*currentcoin;
                MMScanViewController *scanVC = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
                    if (error) {
                    } else {
                       
                        NSArray *array = [result componentsSeparatedByString:@":"];
                        NSArray*coins=(NSMutableArray*) [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id],[NSObject bg_sqlKey:@"collect"],[NSObject bg_sqlValue:@(1)]]];
                        __block BOOL _isContinue=NO;
                        [coins enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            coinModel*coin=coins[idx];
                            if ([[coin.englishName uppercaseString] isEqualToString:[[array firstObject] uppercaseString]]) {
                                currentcoin=coin;
                                currentcoin.address=array[1];
                                _isContinue=YES;
                                *stop=YES;
                            }
                        }];
                        if (_isContinue) {//扫描后构建币种
                            TransferController*transVC=[[TransferController alloc]init];
                            transVC.coin=currentcoin;
                            transVC.popType=1;
                            transVC.popCount=[array lastObject];
                            [weakself.navigationController pushViewController:transVC animated:YES];
                        }else{
                            [weakself.view makeToast:LocalizationKey(@"pleaseAddTheAsset") duration:1.5 position:CSToastPositionCenter];
                            return ;
                        }
                    }
                }];
                scanVC.hidesBottomBarWhenPushed=YES;
                [weakself.navigationController pushViewController:scanVC animated:YES];
                
            }else if ([controller isKindOfClass:[SettingDetailController class]])
            {
                SettingDetailController*settingVC=(SettingDetailController*)controller;
                settingVC.baseStr=text;
                [weakself.navigationController pushViewController:settingVC animated:YES];
                
            }
            
            else{
              
                [weakself.navigationController pushViewController:controller animated:YES];
                
                
            }
        };
    }
    [self.menu showFromLeft];
}

/**
 系统自带的分享
 */
-(void)shareForSystem{
    
    UIImage *shareImage = UIIMAGE(@"BipayIcon");
    NSURL *url = [NSURL URLWithString:@"https://www.bipay.io/appDownload.html"];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:url,shareImage, nil];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSLog(@"%@",activityType);
        if (completed) {
            NSLog(@"分享成功");
        } else {
            NSLog(@"分享失败");
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    vc.completionWithItemsHandler = myBlock;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark -tablviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    coinModel*coin=self.dataArray[indexPath.section];
    HomeViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"HomeViewCell" forIndexPath:indexPath];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    [cell configModel:coin];
    
    return cell;
}
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (iPhone6_Plus) {
         return 90;
     }
     return 80;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    
  return 11;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;//设置尾视图高度
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  return [[UIView alloc]init];
}
- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    return [[UIView alloc]init];
}
/**
 添加资产
 */
-(void)addAsset{
    AddAssetsController*assets=[[AddAssetsController alloc]init];
    assets.wallet=[UserinfoModel shareManage].wallet;
    [self.navigationController pushViewController:assets animated:YES];
}
#pragma mark -- 点击进入交易记录
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KlineViewController*klineVC=[[KlineViewController alloc]init];
    coinModel*coin=self.dataArray[indexPath.section];
    klineVC.coinModel=coin;
    [self.navigationController pushViewController:klineVC animated:YES];
}


#pragma mark--火币行情数据
/**
 火币数据
 */
-(void)getMarketPrice{
    
    [RequestManager postRequestWithURLPath:@"http://www.qkljw.com/app/Kline/get_currency_data" withParamer:[[NSMutableDictionary alloc]init] completionHandler:^(id responseObject) {
        self.marketArray = [marketModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSArray *Namearray=[UserinfoModel shareManage].Namearray;
        [Namearray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString*coinName=Namearray[idx];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",coinName];
            NSArray*filteredArray = [self.marketArray  filteredArrayUsingPredicate:predicate];
            if (filteredArray.count==0) {
                NSLog(@"火币钱包不含次币种-%@",coinName);
                if ([coinName isEqualToString:@"USDT"]) {
                    marketModel*USDTmodel=[[marketModel alloc]init];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"ETH"];
                    NSArray *filteredArray = [self.marketArray  filteredArrayUsingPredicate:predicate];
                    marketModel*ethcoin=[filteredArray firstObject];
                    USDTmodel.name=@"USDT";
                    USDTmodel.close_rmb=[NSString stringWithFormat:@"%.2f",[ethcoin.close_rmb doubleValue]/[ethcoin.close doubleValue]];
                    USDTmodel.close=@"1.00";
                    [self.marketArray addObject:USDTmodel];
                }else{
                    marketModel*otherModel=[[marketModel alloc]init];
                    otherModel.name=coinName;
                    otherModel.close_rmb=@"0.00";
                    otherModel.close=@"0.00";
                    [self.marketArray addObject:otherModel];
                }
            }
        }];
       
        [self checKMoneyAddress:[UserinfoModel shareManage].wallet];//查询币种地址余额
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        
    }];
    
}
#pragma mark--计算总资产
-(void)TotalassetsCalculatedWithWallet:(walletModel*)wallet withtype:(int)type{
 
    self.dataArray=(NSMutableArray*)[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id],[NSObject bg_sqlKey:@"collect"],[NSObject bg_sqlValue:@(1)]]];
    __block  double totalMoney=0;
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        coinModel*coin=self.dataArray[idx];
            if ([[NSUserDefaultUtil  GetDefaults:MoneyChange] isEqualToString:@"CNY"]) {
                totalMoney=totalMoney+[coin.closePrice doubleValue]*[coin.totalAmount doubleValue];
                
            }else{
                totalMoney=totalMoney+[coin.usdPrice doubleValue]*[coin.totalAmount doubleValue];
        }
    }];
    if ([[NSUserDefaultUtil GetDefaults:HIDEMONEY] boolValue]) {
        self.headerView.totalLabel.text=@"****";
    }else{
        
        self.headerView.totalLabel.text=[NSString stringWithFormat:@"%.2f",totalMoney];
        if (self.dataArray.count==0) {
            self.headerView.totalLabel.text=@"----";
        }
    }
    if (type==1) {
        if ([[NSUserDefaultUtil  GetDefaults:MoneyChange] isEqualToString:@"CNY"]) {
        self.navigationItem.title=[NSString stringWithFormat:@"%@ %@CNY",LocalizationKey(@"totalAssets"),self.headerView.totalLabel.text];
        }else{
           self.navigationItem.title=[NSString stringWithFormat:@"%@ %@ USD",LocalizationKey(@"totalAssets"),self.headerView.totalLabel.text];
        }
    }
}

/**
 首页币种按照添加时间顺序排列
-(NSMutableArray*)sortwithArray:(NSMutableArray*)dataArray{
    
    NSArray *sortArray = [dataArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                          {
                              coinModel *Model1 = obj1;
                              coinModel *Model2 = obj2;
                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                              [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                              NSDate *date1= [dateFormatter dateFromString:Model1.addtime];
                              NSDate *date2= [dateFormatter dateFromString:Model2.addtime];
                              if (date1 == [date1 earlierDate: date2]) { //不使用intValue比较无效
                                  return NSOrderedAscending;//降序
                              }else if (date1 == [date1 laterDate: date2]) {
                                  return NSOrderedDescending;//
                              }
                              else{
                                  return NSOrderedSame;//相等
                              }
                          }];
    return [NSMutableArray arrayWithArray:dataArray];
   
}
 */
#pragma mark -- NetWork Methods



@end
