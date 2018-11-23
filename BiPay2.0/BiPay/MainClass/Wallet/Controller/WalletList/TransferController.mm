//
//  TransferController.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "TransferController.h"
#import "MMScanViewController.h"
#import "ChooseContactsController.h"
#import "HomeNetManager.h"
#import "TransferModel.h"
#import "HBAlertPasswordView.h"
#import "TransferSuccessController.h"
#import "AESCrypt.h"
#import "TradeModel.h"
#import "ToolUtil.h"
#import "confirmTransferView.h"
@interface TransferController ()<HBAlertPasswordViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSString*_SignatureStr;
    NSString* _nonce;
    NSString* _gasprice;
    double _totalAmount;//总余额
    double _totalTokenAmount;//代币总余额
    confirmTransferView*_boardView;
}
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (weak, nonatomic) IBOutlet UIView *firstLineView;
@property (weak, nonatomic) IBOutlet UIView *secondLineView;
@property (weak, nonatomic) IBOutlet UIView *thirdLineView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UITextField *addresTF;
@property (weak, nonatomic) IBOutlet UITextField *transferAmount;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *slowLab;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet UILabel *normalLab;
@property (weak, nonatomic) IBOutlet UILabel *fastLab;
@property(nonatomic,strong)NSMutableArray*contentArray;
@property(nonatomic,strong)NSArray*utxoArray;//记录未花交易
@end

@implementation TransferController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=self.coin.brand;
    self.view.backgroundColor = tableViewBackColor;
    self.topBackView.backgroundColor = TransferCellBackColor;
    self.bottomBackView.backgroundColor = TransferCellBackColor;
    self.firstLineView.backgroundColor = lineColor;
    self.secondLineView.backgroundColor = lineColor;
    self.thirdLineView.backgroundColor = lineColor;
    [self.addresTF setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.remarkTF setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.transferAmount setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    self.addresTF.textColor = TFTextColor;
    self.remarkTF.textColor = TFTextColor;
    self.transferAmount.textColor = TFTextColor;
    self.feeLab.textColor = FeeLabColor;
    self.feeLabel.textColor = FeeLabColor;
    self.contentArray=[[NSMutableArray alloc]init];
    if (self.popType==1) {//扫描二维码进来
        if ([self.popCount doubleValue]>0) {
           self.transferAmount.text=self.popCount;//自动填充转账金额
        }
        self.addresTF.text=self.coin.address;
        NSArray*coinsArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id]]];
        [coinsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            coinModel*model= coinsArray[idx];
            if ([model.brand isEqualToString:self.coin.brand]) {
                self.coin.address=model.address;
                if (self.coin.fatherCoin) {
                    [self getTokenData];//余额
                    [self ServiceChargeToken];//手续费
                }else{
                    [self getData];
                    [self ServiceCharge];//查询交易手续费
                }
            }
        }];
    }else{
        if (self.coin.fatherCoin) {
            [self getTokenData];
            [self ServiceChargeToken];
        }else{
            [self getData];
            [self ServiceCharge];//查询交易手续费
        }
    }
    [self setRightBarButtonItem];
    self.slider.minimumTrackTintColor = barTitle;
    self.slider.maximumTrackTintColor = TFPlaceHolderColor;
    self.transferAmount.delegate=self;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
 
    UIColor *startColor = RGB(7,160,251,1);
    UIColor *endColor = RGB(7,160,251,1);
    NSArray *colors = @[startColor,endColor];
    UIImage *img = [self getGradientImageWithColors:colors imgSize:self.slider.bounds.size];
    [self.slider setMinimumTrackImage:img forState:UIControlStateNormal];
    
}

-(UIImage *)getGradientImageWithColors:(NSArray*)colors imgSize:(CGSize)imgSize
{
    NSMutableArray *arRef = [NSMutableArray array];
    for(UIColor *ref in colors) {
        [arRef addObject:(id)ref.CGColor];
        
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)arRef, NULL);
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(imgSize.width, imgSize.height);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.feeLab.text = LocalizationKey(@"fee");
    self.slowLab.text = LocalizationKey(@"slow");
    self.fastLab.text = LocalizationKey(@"fast");
    self.normalLab.text = LocalizationKey(@"normal");
    self.addresTF.placeholder = LocalizationKey(@"pleaseInputTransferAddress");
    self.remarkTF.placeholder =  LocalizationKey(@"remarkOption");
    self.transferAmount.placeholder = LocalizationKey(@"transferMoney");
    [self.transferBtn setTitle:LocalizationKey(@"next") forState:UIControlStateNormal];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;      // 手势有效设置为YES  无效为NO
        self.navigationController.interactivePopGestureRecognizer.delegate = self;    // 手势的代理设置为self
    }
}


/**
 选择手续费
 */
- (IBAction)changeValue:(UISlider *)sender {
    
    if (self.coin.fatherCoin) {//代币
        if ([self.coin.fatherCoin isEqualToString:@"ETH"]) {
                self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",sender.value,self.coin.fatherCoin];
        }
        else  if ([self.coin.fatherCoin isEqualToString:@"BTC"]) {
            //USDT
            self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@/KB",sender.value,self.coin.fatherCoin];
        }
        else{
            
            
        }
            
    }else{//非代币
        if ([self.coin.recordType intValue]==0) {
            //BTC,LTC,DOGE,BCH等
            if ([self.coin.brand isEqualToString:@"XNE"]||[self.coin.brand isEqualToString:@"GCA"]||[self.coin.brand isEqualToString:@"GCB"]||[self.coin.brand isEqualToString:@"GCC"]||[self.coin.brand isEqualToString:@"STO"]) {
                  self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",sender.value,self.coin.brand];
            }else{
                 self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@/KB",sender.value,self.coin.brand];
            }
            
        }else{
            //ETH等
            self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",sender.value,self.coin.brand];
            
        }
    }
    
   
}
/**
 查询交易手续费（非代币）
 */
-(void)ServiceCharge{
    [HomeNetManager cheakservicechargewithcoinName:self.coin.brand  CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {

                if ([self.coin.recordType intValue]==1){
                    //ETH
                    self->_gasprice=resPonseObj[@"data"];
                    self.slider.maximumValue=[self->_gasprice doubleValue]*10*21000/pow(10, 9);
                    self.slider.minimumValue=[self->_gasprice doubleValue]*1*21000/pow(10, 9);
                    self.slider.value=[self->_gasprice doubleValue]*21000/pow(10, 9)*2;
                    self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",[self->_gasprice doubleValue]*21000/pow(10, 9)*2,self.coin.brand];
                }
                else if ([self.coin.recordType intValue]==0){
                    //BTC,LTC,DOGE,BCH等
                    self.slider.maximumValue=[resPonseObj[@"data"] doubleValue]*10;
                    self.slider.minimumValue=[resPonseObj[@"data"] doubleValue]*1;
                    self.slider.value=[resPonseObj[@"data"] doubleValue]*2;
                   
                    if ([self.coin.brand isEqualToString:@"XNE"]||[self.coin.brand isEqualToString:@"GCA"]||[self.coin.brand isEqualToString:@"GCB"]||[self.coin.brand isEqualToString:@"GCC"]||[self.coin.brand isEqualToString:@"STO"]) {
                        self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",[resPonseObj[@"data"] doubleValue]*2,self.coin.brand];
                    }else{
                         self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@/KB",[resPonseObj[@"data"] doubleValue]*2,self.coin.brand];
                    }
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
 查询交易手续费（代币）
 */
-(void)ServiceChargeToken{
    [HomeNetManager cheakservicechargewithcoinName:self.coin.fatherCoin  CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
            if ([self.coin.fatherCoin isEqualToString:@"ETH"]){
                    self->_gasprice=resPonseObj[@"data"];
                    self.slider.maximumValue=[self->_gasprice doubleValue]*10*60000/pow(10, 9);
                    self.slider.minimumValue=[self->_gasprice doubleValue]*1*60000/pow(10, 9);
                    self.slider.value=[self->_gasprice doubleValue]*60000/pow(10, 9)*2;
                    self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@",[self->_gasprice doubleValue]*60000/pow(10, 9)*2,self.coin.fatherCoin];
                }
            else if ([self.coin.fatherCoin isEqualToString:@"BTC"]){
               //USDT
                self.slider.maximumValue=[resPonseObj[@"data"] doubleValue]*10;
                self.slider.minimumValue=[resPonseObj[@"data"] doubleValue]*1;
                self.slider.value=[resPonseObj[@"data"] doubleValue]*2;
                self.feeLabel.text=[NSString stringWithFormat:@"%.8f %@/KB",[resPonseObj[@"data"] doubleValue]*2,self.coin.fatherCoin];
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
    [SVProgressHUD show];
    __weak typeof(self) weakSelf=self;
    [HomeNetManager checksingleAddress:self.coin.address coinName:self.coin.brand  CompleteHandle:^(id resPonseObj, int code) {
        [SVProgressHUD dismiss];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                __strong typeof(weakSelf) strongSelf=weakSelf;
                NSDictionary*dic=[resPonseObj[@"data"] firstObject];
                if ([self.coin.recordType intValue]==0) {//utxo，BTC等
                    NSArray*utxoArray=dic[@"utxo"];
                    for (int i=0; i<utxoArray.count; i++) {
                        TransferModel*transfer=[TransferModel mj_objectWithKeyValues:utxoArray[i]];
                        transfer.amount=[NSString stringWithFormat:@"%.8f",[transfer.amount doubleValue]/pow(10, 8)];
                        [self.contentArray addObject:transfer];
                    }
                  strongSelf->_totalAmount=[dic[@"totalAmount"] doubleValue]/pow(10, 8) ;
                }else if([self.coin.recordType intValue]==1){//ETH等
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
 查询地址列表余额(代币)
 */
-(void)getTokenData{
    __weak typeof(self) weakSelf=self;
    if ([self.coin.fatherCoin isEqualToString:@"ETH"]) {
        [HomeNetManager coinNameTokenchecksingleAddress:self.coin.address WithcontractAddress:self.coin.contractAddress coinName:self.coin.fatherCoin CompleteHandle:^(id resPonseObj, int code, NSString *coinName) {
            if (code) {
                __strong typeof(weakSelf) strongSelf=weakSelf;
                if ([resPonseObj[@"code"] integerValue] == 0) {
                    NSDictionary*dic=(NSDictionary*)[resPonseObj[@"data"] firstObject];
                     strongSelf->_totalTokenAmount=[dic[@"totalAmount"] doubleValue]/(pow(10, [self.coin.decimals intValue]));
                    [self TokenGetRestMoney];
                    
                }else{
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
            }
            
        }];
    }else if ([self.coin.fatherCoin isEqualToString:@"BTC"]){//USDT类
       
        [HomeNetManager checksingleAddress:self.coin.address coinName:@"OMNI" CompleteHandle:^(id resPonseObj, int code) {
            [SVProgressHUD dismiss];
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
//得到父币种的余额，判断是否够手续费
-(void)TokenGetRestMoney{
    [SVProgressHUD show];
    [HomeNetManager checksingleAddress:self.coin.address coinName:self.coin.fatherCoin  CompleteHandle:^(id resPonseObj, int code) {
        [SVProgressHUD dismiss];
         __weak typeof(self) weakSelf=self;
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                __strong typeof(weakSelf) strongSelf=weakSelf;
                NSDictionary*dic=[resPonseObj[@"data"] firstObject];
              if([self.coin.fatherCoin isEqualToString:@"ETH"]){//ETH
                    strongSelf->_nonce=dic[@"nonce"];
                    strongSelf->_totalAmount=[dic[@"totalAmount"] doubleValue]/pow(10, 18);
                  
              }else if ([self.coin.fatherCoin isEqualToString:@"BTC"]){
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


- (void)setRightBarButtonItem
{
    UIButton * rightItem = [[UIButton alloc]init];
    [rightItem.titleLabel setFont:systemFont(15)];
    [rightItem setTitle:LocalizationKey(@"contanctMan") forState:UIControlStateNormal];
    [rightItem setTitleColor:barTitle forState:UIControlStateNormal];
    __weak TransferController *weakself=self;
    [rightItem dn_addActionHandler:^{
        [weakself.view endEditing:YES];
        ChooseContactsController*contactVC=[[ChooseContactsController alloc]init];
        [contactVC setGetBackBlock:^(NSString *text) {
            weakself.addresTF.text=text;
        }];
        [weakself.navigationController pushViewController:contactVC animated:YES];
    }];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = right;
}
//扫描二维码
- (IBAction)scan:(UIButton *)sender {
    MMScanViewController *scanVC = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error);
        } else {
            NSLog(@"扫描结果：%@",result);
             NSArray *array = [result componentsSeparatedByString:@":"];
            if ([[[array firstObject] uppercaseString] isEqualToString:[self.coin.englishName uppercaseString]]&&array.count==3) {
                self.addresTF.text=[array objectAtIndex:1];
                if ([[array lastObject] doubleValue]>0) {
                    self.transferAmount.text=[array lastObject];
                }else{
                    self.transferAmount.text=@"";
                }
                
            }else{
                
                if (![[[array firstObject] uppercaseString] isEqualToString:[self.coin.englishName uppercaseString]]&&array.count==3) {
                     [self.view makeToast:LocalizationKey(@"coinErro") duration:1.5 position:CSToastPositionCenter];
                }else{
                    self.addresTF.text=result;
                }
               
                
            }
        }
    }];
    scanVC.hidesBottomBarWhenPushed=YES;
    scanVC.popType=1;
    [self.navigationController pushViewController:scanVC animated:YES];
    
}

/**
 确定转账
 */
#pragma mark-转账按钮点击事件

- (IBAction)nextStep:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([NSString stringIsNull:self.addresTF.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseInputTransferAddress") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    //用于验证某个币种的地址是否合法
    BOOL verrify= [BiPayObject verifyCoinAddress:self.addresTF.text  coinType:self.coin.cointype];
    if (!verrify) {
        [self.view makeToast:LocalizationKey(@"addressErro") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([self.addresTF.text isEqualToString:self.coin.address]) {
        [self.view makeToast:LocalizationKey(@"forbidTransfer") duration:1.5 position:CSToastPositionCenter];
        return ;
    }

    if ([NSString stringIsNull:self.transferAmount.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseInputTransfer") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([self.transferAmount.text doubleValue]<=0) {
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
    if (self.coin.fatherCoin) {//代币
        if ([self.coin.fatherCoin isEqualToString:@"ETH"]) {

            if (_totalTokenAmount <[self.transferAmount.text doubleValue]) {
                [self.view makeToast:LocalizationKey(@"balancelack") duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            if (_totalAmount <[[self deleteStringWithStr:self.feeLabel.text] doubleValue]) {
                [self.view makeToast:LocalizationKey(@"shouxuFeebuzu") duration:1.5 position:CSToastPositionCenter];
                return ;
            }


        }else if ([self.coin.fatherCoin isEqualToString:@"BTC"])//USDT
        {
            if (_totalTokenAmount <[self.transferAmount.text doubleValue]) {
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
        
        if (_totalAmount <[self.transferAmount.text doubleValue]+[[self deleteStringWithStr:self.feeLabel.text] doubleValue]) {
            [self.view makeToast:LocalizationKey(@"balancelack") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        NSArray*transferArray= [TransferModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.coin.bg_id]]];
        [transferArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TransferModel*transfer=transferArray[idx];
            NSInteger timeDistance= [[NSDate date] timeIntervalSinceDate:[ToolUtil getDatewithString:transfer.creatTime]];//比较时间
            if (timeDistance>=30*60) {//30分钟
                [TransferModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:transfer.bg_id]]];
            }
        }];

        //判断未花交易
        if ([self.coin.recordType intValue]==0) {//BTC、DVC，LTC,DOGE等
            __block BOOL _isContinue=NO;
            NSArray*restArray= [TransferModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.coin.bg_id]]];
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

        }else if ([self.coin.recordType intValue]==1){ //ETH等
            NSArray*restArray= [TransferModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.coin.bg_id]]];
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

    if (!_boardView) {
        _boardView = [[NSBundle mainBundle] loadNibNamed:@"confirmTransferView" owner:nil options:nil].firstObject;
        _boardView.frame=[UIScreen mainScreen].bounds;
    }
    CGAffineTransform translates = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    _boardView.boardView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,0,_boardView.boardView.height);
    _boardView.amountlabel.text=[NSString stringWithFormat:@"%.8f %@",[self.transferAmount.text doubleValue],self.coin.brand];
    _boardView.addressLabel.text=self.addresTF.text;
    _boardView.feeLabel.text=self.feeLabel.text;
    _boardView.remarklabel.text=[self isBlankString:self.remarkTF.text]?@"--":self.remarkTF.text;
    _boardView.confirmTitle.text=LocalizationKey(@"Confirmationtransfer");
    [_boardView.confirmbtn addTarget:self action:@selector(NextStep) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_boardView.boardView.transform = translates;
        
    } completion:^(BOOL finished) {
        
    }];
    [UIApplication.sharedApplication.keyWindow addSubview:_boardView];
    
}

/**
 确定转账
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
#pragma mark - <HBAlertPasswordViewDelegate>
- (void)sureActionWithAlertPasswordView:(HBAlertPasswordView *)alertPasswordView password:(NSString *)password {
    [alertPasswordView removeFromSuperview];
    NSString*decryptStr=[AESCrypt decrypt:[UserinfoModel shareManage].wallet.password password:password];;
    if (!decryptStr) {
        [self.view makeToast:LocalizationKey(@"pwdErro") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if (self.coin.fatherCoin) {//代币
        if ([self.coin.fatherCoin isEqualToString:@"ETH"]) {
            double val = pow(10, [self.coin.decimals intValue]);//转出量
            double fee = pow(10, 18);//手续费,gasprice
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:self.coin.address,@"from",self.addresTF.text,@"to",[NSString stringWithFormat:@"%.0f",[self.transferAmount.text doubleValue]*val],@"value",_nonce,@"nonce",[NSString stringWithFormat:@"%.0f",[[self deleteStringWithStr:self.feeLabel.text] doubleValue]*fee/60000],@"gasprice",@"60000",@"gas",self.coin.contractAddress,@"contractAddr",nil];
            NSString*jsonStr=[self convertToJsonData:dic];
            NSLog(@"-构建的字典-%@",dic);
            const char *Constjson = [jsonStr UTF8String];
            char *Transaction= NewTransaction(Constjson, self.coin.cointype);
            const  char*privKey=GetCoinMasterKey([decryptStr UTF8String], self.coin.cointype);
            const  char*getSubKey=GetSubPrivKey(privKey, 2^31);
            const  char*wifprivKey=GetExportedPrivKey(getSubKey, self.coin.cointype,self.coin.Priveprefix);
            char*SignatureStr=SignSignature(Transaction, wifprivKey, self.coin.cointype,[@"" UTF8String]);
            NSString* lastString = [[NSString alloc] initWithUTF8String:SignatureStr];
            NSLog(@"签名字符串--%@",lastString);
            [self postTrade: lastString];//发送交易
            
        }else if ([self.coin.fatherCoin isEqualToString:@"BTC"]){
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
                NSDictionary *outDic=[NSDictionary dictionaryWithObjectsAndKeys:self.addresTF.text,@"address",@"0.00000546",@"value",nil];
                [outputArray addObject:outDic];
            }else{
                outputs_count=2;
                NSDictionary *outDic1=[NSDictionary dictionaryWithObjectsAndKeys:self.addresTF.text,@"address",@"0.00000546",@"value",nil];
                NSDictionary *outDic2=[NSDictionary dictionaryWithObjectsAndKeys:self.coin.address,@"address",[NSString stringWithFormat:@"%.8f",totalAmount-[@"0.00000546" doubleValue]-[[self deleteStringWithStr:self.feeLabel.text] doubleValue]],@"value",nil];
                [outputArray addObject:outDic1];
                [outputArray addObject:outDic2];
            }
            NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:self.transferAmount.text];
            NSDecimalNumber *decimalNumber2=[NSDecimalNumber decimalNumberWithString:@"100000000"];
            NSDecimalNumber *result = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2];
            NSArray*usdtArray=[NSArray arrayWithObjects:[NSNumber numberWithInt:31],result, nil];
            //构建字典
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)modelArray.count],@"inputs_count",inputArray,@"inputs",[NSNumber numberWithInt:outputs_count],@"outputs_count",outputArray,@"outputs",usdtArray,@"usdt",nil];
            NSString*jsonStr=[self convertToJsonData:dic];
            NSLog(@"-USDT构建的字典-%@",dic);
            const char *Constjson = [jsonStr UTF8String]; //用USDT的cointype构建交易
            char *Transaction= NewTransaction(Constjson, 207);
            const  char*privKey=GetCoinMasterKey([decryptStr UTF8String], self.coin.cointype);
            const  char*getSubKey=GetSubPrivKey(privKey, 2^31);
            const  char*wifprivKey=GetExportedPrivKey(getSubKey, self.coin.cointype,self.coin.Priveprefix);
            NSString* wifString = [[NSString alloc] initWithUTF8String:wifprivKey];
            for (int i = 0; i<modelArray.count-1; i++) {
                wifString=[NSString stringWithFormat:@"%@ %@",wifString,wifString];
            }
            char*SignatureStr=SignSignature(Transaction, [wifString UTF8String], self.coin.cointype,[@"" UTF8String]);
            NSString* lastString = [[NSString alloc] initWithUTF8String:SignatureStr];
            NSLog(@"USDT签名字符串--%@",lastString);
            [self postTrade: lastString];//发送交易
            
            
        }
        
        else{
            
            
        }
        
    }else{//非代币
        
        if ([self.coin.recordType intValue]==0) {//BTC,LTC,BCH，GCA，GCB等
            __block double allAmount=0;
            [self.contentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TransferModel*model=self.contentArray [idx];
                allAmount+=[model.amount doubleValue];
            }];
            
            if (allAmount<[self.transferAmount.text doubleValue]+[[self deleteStringWithStr:self.feeLabel.text] doubleValue]) {
                [self.view makeToast:LocalizationKey(@"balancelack") duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            //配置数据
            NSArray*modelArray=[self cofigModel:self.contentArray withAmount:self.transferAmount.text];
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
            NSString* inputAmount=self.transferAmount.text;
            double restAmount=totalAmount-[inputAmount doubleValue]-[[self deleteStringWithStr:self.feeLabel.text] doubleValue];
            if (restAmount<0) {
                [self.view makeToast:LocalizationKey(@"computationalanomaly") duration:1.5 position:CSToastPositionCenter];
                return ;
            }else if (restAmount==0)
            {
                outputs_count=1;
                NSDictionary *outDic=[NSDictionary dictionaryWithObjectsAndKeys:self.addresTF.text,@"address",self.transferAmount.text,@"value",nil];
                [outputArray addObject:outDic];
            }else{
                outputs_count=2;
                NSDictionary *outDic1=[NSDictionary dictionaryWithObjectsAndKeys:self.addresTF.text,@"address",self.transferAmount.text,@"value",nil];
                NSDictionary *outDic2=[NSDictionary dictionaryWithObjectsAndKeys:self.coin.address,@"address",[NSString stringWithFormat:@"%.8f",totalAmount-[self.transferAmount.text doubleValue]-[[self deleteStringWithStr:self.feeLabel.text] doubleValue]],@"value",nil];
                [outputArray addObject:outDic1];
                [outputArray addObject:outDic2];
            }
            //构建字典
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)modelArray.count],@"inputs_count",inputArray,@"inputs",[NSNumber numberWithInt:outputs_count],@"outputs_count",outputArray,@"outputs",nil];
            NSString*jsonStr=[self convertToJsonData:dic];
            NSLog(@"-构建的字典-%@",dic);
            const char *Constjson = [jsonStr UTF8String];
            char *Transaction= NewTransaction(Constjson, self.coin.cointype);
            const  char*privKey=GetCoinMasterKey([decryptStr UTF8String], self.coin.cointype);
            const  char*getSubKey=GetSubPrivKey(privKey, 2^31);
            const  char*wifprivKey=GetExportedPrivKey(getSubKey, self.coin.cointype,self.coin.Priveprefix);
            NSString* wifString = [[NSString alloc] initWithUTF8String:wifprivKey];
            for (int i = 0; i<modelArray.count-1; i++) {
                wifString=[NSString stringWithFormat:@"%@ %@",wifString,wifString];
            }
            char*SignatureStr;
            if ([self.coin.brand isEqualToString:@"BCH"]) {
                NSMutableArray*reservedArray=[[NSMutableArray alloc]init];
                 SignatureStr=SignSignature(Transaction, [wifString UTF8String], self.coin.cointype,[@"" UTF8String]);
                [self.contentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TransferModel*model=self.contentArray [idx];
                    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:model.amount ];
                    NSDecimalNumber *decimalNumber2=[NSDecimalNumber decimalNumberWithString:@"100000000"];
                    NSDecimalNumber *result = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2];
                    [reservedArray addObject:result];
                }];
                NSDictionary*reservedic=@{@"amount":reservedArray};
                NSString*jsonStr=[self convertToJsonData:reservedic];
                SignatureStr=SignSignature(Transaction, [wifString UTF8String], self.coin.cointype,[jsonStr UTF8String]);
                
            }else{
                 SignatureStr=SignSignature(Transaction, [wifString UTF8String], self.coin.cointype,[@"" UTF8String]);
            }
            NSString* lastString = [[NSString alloc] initWithUTF8String:SignatureStr];
            NSLog(@"签名字符串--%@",lastString);
            [self postTrade: lastString];//发送交易
        }else if ([self.coin.recordType intValue]==1){//ETH等
            //构建字典
            double val = pow(10, 18);//转出量
            double fee = pow(10, 18);//手续费,gasprice
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:self.coin.address,@"from",self.addresTF.text,@"to",[NSString stringWithFormat:@"%.0f",[self.transferAmount.text doubleValue]*val],@"value",_nonce,@"nonce",[NSString stringWithFormat:@"%.0f",[[self deleteStringWithStr:self.feeLabel.text] doubleValue]*fee/21000],@"gasprice",nil];
            NSString*jsonStr=[self convertToJsonData:dic];
            NSLog(@"-构建的字典-%@",dic);
            const char *Constjson = [jsonStr UTF8String];
            char *Transaction= NewTransaction(Constjson, self.coin.cointype);
            const  char*privKey=GetCoinMasterKey([decryptStr UTF8String], self.coin.cointype);
            const  char*getSubKey=GetSubPrivKey(privKey, 2^31);
            const  char*wifprivKey=GetExportedPrivKey(getSubKey, self.coin.cointype,self.coin.Priveprefix);
            char*SignatureStr=SignSignature(Transaction, wifprivKey, self.coin.cointype,[@"" UTF8String]);
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
    
    if (self.coin.fatherCoin) {//代币
        if ([self.coin.fatherCoin isEqualToString:@"ETH"]) {
            NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" BTC/KB" withString:@""];
            return strUrl;
        }
       else if ([self.coin.fatherCoin isEqualToString:@"BTC"]) {
           NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" BTC/KB" withString:@""];
           return strUrl;
        }
        else{
            return @"";
        }
        
    }else{
        //非代币
        if ([self.coin.recordType intValue]==0) {//BTC,LTC等
            if ([self.coin.brand isEqualToString:@"XNE"]||[self.coin.brand isEqualToString:@"GCA"]||[self.coin.brand isEqualToString:@"GCB"]||[self.coin.brand isEqualToString:@"GCC"]||[self.coin.brand isEqualToString:@"STO"]) {
                NSString *strUrl = [str stringByReplacingOccurrencesOfString:self.coin.brand withString:@""];
                return strUrl;
            }else{
                NSString *strUrl = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@/KB",self.coin.brand] withString:@""];
                return strUrl;
            }
          
        }else{
            NSString *strUrl = [str stringByReplacingOccurrencesOfString:self.coin.brand withString:@""];
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
    NSString*coinName;
    if (self.coin.fatherCoin) {//代币
        if ([self.coin.fatherCoin isEqualToString:@"ETH"]) {
            coinName=self.coin.fatherCoin;
        }
        else if ([self.coin.fatherCoin isEqualToString:@"BTC"]) {//USDT
            coinName=self.coin.fatherCoin;
        }
        else{
            
        }
        
    }else{
        //非代币
        coinName=self.coin.brand;
    }
    [SVProgressHUD show];
    [HomeNetManager postTrade:SignatureStr withcoinName:coinName  CompleteHandle:^(id resPonseObj, int code) {
        [SVProgressHUD dismiss];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self creatrandeModel:resPonseObj[@"data"]];//构建模型
                [self saveUTXOtransferArray];//本地记录未花交易
                TransferSuccessController*transeferVC=[[TransferSuccessController alloc]init];
                transeferVC.popType=0;
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
 构建交易模型
 */
-(void)creatrandeModel:(NSString*)txid{
    TradeModel*model=[[TradeModel alloc]init];
    model.walletID=[UserinfoModel shareManage].wallet.bg_id;
    model.txid=txid;
    model.time=[NSString getCurrentTimes];
    model.amount=[NSString stringWithFormat:@"- %.8f",[self.transferAmount.text doubleValue]];
    model.fee=[self deleteStringWithStr:self.feeLabel.text];
    model.blockHeight=@"--";
    model.remark=self.remarkTF.text;
    if ([self.coin.recordType intValue]==0) {//BTC等
        model.Toaddress=self.addresTF.text;
    }else if ([self.coin.recordType intValue]==1||[self.coin.recordType intValue]==2){ //ETH,USDT等
        model.from=self.coin.address;
        model.to=self.addresTF.text;
    }else{
        
    }
    if (self.popType==1) {
      //扫描二维码进来
       NSArray*coinsArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id]]];
        [coinsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            coinModel*coin= coinsArray[idx];
            if ([coin.brand isEqualToString:self.coin.brand]) {
                 model.own_id=coin.bg_id;
                [model bg_save];
            }
        }];
        
    }else{
                 model.own_id=self.coin.bg_id;
                 [model bg_save];
    }
}


/**
 控制textField输入位数
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 8;//小数点后需要限制的个数
    for (int i = (int)futureString.length-1; i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}

/**
 本地记录未花交易
 */
-(void)saveUTXOtransferArray{
    
    if ([self.coin.recordType intValue]==0) {//BTC,DVC，LTC,DOGE等
        [self.utxoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TransferModel*transfer=self.utxoArray[idx];
            transfer.own_id=self.coin.bg_id;
            transfer.transfeType=self.coin.recordType;
            transfer.walletID=self.coin.own_id;
            transfer.creatTime=[ToolUtil printDateStringWithNowDate:@"yyyy-MM-dd HH:mm:ss"];
            transfer.transfeType=self.coin.recordType;
            transfer.own_id=self.coin.bg_id;
            [transfer bg_save];
            
        }];
    }else if ([self.coin.recordType intValue]==1){ //ETH等
           TransferModel*transfer=[[TransferModel alloc]init];
           transfer.own_id=self.coin.bg_id;
           transfer.nonce=_nonce;
           transfer.address=self.coin.address;
           transfer.walletID=self.coin.own_id;
           transfer.creatTime=[ToolUtil printDateStringWithNowDate:@"yyyy-MM-dd HH:mm:ss"];
           transfer.transfeType=self.coin.recordType;
           transfer.own_id=self.coin.bg_id;
           [transfer bg_save];
        
    }
    else if ([self.coin.recordType intValue]==2){ //USDT等
        [self.utxoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TransferModel*transfer=self.utxoArray[idx];
            transfer.own_id=self.coin.bg_id;
            transfer.transfeType=self.coin.recordType;
            transfer.walletID=self.coin.own_id;
            transfer.creatTime=[ToolUtil printDateStringWithNowDate:@"yyyy-MM-dd HH:mm:ss"];
            transfer.transfeType=self.coin.recordType;
            transfer.own_id=self.coin.bg_id;
            [transfer bg_save];
            
        }];
        
    }else{// 其他
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
