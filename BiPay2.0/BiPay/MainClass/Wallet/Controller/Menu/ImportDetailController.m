//
//  ImportDetailController.m
//  BiPay
//
//  Created by sunliang on 2018/6/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ImportDetailController.h"
#import "InputMnemonicWordView.h"
#import "ImportSuccessController.h"
#import "AESCrypt.h"
#import "webViewprotocolVC.h"
#import "TradeModel.h"
#import "TransferModel.h"
#import "changeModel.h"
#import "TextFieldView.h"
@interface ImportDetailController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *textViewBackView;
@property (weak, nonatomic) IBOutlet UIView *secondLineView;
@property (weak, nonatomic) IBOutlet UIView *thirdLineView;
@property (weak, nonatomic) IBOutlet UIView *firstLineView;
@property (weak, nonatomic) IBOutlet UIView *forthLineView;
@property (nonatomic,retain)NSString *CountType;
@property (nonatomic,strong)InputMnemonicWordView *mnemonicView;
@property (nonatomic,strong)TextFieldView *textFieldView;
@property(nonatomic,strong)walletModel*wallet;//检测出来的已存在的相同的钱包
@end

@implementation ImportDetailController
- (id)initWithType:(NSString *)type
{
    self = [super init];
    if (self)
    {
        if ([type isEqualToString:@"help"]) {
            _CountType = @"help";
        }else if([type isEqualToString:@"key"]){
            _CountType = @"key";
        }else{
            _CountType = @"";
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    self.firstLineView.backgroundColor = lineColor;
    self.secondLineView.backgroundColor = lineColor;
    self.thirdLineView.backgroundColor = lineColor;
    self.forthLineView.backgroundColor = lineColor;
    self.textViewBackView.backgroundColor = CellBackColor;
    self.password.placeholder = LocalizationKey(@"pleaseImput6Pwd");
    self.passwordPrompt.placeholder = LocalizationKey(@"pwdTipMsg");
    self.nameTF.placeholder = LocalizationKey(@"pleaseImputPacketName");
    self.confirmPassword.placeholder = LocalizationKey(@"pleaseOkPwd");
    self.password.textColor = TFTextColor;
    self.passwordPrompt.textColor = TFTextColor;
    self.nameTF.textColor = TFTextColor;
    self.confirmPassword.textColor = TFTextColor;
    [self.password setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordPrompt setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTF setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPassword setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.tipsLabel.text = LocalizationKey(@"startImportLabTip");
    self.tipsLabel.textColor = BtnTitleDisableColor;
    self.bgview.backgroundColor = ViewBackColor;
    self.leadInBtn.enabled = NO;
    [self.leadInBtn setTitleColor:BtnTitleDisableColor forState:UIControlStateNormal];
    self.leadInBtn.backgroundColor = BtnBackDisableColor;
    [self.userTerms setTitleColor:ServiceBtnTitleColor forState:UIControlStateNormal];
    [self.userTerms setTitle:[NSString stringWithFormat:@"《%@》",LocalizationKey(@"serviceAndPrivacy")] forState:UIControlStateNormal];
    [self.leadInBtn setTitle:LocalizationKey(@"startImport") forState:UIControlStateNormal];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
   
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice) name:@"hiddenAction" object:nil];
    if ([_CountType isEqualToString:@"help"]) {
        _textFieldView = [[NSBundle mainBundle] loadNibNamed:@"TextFieldView" owner:nil options:nil].firstObject;
        _textFieldView.frame = _mnemonicContainer.bounds;
        _textFieldView.backgroundColor=CellBackColor;
        [_mnemonicContainer addSubview:_textFieldView];
    }
    if ([_CountType isEqualToString:@"key"]) {
        _mnemonicView = [[NSBundle mainBundle] loadNibNamed:@"InputMnemonicWordView" owner:nil options:nil].firstObject;
        _mnemonicView.frame = _mnemonicContainer.bounds;
        _mnemonicView.textView.textColor = TFTextColor;
        _mnemonicView.backgroundColor=CellBackColor;
        _mnemonicView.placeholder.textColor = TVPlaceHolderColor;
        [_mnemonicContainer addSubview:_mnemonicView];
        self.mnemonicView.placeholder.text=LocalizationKey(@"pleasePrivateKey");
    }
    CGRect rect = self.bgview.frame;
    rect.size.width = kWindowW;
    self.bgview.frame = rect;
    [self.bg_scrollView addSubview:self.bgview];
    self.bg_scrollView.contentSize = self.bgview.frame.size;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![NSString stringIsNull:self.nameTF.text] && ![NSString stringIsNull:self.password.text] && ![NSString stringIsNull:self.confirmPassword.text]) {
        self.leadInBtn.enabled = YES;
        [self.leadInBtn setTitleColor:BtnTitleEnableColor forState:UIControlStateNormal];
        [self.leadInBtn setBackgroundImage:[UIImage imageNamed:@"btnBackground"] forState:UIControlStateNormal];
        return ;
    }else{
        self.leadInBtn.enabled = NO;
        [self.leadInBtn setTitleColor:BtnTitleDisableColor forState:UIControlStateNormal];
        self.leadInBtn.backgroundColor = BtnBackDisableColor;
        [self.leadInBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
}
//去除输入框
-(void)notice{
    
    [self.view endEditing:YES];
    [_mnemonicView.textView resignFirstResponder];
    
}

//开始导入
- (IBAction)beginImport:(UIButton *)sender {
    if ([_CountType isEqualToString:@"help"]) {
        if ([NSString stringIsNull:[self.textFieldView checkstring:self.view]]) {
           // [self.view makeToast:LocalizationKey(@"pleaseInputMemoryWord") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        
         NSArray *array = [[self.textFieldView checkstring:self.view] componentsSeparatedByString:@" "];
        if (array.count!=12) {
            [self.view makeToast:LocalizationKey(@"mnemonicwordsnotformatted") duration:1.5 position:CSToastPositionCenter];
            return ;
        }

        NSString *seedString = [BiPayObject getSeedWithMnemonic:[self.textFieldView checkstring:self.view]];
        if ([seedString isEqualToString:@""]) {
            [self.view makeToast:LocalizationKey(@"illegalMnemonicWords") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        
        
    }else if ([_CountType isEqualToString:@"key"]){
        if ([NSString stringIsNull:self.mnemonicView.textView.text]) {
            [self.view makeToast:LocalizationKey(@"pleaseEnterPrivateKey") duration:1.5 position:CSToastPositionCenter];
            return ;
        }

        NSString *privKey = [BiPayObject getExPrivKey:self.mnemonicView.textView.text coinType:0];
        
        if ([privKey isEqualToString:@""])
        {
            [self.view makeToast:LocalizationKey(@"illegalPrivateKey") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        
    }else{
      
        
    }
    
    if ([NSString stringIsNull:self.nameTF.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseImputPacketName") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([NSString stringIsNull:self.password.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseImput6Pwd") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([self.password.text length]!=6) {
        [self.view makeToast:LocalizationKey(@"pwdLengthErro") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([NSString stringIsNull:self.confirmPassword.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseReImputPwd") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if (![self.password.text isEqualToString:self.confirmPassword.text]) {
        [self.view makeToast:LocalizationKey(@"twoImputPwdNoSame") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    NSArray*walletArray= [walletModel bg_findAll:nil];
    //从model中查看是否有相同的属性
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", self.nameTF.text];
    NSArray *filteredArray = [walletArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count>0) {
        [self.view makeToast:LocalizationKey(@"packetNameNoSame") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([_CountType isEqualToString:@"help"]) {
        //助记词导入钱包
        if ([self checkBTCIsSame:NO]) {
            [walletModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            [coinModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            [TradeModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            [TransferModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            [changeModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            
        }
        walletModel*wallet=[[walletModel alloc]init];
        wallet.name=self.nameTF.text;
        //wallet.password= self.confirmPassword.text;
        wallet.tips=self.passwordPrompt.text;
        wallet.isHide=@"0";
        NSString* sed = [BiPayObject getSeedWithMnemonic:[self.textFieldView checkstring:self.view]];
        NSString* masterKey = [BiPayObject getMasterKey:sed];
        wallet.mnemonics=@"";
        wallet.password= [AESCrypt encrypt:masterKey password:self.confirmPassword.text];
        BOOL isSuccess=  [wallet bg_save];
        if(isSuccess){
            [SVProgressHUD showWithStatus:LocalizationKey(@"walletGeneration")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray * arr = [walletModel bg_findAll:nil];
                walletModel*walletCoin=[arr lastObject];
                if (![walletCoin.password isEqualToString:wallet.password]) {
                    [SVProgressHUD dismiss];
                    [self.view makeToast:LocalizationKey(@"walletFail") duration:1.5 position:CSToastPositionCenter];
                    return ;//没有创建钱包成功
                }

                NSString*coinaNames =[BiPayObject getSupportedCoins];
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\\[\\]"];
                coinaNames = [coinaNames stringByTrimmingCharactersInSet:set];//去掉两头括号
                coinaNames = [coinaNames stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSArray *Namearray=[UserinfoModel shareManage].Namearray;
                NSArray *coinTypeArray=[UserinfoModel shareManage].coinTypeArray;
                NSArray *tradeTypeArray=[UserinfoModel shareManage].tradeTypeArray;
                NSArray *AddressprefixArray=[UserinfoModel shareManage].AddressprefixTypeArray;
                 NSArray *PriveprefixArray=[UserinfoModel shareManage].PriveprefixTypeArray;
                for (int i=0; i<Namearray.count; i++) {
                    [self creatCoins:Namearray[i] withCointype:[coinTypeArray[i] intValue] withAddressprefix:[AddressprefixArray[i] intValue]  withPriveprefix:[PriveprefixArray[i] intValue]  withTradetype:tradeTypeArray[i] withID:walletCoin.bg_id withMasterKey:masterKey withWallet:walletCoin];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    ImportSuccessController*importVC=[[ImportSuccessController alloc]init];
                    importVC.popType=1;
                    [self.navigationController pushViewController:importVC animated:YES];
                });
            });
            
        }else{
            NSLog(@"导入钱包失败");
            [self.view makeToast:LocalizationKey(@"walletGenerationFailimport") duration:1.5 position:CSToastPositionCenter];
            
        }
       
    }else if ([_CountType isEqualToString:@"key"]){
        //主私钥导入钱包
        if ([self checkBTCIsSame:YES]) {//如果该钱包已存在，则覆盖该钱包

            [walletModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            [coinModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            [TradeModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            [TransferModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            [changeModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
            
        }
        walletModel*wallet=[[walletModel alloc]init];
        wallet.name=self.nameTF.text;
        wallet.password= [AESCrypt encrypt:self.mnemonicView.textView.text password:self.confirmPassword.text];
        wallet.tips=self.passwordPrompt.text;
        wallet.mnemonics=@"";
        wallet.isHide=@"0";
        BOOL isSuccess=  [wallet bg_save];
        if(isSuccess){
            //导入钱包成功
            [SVProgressHUD showWithStatus:LocalizationKey(@"walletGeneration")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray * arr = [walletModel bg_findAll:nil];
                walletModel*walletCoin=[arr lastObject];
                if (![walletCoin.password isEqualToString:wallet.password]) {
                    [SVProgressHUD dismiss];
                    [self.view makeToast:LocalizationKey(@"walletFail") duration:1.5 position:CSToastPositionCenter];
                    return ;//没有创建钱包成功
                }

                NSString*coinaNames = [BiPayObject getSupportedCoins];
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\\[\\]"];
                coinaNames = [coinaNames stringByTrimmingCharactersInSet:set];//去掉两头括号
                coinaNames = [coinaNames stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSArray *Namearray=[UserinfoModel shareManage].Namearray;
                NSArray *typeArray=[UserinfoModel shareManage].coinTypeArray;
                NSArray *tradeTypeArray=[UserinfoModel shareManage].tradeTypeArray;
                NSArray *AddressprefixArray=[UserinfoModel shareManage].AddressprefixTypeArray;
                NSArray *PriveprefixArray=[UserinfoModel shareManage].PriveprefixTypeArray;
                for (int i=0; i<Namearray.count; i++) {
                    [self creatCoins:Namearray[i] withCointype:[typeArray[i] intValue] withAddressprefix:[AddressprefixArray[i] intValue] withPriveprefix:[PriveprefixArray[i] intValue]   withTradetype:tradeTypeArray[i]  withID:walletCoin.bg_id withMasterKey:self.mnemonicView.textView.text withWallet:walletCoin];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    ImportSuccessController*importVC=[[ImportSuccessController alloc]init];
                    importVC.popType=1;
                    [self.navigationController pushViewController:importVC animated:YES];
                });
            });
            
        }else{
            NSLog(@"导入钱包失败");
            [self.view makeToast:LocalizationKey(@"walletGenerationFailimport") duration:1.5 position:CSToastPositionCenter];
            
        }
       
        
        
    }else{
        
        
        
        
    }

}
//往钱包内添加币种
-(void)creatCoins:(NSString*)coinName withCointype:(int)type withAddressprefix:(int)addressprefix withPriveprefix:(int)priveprefix withTradetype:(NSString*)tradeType withID:(NSNumber*)ID withMasterKey:(NSString*)masterKey withWallet:(walletModel*)wallet{
    coinModel*coin=[[coinModel  alloc]init];
    coin.brand=coinName;
    coin.own_id=ID;
    coin.cointype=type;
    coin.Addressprefix=addressprefix;
    coin.Priveprefix=priveprefix;
    coin.blockHeight=0;
    coin.usdPrice=@"0";
    coin.closePrice=@"0";
    coin.totalAmount=@"0";
    coin.recordType=tradeType;
    coin.addtime=[self getNowTimeTimestamp];
    if ([coin.brand isEqualToString:@"BTC"]||[coin.brand isEqualToString:@"ETH"]) {
        coin.collect=1;
    }else{
        coin.collect=0;
    }
    if ([coin.brand isEqualToString:@"USDT"]) {
        coin.fatherCoin=@"BTC";
    }

    coin.address = [BiPayObject createWalletWithPrivateKey:masterKey coinType:type addressprefix:addressprefix];

    [coin bg_save];
    
    
}
- (IBAction)check:(UIButton*)sender {
    
    sender.selected=!sender.selected;
}
/**
 根据助记词或者私钥检查本地是否已经有这个钱包(根据BTC地址是否相同)

 */
-(BOOL)checkBTCIsSame:(BOOL)isMastkey{
    NSString*address;
    if (!isMastkey) {//助记词生成钱包
       address = [BiPayObject createWalletWithMnemonic:[self.textFieldView checkstring:self.view] coinType:0 addressprefix:0];
    }else{ //私钥生成钱包
       address = [BiPayObject createWalletWithPrivateKey:self.mnemonicView.textView.text coinType:0 addressprefix:0];
        
    }
    //检测本地是否有比特币这个地址
     NSArray * allwallet = [walletModel bg_findAll:nil];
   __block BOOL isSameed=NO;
    [allwallet enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        walletModel*wallet=allwallet[idx];
        NSArray*coinsArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id]]];
        //从model中查看是否有相同的属性
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"address == %@", address];
        NSArray *filteredArray = [coinsArray filteredArrayUsingPredicate:predicate];
        if (filteredArray.count>0) {
            isSameed=YES;
            self.wallet=wallet;//记录下这个相同的钱包
            *stop=YES;
        }

        if (isSameed) {
            *stop=YES;
        }
    }];
    if (isSameed) {
        return YES;
    }else{
        return NO;
    }
}
- (IBAction)lookProtocol:(UIButton *)sender {
    webViewprotocolVC *vc = [[webViewprotocolVC alloc] init];
    vc.navTitle=LocalizationKey(@"serviceAndPrivacy");
    [self presentViewController:vc animated:true completion:nil];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
