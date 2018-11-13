//
//  ModifypwController.m
//  BiPay
//
//  Created by sunliang on 2018/6/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ModifypwController.h"
#import "AESCrypt.h"
@interface ModifypwController ()
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *BackView;
@property (weak, nonatomic) IBOutlet UIView *secondLineview;
@property (weak, nonatomic) IBOutlet UIView *firstLineView;

@end

@implementation ModifypwController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    
    self.firstLineView.backgroundColor = lineColor;
    self.secondLineview.backgroundColor = lineColor;
    
    self.BackView.backgroundColor = CellBackColor;
    
    self.oldPsw.textColor = TFTextColor;
    self.inputPsd.textColor = TFTextColor;
    self.confirmTF.textColor = TFTextColor;
    
    [self.oldPsw setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.inputPsd setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmTF setValue:TFPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
   
    self.navigationItem.title=LocalizationKey(@"changePassword");
    self.oldPsw.placeholder = LocalizationKey(@"pleaseOriginalPwd");
    self.inputPsd.placeholder = LocalizationKey(@"pleaseImput6newPwd");
    self.confirmTF.placeholder = LocalizationKey(@"pleaseOkPwd");
    [self.confirmBtn setTitle:LocalizationKey(@"confirm") forState:UIControlStateNormal];
}

//确认修改
- (IBAction)clickBtn:(UIButton *)sender {
    if ([NSString stringIsNull:self.oldPsw.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseOriginalPwd") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([NSString stringIsNull:self.inputPsd.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseNewPwd") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if ([NSString stringIsNull:self.confirmTF.text]) {
        [self.view makeToast:LocalizationKey(@"pleaseReImputPwd") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if (![self.inputPsd.text isEqualToString:self.confirmTF.text]) {
        [self.view makeToast:LocalizationKey(@"twoImputPwdNoSame") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if (self.oldPsw.text.length!=6||self.inputPsd.text.length!=6||self.confirmTF.text.length!=6) {
        [self.view makeToast:LocalizationKey(@"need6Pwd") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    
    NSString*decryptStr=[AESCrypt decrypt:self.wallet.password password:self.oldPsw.text];;
    if (!decryptStr) {
        [self.view makeToast:LocalizationKey(@"oldpwdErro") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    //更新密码
    self.wallet.password=[AESCrypt encrypt:decryptStr password:self.confirmTF.text];
    [self.wallet bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
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
