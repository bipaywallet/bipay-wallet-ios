//
//  ImportSuccessController.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ImportSuccessController.h"
#import "TabBarController.h"
#import "AppDelegate.h"
@interface ImportSuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *successLab;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;

@end

@implementation ImportSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    //隐藏导航栏左侧返回按钮
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]init];
    barBtn.title=@"";
    self.navigationItem.leftBarButtonItem = barBtn;
    if (self.popType==0) {
        self.navigationItem.title=LocalizationKey(@"createPacket");
        self.successLab.text = LocalizationKey(@"walletSuccess");
    }else{
        self.navigationItem.title=LocalizationKey(@"importPacket");
        self.successLab.text = LocalizationKey(@"importwalletSuccess");
    }
  walletModel*walletCoin=[[walletModel bg_findAll:nil] lastObject];
  [[UserinfoModel shareManage] reloadLocalDataWithWallet:walletCoin];
  [UserinfoModel shareManage].wallet=walletCoin;
  [NSUserDefaultUtil PutNumberDefaults:CurrentWalletID Value:walletCoin.bg_id];//存储到本地
  [[NSNotificationCenter defaultCenter] postNotificationName:WalletChange object:nil];
    
    // Do any additional setup after loading the view from its nib.
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
    
    [self.useBtn setTitle:LocalizationKey(@"Immediateuse") forState:UIControlStateNormal];
}
//立即使用
- (IBAction)Touse:(UIButton *)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
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
