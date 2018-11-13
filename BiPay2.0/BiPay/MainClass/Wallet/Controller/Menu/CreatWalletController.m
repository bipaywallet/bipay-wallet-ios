//
//  CreatWalletController.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "CreatWalletController.h"
#import "backupsWalletController.h"
#import "BackupMnemonicController.h"
#import "webViewprotocolVC.h"
@interface CreatWalletController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmTF;
@property (weak, nonatomic) IBOutlet UITextField *TipsTF;
@property (weak, nonatomic) IBOutlet UILabel *createWalletLab;
@property (weak, nonatomic) IBOutlet UIButton *createPacket;
@property (weak, nonatomic) IBOutlet UIButton *serviceAndPrivacyBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreeLab;
@property (weak, nonatomic) IBOutlet UIView *thirdLineView;
@property (weak, nonatomic) IBOutlet UIView *firstLineView;
@property (weak, nonatomic) IBOutlet UIView *secondLineView;
@property (weak, nonatomic) IBOutlet UIView *forthLineView;

@end

@implementation CreatWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=NavColor;
    
    self.createWalletLab.text = LocalizationKey(@"createPacket");
    
    self.pswTF.placeholder = LocalizationKey(@"pleaseImput6Pwd");
    self.TipsTF.placeholder = LocalizationKey(@"pwdTipMsg");
    self.nameTF.placeholder = LocalizationKey(@"pleaseImputPacketName");
    self.ConfirmTF.placeholder = LocalizationKey(@"pleaseOkPwd");
    
    self.pswTF.textColor = TFTextColor;
    self.TipsTF.textColor = TFTextColor;
    self.nameTF.textColor = TFTextColor;
    self.ConfirmTF.textColor = TFTextColor;
    
    [self.pswTF setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.TipsTF setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTF setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.ConfirmTF setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    self.firstLineView.backgroundColor = lineColor;
    self.secondLineView.backgroundColor = lineColor;
    self.thirdLineView.backgroundColor = lineColor;
    self.forthLineView.backgroundColor = lineColor;

    self.agreeLab.text = LocalizationKey(@"agreeServiceLab");
    self.agreeLab.textColor = BtnTitleDisableColor;
    [self.serviceAndPrivacyBtn setTitle:[NSString stringWithFormat:@"《%@》",LocalizationKey(@"serviceAndPrivacy")] forState:UIControlStateNormal];
    [self.serviceAndPrivacyBtn setTintColor:ServiceBtnTitleColor];
    self.createPacket.enabled = NO;
    [self.createPacket setTitleColor:BtnTitleDisableColor forState:UIControlStateNormal];
    self.createPacket.backgroundColor = BtnBackDisableColor;
    [self.createPacket setTitle:LocalizationKey(@"createPacket") forState:UIControlStateNormal];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![NSString stringIsNull:self.nameTF.text] && ![NSString stringIsNull:self.pswTF.text] && ![NSString stringIsNull:self.ConfirmTF.text]) {
        self.createPacket.enabled = YES;
        [self.createPacket setTitleColor:BtnTitleEnableColor forState:UIControlStateNormal];
        [self.createPacket setBackgroundImage:[UIImage imageNamed:@"btnBackground"] forState:UIControlStateNormal];
        return ;
    }else{
        self.createPacket.enabled = NO;
        [self.createPacket setTitleColor:BtnTitleDisableColor forState:UIControlStateNormal];
        self.createPacket.backgroundColor = BtnBackDisableColor;
        [self.createPacket setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
}
- (IBAction)creatBtn:(UIButton *)sender {
    
    if ([NSString stringIsNull:self.nameTF.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseImputPacketName") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([NSString stringIsNull:self.pswTF.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseImput6Pwd") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([self.pswTF.text length]!=6) {
        [self.view makeToast:LocalizationKey(@"pwdLengthErro") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([NSString stringIsNull:self.ConfirmTF.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseReImputPwd") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
   
    if (![self.pswTF.text isEqualToString:self.ConfirmTF.text]) {
        [self.view makeToast:LocalizationKey(@"twoImputPwdNoSame") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    
    
    NSArray*walletArray=[walletModel bg_findAll:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", self.nameTF.text];
    NSArray *filteredArray = [walletArray filteredArrayUsingPredicate:predicate];

    if (filteredArray.count>0) {

        [self.view makeToast:LocalizationKey(@"packetNameNoSame") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    //数据库加入钱包
    walletModel*wallet=[[walletModel alloc]init];
    wallet.name=self.nameTF.text;
    wallet.password= self.pswTF.text;
    wallet.tips=self.TipsTF.text;
    wallet.isHide=@"0";
    BackupMnemonicController*backup=[[BackupMnemonicController alloc]init];
    backup.model=wallet;
    [self.navigationController pushViewController:backup animated:YES];
    
}
 
- (IBAction)lookProtocol:(UIButton *)sender {
    webViewprotocolVC *vc = [[webViewprotocolVC alloc] init];
    vc.navTitle=LocalizationKey(@"serviceAndPrivacy");
    [self presentViewController:vc animated:true completion:nil];
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
