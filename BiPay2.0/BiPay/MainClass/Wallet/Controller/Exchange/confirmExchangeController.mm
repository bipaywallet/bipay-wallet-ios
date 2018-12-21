//
//  confirmExchangeController.m
//  BiPay
//
//  Created by sunliang on 2018/10/24.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "confirmExchangeController.h"
#import "changeHistoryController.h"
#import "HBAlertPasswordView.h"
#import "HomeNetManager.h"
#import "TransferModel.h"
#import "AESCrypt.h"
#import "TransferSuccessController.h"
#import "TradeModel.h"
#import "confirmTransferView.h"
#import "changeModel.h"
@interface confirmExchangeController ()<HBAlertPasswordViewDelegate,UIGestureRecognizerDelegate>
{
    NSString*_SignatureStr;
    NSString* _nonce;
    NSString* _gasprice;
    double _totalAmount;//总余额
    double _totalTokenAmount;//代币总余额
    NSString*_changellyAdress;
    confirmTransferView*_boardView;
    NSString*_txid;
}
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAddress;
@property (weak, nonatomic) IBOutlet UILabel *fromCoinValue;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toAddress;
@property (weak, nonatomic) IBOutlet UILabel *toCoinValue;
@property (weak, nonatomic) IBOutlet UIImageView *fromImageV;
@property (weak, nonatomic) IBOutlet UILabel *fromiconLabel;
@property (weak, nonatomic) IBOutlet UIImageView *toiconImageV;
@property (weak, nonatomic) IBOutlet UILabel *toiconLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property(nonatomic,strong)NSMutableArray*contentArray;
@property(nonatomic,strong)NSArray*utxoArray;//记录未花交易
@property (weak, nonatomic) IBOutlet UILabel *FeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *speed1;
@property (weak, nonatomic) IBOutlet UILabel *speed2;
@property (weak, nonatomic) IBOutlet UILabel *speed3;
@property (weak, nonatomic) IBOutlet UIButton *confirmChange;
@property (nonatomic, copy) NSString*decryptStr;

@end

@implementation confirmExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleView];
    self.view.backgroundColor=ViewBackColor;
    self.bgSrollView.backgroundColor =ViewBackColor;
    self.FeeNameLabel.text=LocalizationKey(@"fee");
    self.speed1.text = LocalizationKey(@"slow");
    self.speed2.text = LocalizationKey(@"normal");
    self.speed3.text = LocalizationKey(@"fast");
    [self.confirmChange setTitle:LocalizationKey(@"Confirmationexchange") forState:UIControlStateNormal];
    self.contentArray=[[NSMutableArray alloc]init];
    self.fromLabel.text=self.fromCoinModel.brand;
    self.fromAddress.text=self.fromCoinModel.address;
    self.fromCoinValue.text=[NSString stringWithFormat:@"%.8f %@",[self.fromValue doubleValue],self.fromCoinModel.brand];
    self.toLabel.text=self.toCoinModel.brand;
    self.toAddress.text=self.toCoinModel.address;
    self.toCoinValue.text=[NSString stringWithFormat:@"%.8f %@",[self.toValue doubleValue],self.toCoinModel.brand];
    self.fromImageV.image=UIIMAGE(self.fromCoinModel.brand);
    self.fromiconLabel.text=[NSString stringWithFormat:@"%.8f",[self.fromValue doubleValue]];
    self.toiconImageV.image=UIIMAGE(self.toCoinModel.brand);
    self.toiconLabel.text=[NSString stringWithFormat:@"%.8f",[self.toValue doubleValue]];
    self.rateLabel.text=[self.rate substringFromIndex:2];
    CGRect rect = self.Bgview.frame;
    rect.size.width = kWindowW;
    self.Bgview.frame = rect;
    [self.bgSrollView addSubview:self.Bgview];
    self.bgSrollView.contentSize = self.Bgview.frame.size;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self configInformationForExchange];
  
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;      // 手势有效设置为YES  无效为NO
        self.navigationController.interactivePopGestureRecognizer.delegate = self;    // 手势的代理设置为self
    }
}

-(void)settitleView{
    // 创建一个富文本
    UILabel*titlelabel=[[UILabel alloc]init];
    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",self.fromCoinModel.brand]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"changeRow"];
    attch.bounds = CGRectMake(0, 0, 29/1.2,14/1.2);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string]; //在文字后面添加图片
    NSAttributedString*str1=[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",self.toCoinModel.brand]];
    [attri appendAttributedString:str1];
    titlelabel.attributedText = attri;
    titlelabel.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titlelabel;
}


#pragma mark--确认兑换

- (IBAction)confirmBtn:(UIButton *)sender {
   
    [self.view endEditing:YES];

    if ([NSString stringIsNull:self.fromiconLabel.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseInputTransfer") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([self.fromiconLabel.text doubleValue]<=0) {
        [self.view makeToast:LocalizationKey(@"Feelimit") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    
    if ([NSString stringIsNull:[self deleteStringWithStr:self.feeLabel.text]]) {
        [self.view makeToast:LocalizationKey(@"pleaseSelectFee") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    
    if ([[self deleteStringWithStr:self.feeLabel.text] doubleValue]<=0) {
        [self.view makeToast:LocalizationKey(@"shouxuFeelimit") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    
    if (!_boardView) {
        _boardView = [[NSBundle mainBundle] loadNibNamed:@"confirmTransferView" owner:nil options:nil].firstObject;
        _boardView.frame=[UIScreen mainScreen].bounds;
    }
    CGAffineTransform translates = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    _boardView.boardView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,0,_boardView.boardView.height);
    _boardView.amountlabel.text=[NSString stringWithFormat:@"%.8f %@",[self.fromiconLabel.text doubleValue],self.fromCoinModel.brand];
    _boardView.addressLabel.text=self.toCoinModel.address;
    _boardView.feeLabel.text=self.feeLabel.text;
    _boardView.confirmTitle.text=LocalizationKey(@"Confirmationexchange");
    _boardView.remarklabel.hidden=YES;
    _boardView.tipsLabel.hidden=YES;
    _boardView.heghtConstant.constant=230;
    [_boardView.confirmbtn addTarget:self action:@selector(NextStep) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_boardView.boardView.transform = translates;
        
    } completion:^(BOOL finished) {
        
    }];
    [UIApplication.sharedApplication.keyWindow addSubview:_boardView];
    
}

/**
 显示转账信息
 */
-(void)NextStep
{
    [_boardView hideView];
    [self showAlertView];
}

/**
 显示密码输入框
 */

-(void)showAlertView{
    
    //密码框的View
    HBAlertPasswordView *alertPasswordView = [[HBAlertPasswordView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
    alertPasswordView.delegate = self;
    [APPLICATION.window addSubview:alertPasswordView];
}


/**
 地址验证成功，确定转账
 */
-(void)validateAddressSuccess{
    if (self.fromCoinModel.fatherCoin) {//代币
        if ([self.fromCoinModel.fatherCoin isEqualToString:@"ETH"]) {
            
            if (_totalTokenAmount <[self.fromiconLabel.text doubleValue]) {
                [self.view makeToast:LocalizationKey(@"balancelack") duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            if (_totalAmount <[[self deleteStringWithStr:self.feeLabel.text] doubleValue]) {
                [self.view makeToast:LocalizationKey(@"shouxuFeebuzu") duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            
            
        }else if ([self.fromCoinModel.fatherCoin isEqualToString:@"BTC"])//USDT
        {
            if (_totalTokenAmount <[self.fromiconLabel.text doubleValue]) {
                [self.view makeToast:LocalizationKey(@"balancelack") duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            if (_totalAmount <[[self deleteStringWithStr:self.feeLabel.text] doubleValue]+0.00000546) {
                [self.view makeToast:LocalizationKey(@"shouxuFeebuzu") duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            
        }
        
        else{
            
            
        }
    }else{//非代币
        
        if (_totalAmount <[self.fromiconLabel.text doubleValue]+[[self deleteStringWithStr:self.feeLabel.text] doubleValue]) {
            [self.view makeToast:LocalizationKey(@"balancelack") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        NSArray*transferArray= [TransferModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.fromCoinModel.bg_id]]];
        [transferArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TransferModel*transfer=transferArray[idx];
            NSInteger timeDistance= [[NSDate date] timeIntervalSinceDate:[ToolUtil getDatewithString:transfer.creatTime]];//比较时间
            if (timeDistance>=30*60) {//30分钟
                [TransferModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:transfer.bg_id]]];
            }
        }];
        
        //判断未花交易
        if ([self.fromCoinModel.recordType intValue]==0) {//BTC、DVC，LTC,DOGE等
            __block BOOL _isContinue=NO;
            NSArray*restArray= [TransferModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.fromCoinModel.bg_id]]];
            [self.contentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TransferModel*contentModel=self.contentArray[idx];
                NSLog(@"未花费交易---%@",contentModel.txid);
                [restArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TransferModel*restModel=restArray[idx];
                    NSLog(@"本地存的---%@",restModel.txid);
                    if ([contentModel.txid isEqualToString:restModel.txid]) {
                        _isContinue=YES;
                        *stop=YES;
                    }
                }];
            }];
            if (_isContinue) {
                
                [self.view makeToast:LocalizationKey(@"dealNoConfirmed")  duration:1.5 position:CSToastPositionCenter];
                return;
            }
            
        }else if ([self.fromCoinModel.recordType intValue]==1){ //ETH等
            NSArray*restArray= [TransferModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.fromCoinModel.bg_id]]];
            if (restArray.count>0) {
                TransferModel*transferModel=[restArray lastObject];
                if ([transferModel.nonce isEqualToString:_nonce]) {
                    [self.view makeToast:LocalizationKey(@"dealNoConfirmed") duration:1.5 position:CSToastPositionCenter];
                    return;
                }
            }
            
        }else{
            
            
        }
    }
    
    [self lastToexhangeWithAddrss];
    
}







/**
 获取付款地址
 */
-(void)generateAddress:(NSString*)from withto:(NSString*)to withAddress:(NSString*)address{
    [SVProgressHUD show];
    // 请求参数字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"Bipay" forKey:@"id"];
    [params setValue:@"2.0" forKey:@"jsonrpc"];
    [params setValue:@"createTransaction" forKey:@"method"];
    [params setValue:@{@"from":from,@"to":to,@"address":address,@"amount":self.fromiconLabel.text} forKey:@"params"];
    
    [RequestManager postRequestWithURLPath:ChangellyHOST withParamer:params completionHandler:^(id responseObject) {
        [SVProgressHUD dismiss];
        self->_changellyAdress=responseObject[@"result"][@"payinAddress"];
        self->_txid=responseObject[@"result"][@"id"];
        [self validateAddress:self->_changellyAdress withFromCoin:self.fromCoinModel.brand];
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        [SVProgressHUD dismiss];
        [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
    }];
    
}

/**
 获取转账信息
 */

-(void)configInformationForExchange{
    if (self.fromCoinModel.fatherCoin) {
        [self getTokenData];//余额
        [self ServiceChargeToken];//手续费
    }else{
        [self getData];
        [self ServiceCharge];//查询交易手续费
    }
   
}
/**
 选择手续费
 */
- (IBAction)valuechange:(UISlider *)sender {
    
    if (self.fromCoinModel.fatherCoin) {//代币
        if ([self.fromCoinModel.fatherCoin isEqualToString:@"ETH"]) {
            self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",sender.value,self.fromCoinModel.fatherCoin];
        }
        else  if ([self.fromCoinModel.fatherCoin isEqualToString:@"BTC"]) {
            //USDT
            self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@/KB",sender.value,self.fromCoinModel.fatherCoin];
        }
        else{
            
            
        }
        
    }else{//非代币
        if ([self.fromCoinModel.recordType intValue]==0) {
            //BTC,LTC,DOGE,BCH等
           self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@/KB",sender.value,self.fromCoinModel.brand];
        }else{
            //ETH等
            self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",sender.value,self.fromCoinModel.brand];
            
        }
    }
    
    
}


/**
 查询地址列表余额(代币)
 */
-(void)getTokenData{
    __weak typeof(self) weakSelf=self;
    if ([self.fromCoinModel.fatherCoin isEqualToString:@"ETH"]) {
        [HomeNetManager coinNameTokenchecksingleAddress:self.fromCoinModel.address WithcontractAddress:self.fromCoinModel.contractAddress coinName:self.fromCoinModel.fatherCoin CompleteHandle:^(id resPonseObj, int code, NSString *coinName) {
            if (code) {
                __strong typeof(weakSelf) strongSelf=weakSelf;
                if ([resPonseObj[@"code"] integerValue] == 0) {
                    NSDictionary*dic=(NSDictionary*)[resPonseObj[@"data"] firstObject];
                    strongSelf->_totalTokenAmount=[dic[@"totalAmount"] doubleValue]/(pow(10, [self.fromCoinModel.decimals intValue]));
                    [self TokenGetRestMoney];
                    
                }else{
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
            
        }];
    }else if ([self.fromCoinModel.fatherCoin isEqualToString:@"BTC"]){//USDT类
        
        [HomeNetManager checksingleAddress:self.fromCoinModel.address coinName:@"OMNI" CompleteHandle:^(id resPonseObj, int code) {
           // [SVProgressHUD dismiss];
            if (code) {
                __strong typeof(weakSelf) strongSelf=weakSelf;
                if ([resPonseObj[@"code"] integerValue] == 0) {
                    NSDictionary*dic=[resPonseObj[@"data"] firstObject];
                    strongSelf->_totalTokenAmount=[dic[@"totalAmount"] doubleValue]/pow(10, 8);
                    
                    [self TokenGetRestMoney];
                    
                }else{
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
            
        }];
        
        
        
    }else{
        
    }
    
    
}
/**
 查询交易手续费（代币）
 */
-(void)ServiceChargeToken{
    [HomeNetManager cheakservicechargewithcoinName:self.fromCoinModel.fatherCoin  CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                if ([self.fromCoinModel.fatherCoin isEqualToString:@"ETH"]){
                    self->_gasprice=resPonseObj[@"data"];
                    self.slider.maximumValue=[self->_gasprice doubleValue]*10*60000/pow(10, 9);
                    self.slider.minimumValue=[self->_gasprice doubleValue]*1*60000/pow(10, 9);
                    self.slider.value=[self->_gasprice doubleValue]*60000/pow(10, 9)*2;
                    self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",[self->_gasprice doubleValue]*60000/pow(10, 9)*2,self.fromCoinModel.fatherCoin];
                }
                else if ([self.fromCoinModel.fatherCoin isEqualToString:@"BTC"]){
                    //USDT
                    self.slider.maximumValue=[resPonseObj[@"data"] doubleValue]*10;
                    self.slider.minimumValue=[resPonseObj[@"data"] doubleValue]*1;
                    self.slider.value=[resPonseObj[@"data"] doubleValue]*2;
                    self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@/KB",[resPonseObj[@"data"] doubleValue]*2,self.fromCoinModel.fatherCoin];
                }
                else{
                    
                    
                }
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
//得到父币种的余额，判断是否够手续费
-(void)TokenGetRestMoney{
   // [SVProgressHUD show];
    [HomeNetManager checksingleAddress:self.fromCoinModel.address coinName:self.fromCoinModel.fatherCoin  CompleteHandle:^(id resPonseObj, int code) {
       // [SVProgressHUD dismiss];
        __weak typeof(self) weakSelf=self;
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                __strong typeof(weakSelf) strongSelf=weakSelf;
                NSDictionary*dic=[resPonseObj[@"data"] firstObject];
                if([self.fromCoinModel.fatherCoin isEqualToString:@"ETH"]){//ETH
                    strongSelf->_nonce=dic[@"nonce"];
                    strongSelf->_totalAmount=[dic[@"totalAmount"] doubleValue]/pow(10, 18);
                    
                }else if ([self.fromCoinModel.fatherCoin isEqualToString:@"BTC"]){
                    //USDT
                    NSArray*utxoArray=dic[@"utxo"];
                    [self.contentArray removeAllObjects];
                    for (int i=0; i<utxoArray.count; i++) {
                        TransferModel*transfer=[TransferModel mj_objectWithKeyValues:utxoArray[i]];
                        transfer.amount=[NSString stringWithFormat:@"%.8f",[transfer.amount doubleValue]/pow(10, 8)];
                        [self.contentArray addObject:transfer];
                    }
                    
                    strongSelf->_totalAmount=[dic[@"totalAmount"] doubleValue]/pow(10, 8);
                    
                }
                else{
                    
                    
                    
                    
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
 查询地址列表余额(非代币)
 */
-(void)getData{
   // [SVProgressHUD show];
    __weak typeof(self) weakSelf=self;
    [HomeNetManager checksingleAddress:self.fromCoinModel.address coinName:self.fromCoinModel.brand  CompleteHandle:^(id resPonseObj, int code) {
       // [SVProgressHUD dismiss];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                __strong typeof(weakSelf) strongSelf=weakSelf;
                NSDictionary*dic=[resPonseObj[@"data"] firstObject];
                if ([self.fromCoinModel.recordType intValue]==0) {//utxo，BTC等
                    NSArray*utxoArray=dic[@"utxo"];
                    for (int i=0; i<utxoArray.count; i++) {
                        TransferModel*transfer=[TransferModel mj_objectWithKeyValues:utxoArray[i]];
                        transfer.amount=[NSString stringWithFormat:@"%.8f",[transfer.amount doubleValue]/pow(10, 8)];
                        [self.contentArray addObject:transfer];
                    }
                    strongSelf->_totalAmount=[dic[@"totalAmount"] doubleValue]/pow(10, 8) ;
                }else if([self.fromCoinModel.recordType intValue]==1){//ETH等
                    strongSelf->_nonce=dic[@"nonce"];
                    strongSelf->_totalAmount=[dic[@"totalAmount"] doubleValue]/pow(10, 18);
                }else{
                    
                }
                NSLog(@"--地址余额--%@",resPonseObj);
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
}
/**
 查询交易手续费（非代币）
 */
-(void)ServiceCharge{
    [HomeNetManager cheakservicechargewithcoinName:self.fromCoinModel.brand  CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
           
                if ([self.fromCoinModel.recordType intValue]==1){
                    //ETH
                    self->_gasprice=resPonseObj[@"data"];
                    self.slider.maximumValue=[self->_gasprice doubleValue]*10*21000/pow(10, 9);
                    self.slider.minimumValue=[self->_gasprice doubleValue]*1*21000/pow(10, 9);
                    self.slider.value=[self->_gasprice doubleValue]*21000/pow(10, 9)*2;
                    self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",[self->_gasprice doubleValue]*21000/pow(10, 9)*2,self.fromCoinModel.brand];
                }
                else if ([self.fromCoinModel.recordType intValue]==0){
                    //BTC,LTC,DOGE,BCH等
                    self.slider.maximumValue=[resPonseObj[@"data"] doubleValue]*10;
                    self.slider.minimumValue=[resPonseObj[@"data"] doubleValue]*1;
                    self.slider.value=[resPonseObj[@"data"] doubleValue]*2;
                    self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@/KB",[resPonseObj[@"data"] doubleValue]*2,self.fromCoinModel.brand];
                }
                else{
                    
                    
                }
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
#pragma mark - <HBAlertPasswordViewDelegate>
- (void)sureActionWithAlertPasswordView:(HBAlertPasswordView *)alertPasswordView password:(NSString *)password {
    [alertPasswordView removeFromSuperview];
    NSString*decryptStr=[AESCrypt decrypt:[UserinfoModel shareManage].wallet.password password:password];;
    if (!decryptStr) {
        [self.view makeToast:LocalizationKey(@"pwdErro") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    self.decryptStr =decryptStr;
    [self generateAddress:self.fromCoinModel.brand withto:self.toCoinModel.brand withAddress:self.toCoinModel.address];//获取兑换地址
}


/**
 输入密码正确，获取转账地址后开始转账
 */
-(void)lastToexhangeWithAddrss{
    if (self.fromCoinModel.fatherCoin) {//代币
        if ([self.fromCoinModel.fatherCoin isEqualToString:@"ETH"]) {
            double val = pow(10, [self.fromCoinModel.decimals intValue]);//转出量
            double fee = pow(10, 18);//手续费,gasprice
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:self.fromCoinModel.address,@"from",_changellyAdress,@"to",[NSString stringWithFormat:@"%.0f",[self.fromiconLabel.text doubleValue]*val],@"value",_nonce,@"nonce",[NSString stringWithFormat:@"%.0f",[[self deleteStringWithStr:self.feeLabel.text] doubleValue]*fee/60000],@"gasprice",@"60000",@"gas",self.fromCoinModel.contractAddress,@"contractAddr",nil];
            NSString*jsonStr=[self convertToJsonData:dic];
            NSLog(@"-构建的字典-%@",dic);
            const char *Constjson = [jsonStr UTF8String];
            char *Transaction= NewTransaction(Constjson, self.fromCoinModel.cointype);
            const  char*privKey=GetCoinMasterKey([self.decryptStr UTF8String], self.fromCoinModel.cointype);
            const  char*getSubKey=GetSubPrivKey(privKey, 2^31);
            const  char*wifprivKey=GetExportedPrivKey(getSubKey, self.fromCoinModel.cointype,self.fromCoinModel.Priveprefix);
            char*SignatureStr=SignSignature(Transaction, wifprivKey, self.fromCoinModel.cointype,[@"" UTF8String]);
            NSString* lastString = [[NSString alloc] initWithUTF8String:SignatureStr];
            NSLog(@"签名字符串--%@",lastString);
            [self postTrade: lastString];//发送交易
            
        }else if ([self.fromCoinModel.fatherCoin isEqualToString:@"BTC"]){
            //发送USDT
            NSArray*modelArray=[self USDTcofigModel:self.contentArray withAmount:@"0.00000546"];
            if (modelArray.count==0) {
                [self.view makeToast:LocalizationKey(@"shouxuFeebuzu") duration:1.5 position:CSToastPositionCenter];
                return;
            }
            self.utxoArray=modelArray;//记录未花交易数组
            NSMutableArray*inputArray=[[NSMutableArray alloc]init];
            NSMutableArray*outputArray=[[NSMutableArray alloc]init];
            __block double totalAmount=0;
            int outputs_count;
            [modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TransferModel*model=modelArray[idx];
                NSDictionary *modelDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[model.indexNo intValue]],@"prev_position",model.txid,@"prev_tx_hash",nil];
                [inputArray addObject:modelDic];
                totalAmount+=[model.amount doubleValue];
                
            }];
            NSString* inputAmount=@"0.00000546";
            double restAmount=totalAmount-[inputAmount doubleValue]-[[self deleteStringWithStr:self.feeLabel.text] doubleValue];
            if (restAmount<0) {
                [self.view makeToast:LocalizationKey(@"computationalanomaly") duration:1.5 position:CSToastPositionCenter];
                return ;
            }else if (restAmount==0)
            {
                outputs_count=1;
                NSDictionary *outDic=[NSDictionary dictionaryWithObjectsAndKeys:_changellyAdress,@"address",@"0.00000546",@"value",nil];
                [outputArray addObject:outDic];
            }else{
                outputs_count=2;
                NSDictionary *outDic1=[NSDictionary dictionaryWithObjectsAndKeys:_changellyAdress,@"address",@"0.00000546",@"value",nil];
                NSDictionary *outDic2=[NSDictionary dictionaryWithObjectsAndKeys:self.fromCoinModel.address,@"address",[NSString stringWithFormat:@"%.8f",totalAmount-[@"0.00000546" doubleValue]-[[self deleteStringWithStr:self.feeLabel.text] doubleValue]],@"value",nil];
                [outputArray addObject:outDic1];
                [outputArray addObject:outDic2];
            }
            NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:self.fromiconLabel.text];
            NSDecimalNumber *decimalNumber2=[NSDecimalNumber decimalNumberWithString:@"100000000"];
            NSDecimalNumber *result = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2];
            NSArray*usdtArray=[NSArray arrayWithObjects:[NSNumber numberWithInt:31],result, nil];
            
            //构建字典
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)modelArray.count],@"inputs_count",inputArray,@"inputs",[NSNumber numberWithInt:outputs_count],@"outputs_count",outputArray,@"outputs",usdtArray,@"usdt",nil];
            NSString*jsonStr=[self convertToJsonData:dic];
            NSLog(@"-USDT构建的字典-%@",dic);
            const char *Constjson = [jsonStr UTF8String]; //用USDT的cointype构建交易
            char *Transaction= NewTransaction(Constjson, 207);
            const  char*privKey=GetCoinMasterKey([self.decryptStr  UTF8String], self.fromCoinModel.cointype);
            const  char*getSubKey=GetSubPrivKey(privKey, 2^31);
            const  char*wifprivKey=GetExportedPrivKey(getSubKey, self.fromCoinModel.cointype,self.fromCoinModel.Priveprefix);
            NSString* wifString = [[NSString alloc] initWithUTF8String:wifprivKey];
            for (int i = 0; i<modelArray.count-1; i++) {
                wifString=[NSString stringWithFormat:@"%@ %@",wifString,wifString];
            }
            char*SignatureStr=SignSignature(Transaction, [wifString UTF8String], self.fromCoinModel.cointype,[@"" UTF8String]);
            NSString* lastString = [[NSString alloc] initWithUTF8String:SignatureStr];
            NSLog(@"USDT签名字符串--%@",lastString);
            [self postTrade: lastString];//发送交易
            
            
        }
        
        else{
            
            
        }
        
    }else{//非代币
        
        if ([self.fromCoinModel.recordType intValue]==0) {//BTC,LTC，BCH等
            __block double allAmount=0;
            [self.contentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TransferModel*model=self.contentArray [idx];
                allAmount+=[model.amount doubleValue];
            }];
            
            if (allAmount<[self.fromiconLabel.text doubleValue]+[[self deleteStringWithStr:self.feeLabel.text] doubleValue]) {
                [self.view makeToast:LocalizationKey(@"balancelack") duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            //配置数据
            NSArray*modelArray=[self cofigModel:self.contentArray withAmount:self.fromiconLabel.text];
            self.utxoArray=modelArray;//记录未花交易数组
            NSMutableArray*inputArray=[[NSMutableArray alloc]init];
            NSMutableArray*outputArray=[[NSMutableArray alloc]init];
            __block double totalAmount=0;
            int outputs_count;
            [modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TransferModel*model=modelArray[idx];
                NSDictionary *modelDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[model.indexNo intValue]],@"prev_position",model.txid,@"prev_tx_hash",nil];
                [inputArray addObject:modelDic];
                totalAmount+=[model.amount doubleValue];
                
            }];
            NSString* inputAmount=self.fromiconLabel.text;
            double restAmount=totalAmount-[inputAmount doubleValue]-[[self deleteStringWithStr:self.feeLabel.text] doubleValue];
            if (restAmount<0) {
                [self.view makeToast:LocalizationKey(@"computationalanomaly") duration:1.5 position:CSToastPositionCenter];
                return ;
            }else if (restAmount==0)
            {
                outputs_count=1;
                NSDictionary *outDic=[NSDictionary dictionaryWithObjectsAndKeys:_changellyAdress,@"address",self.fromiconLabel.text,@"value",nil];
                [outputArray addObject:outDic];
            }else{
                outputs_count=2;
                NSDictionary *outDic1=[NSDictionary dictionaryWithObjectsAndKeys:_changellyAdress,@"address",self.fromiconLabel.text,@"value",nil];
                NSDictionary *outDic2=[NSDictionary dictionaryWithObjectsAndKeys:self.fromCoinModel.address,@"address",[NSString stringWithFormat:@"%.8f",totalAmount-[self.fromiconLabel.text doubleValue]-[[self deleteStringWithStr:self.feeLabel.text] doubleValue]],@"value",nil];
                [outputArray addObject:outDic1];
                [outputArray addObject:outDic2];
            }
            
            //构建字典
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)modelArray.count],@"inputs_count",inputArray,@"inputs",[NSNumber numberWithInt:outputs_count],@"outputs_count",outputArray,@"outputs",nil];
            NSString*jsonStr=[self convertToJsonData:dic];
            NSLog(@"-构建的字典-%@",dic);
            const char *Constjson = [jsonStr UTF8String];
            char *Transaction= NewTransaction(Constjson, self.fromCoinModel.cointype);
            const  char*privKey=GetCoinMasterKey([self.decryptStr  UTF8String], self.fromCoinModel.cointype);
            const  char*getSubKey=GetSubPrivKey(privKey, 2^31);
            const  char*wifprivKey=GetExportedPrivKey(getSubKey, self.fromCoinModel.cointype,self.fromCoinModel.Priveprefix);
            NSString* wifString = [[NSString alloc] initWithUTF8String:wifprivKey];
            for (int i = 0; i<modelArray.count-1; i++) {
                wifString=[NSString stringWithFormat:@"%@ %@",wifString,wifString];
            }
            char*SignatureStr;
            if ([self.fromCoinModel.brand isEqualToString:@"BCH"]) {
                NSMutableArray*reservedArray=[[NSMutableArray alloc]init];
                SignatureStr=SignSignature(Transaction, [wifString UTF8String], self.fromCoinModel.cointype,[@"" UTF8String]);
                [self.contentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TransferModel*model=self.contentArray [idx];
                    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:model.amount ];
                    NSDecimalNumber *decimalNumber2=[NSDecimalNumber decimalNumberWithString:@"100000000"];
                    NSDecimalNumber *result = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2];
                    [reservedArray addObject:result];
                    
                }];
                NSDictionary*dic=@{@"amount":reservedArray};
                NSString*jsonStr=[self convertToJsonData:dic];
                SignatureStr=SignSignature(Transaction, [wifString UTF8String], self.fromCoinModel.cointype,[jsonStr UTF8String]);
                
            }else{
                SignatureStr=SignSignature(Transaction, [wifString UTF8String], self.fromCoinModel.cointype,[@"" UTF8String]);
            }
            NSString* lastString = [[NSString alloc] initWithUTF8String:SignatureStr];
            NSLog(@"签名字符串--%@",lastString);
            [self postTrade: lastString];//发送交易
        }else if ([self.fromCoinModel.recordType intValue]==1){//ETH等
            //构建字典
            double val = pow(10, 18);//转出量
            double fee = pow(10, 18);//手续费,gasprice
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:self.fromCoinModel.address,@"from",_changellyAdress,@"to",[NSString stringWithFormat:@"%.0f",[self.fromiconLabel.text doubleValue]*val],@"value",_nonce,@"nonce",[NSString stringWithFormat:@"%.0f",[[self deleteStringWithStr:self.feeLabel.text] doubleValue]*fee/21000],@"gasprice",nil];
            NSString*jsonStr=[self convertToJsonData:dic];
            NSLog(@"-构建的字典-%@",dic);
            const char *Constjson = [jsonStr UTF8String];
            char *Transaction= NewTransaction(Constjson, self.fromCoinModel.cointype);
            const  char*privKey=GetCoinMasterKey([self.decryptStr  UTF8String], self.fromCoinModel.cointype);
            const  char*getSubKey=GetSubPrivKey(privKey, 2^31);
            const  char*wifprivKey=GetExportedPrivKey(getSubKey, self.fromCoinModel.cointype,self.fromCoinModel.Priveprefix);
            char*SignatureStr=SignSignature(Transaction, wifprivKey, self.fromCoinModel.cointype,[@"" UTF8String]);
            NSString* lastString = [[NSString alloc] initWithUTF8String:SignatureStr];
            NSLog(@"签名字符串--%@",lastString);
            [self postTrade: lastString];//发送交易
            
        }
        else{
            
            
            
            
        }
        
        
    }
    
    
    
    
}

//去掉字符串
-(NSString*)deleteStringWithStr:(NSString *)str{
    
    if (self.fromCoinModel.fatherCoin) {//代币
        if ([self.fromCoinModel.fatherCoin isEqualToString:@"ETH"]) {
            NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" BTC/KB" withString:@""];
            return strUrl;
        }
        else if ([self.fromCoinModel.fatherCoin isEqualToString:@"BTC"]) {
            NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" BTC/KB" withString:@""];
            return strUrl;
        }
        else{
            return @"";
        }
        
    }else{
        //非代币
        if ([self.fromCoinModel.recordType intValue]==0) {//BTC,LTC等
            NSString *strUrl = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@/KB",self.fromCoinModel.brand] withString:@""];
            return strUrl;
        }else{
            NSString *strUrl = [str stringByReplacingOccurrencesOfString:self.fromCoinModel.brand withString:@""];
            return strUrl;
        }
    }
    
}
/**
 @param modelArray 原model数组
 @return 计算出来作为交易对象的数组
 */
-(NSArray*)cofigModel:(NSArray*)modelArray withAmount:(NSString*)amount{
    NSMutableArray*modelArr=[[NSMutableArray alloc]init];
    __block double transferNum=0;
    [modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TransferModel*model=modelArray[idx];
        transferNum =[model.amount doubleValue]+transferNum;
        [modelArr addObject:model];
        if (transferNum>=[amount doubleValue]+[[self deleteStringWithStr:self.feeLabel.text] doubleValue]) {
            *stop=YES;
        }
    }];
    
    return modelArr;
}

//USDT的
-(NSArray*)USDTcofigModel:(NSArray*)modelArray withAmount:(NSString*)amount{
    __block BOOL _isContinue=NO;
    NSMutableArray*modelArr=[[NSMutableArray alloc]init];
    __block double transferNum=0;
    [modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TransferModel*model=modelArray[idx];
        transferNum =[model.amount doubleValue]+transferNum;
        [modelArr addObject:model];
        if (transferNum>=[amount doubleValue]+[[self deleteStringWithStr:self.feeLabel.text] doubleValue]+0.00000546) {
            _isContinue=YES;
            *stop=YES;
        }
    }];
    
    if (_isContinue) {
        return modelArr;
    }else{
        return [[NSArray alloc]init];
    }
    
    
}

// 字典转json字符串方法

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

/**
 调用接口，发送交易
 */
-(void)postTrade:(NSString*)SignatureStr{
//#warning
//    return;
    NSString*coinName;
    if (self.fromCoinModel.fatherCoin) {//代币
        if ([self.fromCoinModel.fatherCoin isEqualToString:@"ETH"]) {
            coinName=self.fromCoinModel.fatherCoin;
        }
        else if ([self.fromCoinModel.fatherCoin isEqualToString:@"BTC"]) {//USDT
            coinName=self.fromCoinModel.fatherCoin;
        }
        else{
            
        }
        
    }else{
        //非代币
        coinName=self.fromCoinModel.brand;
    }
    [SVProgressHUD show];
    [HomeNetManager postTrade:SignatureStr withcoinName:coinName  CompleteHandle:^(id resPonseObj, int code) {
        [SVProgressHUD dismiss];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self creatrandeModel:resPonseObj[@"data"]];//构建模型
                [self saveUTXOtransferArray];//本地记录未花交易
                [self creatExchangeModel];//本地记录兑换记录
                TransferSuccessController*transeferVC=[[TransferSuccessController alloc]init];
                transeferVC.popType=1;
                [self.navigationController pushViewController:transeferVC animated:YES];
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
/**
 构建兑换记录模型
 */
-(void)creatExchangeModel{
    changeModel*model=[[changeModel alloc]init];
    model.time=[NSString getCurrentTimes];
    model.fromCoin=self.fromLabel.text;
    model.toCoin=self.toLabel.text;
    model.fromAmount=self.fromiconLabel.text;
    model.toAmount=self.toiconLabel.text;
    model.fromAddress=self.fromAddress.text;
    model.toAddress=self.toCoinModel.address;
    model.rate=self.rate;
    model.status=@"0";
    model.txid=_txid;
    model.walletID=[UserinfoModel shareManage].wallet.bg_id;
    [model bg_save];
}
 
/**
 构建交易模型
 */
-(void)creatrandeModel:(NSString*)txid{
    TradeModel*model=[[TradeModel alloc]init];
    model.walletID=[UserinfoModel shareManage].wallet.bg_id;
    model.txid=txid;
    model.time=[NSString getCurrentTimes];
    model.amount=[NSString stringWithFormat:@"- %.8f",[self.fromiconLabel.text doubleValue]];
    model.fee=[self deleteStringWithStr:self.feeLabel.text];
    model.blockHeight=@"--";
    model.remark=@"";
    if ([self.fromCoinModel.recordType intValue]==0) {//BTC等
        model.Toaddress=_changellyAdress;
        
    }else if ([self.fromCoinModel.recordType intValue]==1||[self.fromCoinModel.recordType intValue]==2){ //ETH,USDT等
        model.from=self.fromCoinModel.address;
        model.to=_changellyAdress;
    }else{
        
      
      }
    model.own_id=self.fromCoinModel.bg_id;
    [model bg_save];
    
}
/**
 本地记录未花交易
 */
-(void)saveUTXOtransferArray{
    
    if ([self.fromCoinModel.recordType intValue]==0) {//BTC,DVC，LTC,DOGE等
        [self.utxoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TransferModel*transfer=self.utxoArray[idx];
            transfer.own_id=self.fromCoinModel.bg_id;
            transfer.transfeType=self.fromCoinModel.recordType;
            transfer.walletID=self.fromCoinModel.own_id;
            transfer.creatTime=[ToolUtil printDateStringWithNowDate:@"yyyy-MM-dd HH:mm:ss"];
            transfer.transfeType=self.fromCoinModel.recordType;
            transfer.own_id=self.fromCoinModel.bg_id;
            [transfer bg_save];
            
        }];
    }else if ([self.fromCoinModel.recordType intValue]==1){ //ETH等
        TransferModel*transfer=[[TransferModel alloc]init];
        transfer.own_id=self.fromCoinModel.bg_id;
        transfer.nonce=_nonce;
        transfer.address=self.fromCoinModel.address;
        transfer.walletID=self.fromCoinModel.own_id;
        transfer.creatTime=[ToolUtil printDateStringWithNowDate:@"yyyy-MM-dd HH:mm:ss"];
        transfer.transfeType=self.fromCoinModel.recordType;
        transfer.own_id=self.fromCoinModel.bg_id;
        [transfer bg_save];
        
    }
    else if ([self.fromCoinModel.recordType intValue]==2){ //USDT等
        [self.utxoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TransferModel*transfer=self.utxoArray[idx];
            transfer.own_id=self.fromCoinModel.bg_id;
            transfer.transfeType=self.fromCoinModel.recordType;
            transfer.walletID=self.fromCoinModel.own_id;
            transfer.creatTime=[ToolUtil printDateStringWithNowDate:@"yyyy-MM-dd HH:mm:ss"];
            transfer.transfeType=self.fromCoinModel.recordType;
            transfer.own_id=self.fromCoinModel.bg_id;
            [transfer bg_save];
            
        }];
        
    }else{// 其他
        
        
    }
    
    
}

/**
 验证转出地址是否正确

 */
-(void)validateAddress:(NSString*)address withFromCoin:(NSString*)coinName{
        if ([NSString stringIsNull:address]) {
            [self.view makeToast:LocalizationKey(@"Addressfail") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        //用于验证某个币种的地址是否合法
        BOOL verrify= [BiPayObject verifyCoinAddress:address  coinType:self.fromCoinModel.cointype];
        if (!verrify) {
            [self.view makeToast:LocalizationKey(@"addressErro") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        if ([address isEqualToString:self.fromCoinModel.address]) {
            [self.view makeToast:LocalizationKey(@"forbidTransfer") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
    [SVProgressHUD showWithStatus:LocalizationKey(@"Addressverification")];
    // 请求参数字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"Bipay" forKey:@"id"];
    [params setValue:@"2.0" forKey:@"jsonrpc"];
    [params setValue:@"validateAddress" forKey:@"method"];
    [params setValue:@{@"currency":coinName,@"address":address} forKey:@"params"];
    [RequestManager postRequestWithURLPath:ChangellyHOST withParamer:params completionHandler:^(id responseObject) {
        //地址校验成功
        [SVProgressHUD dismiss];
        if (responseObject[@"result"][@"result"]) {
            [self validateAddressSuccess];
        }else{
            [self.view makeToast:LocalizationKey(@"verificationfail") duration:1.5 position:CSToastPositionCenter];
        }
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
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
