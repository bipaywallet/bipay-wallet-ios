//
//  backupsWalletController.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "backupsWalletController.h"
#import "HBAlertPasswordView.h"
#import "BackupMnemonicController.h"
@interface backupsWalletController ()<HBAlertPasswordViewDelegate>

@end

@implementation backupsWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=LocalizationKey(@"backupWallet");
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self setRightBarButtonItem];
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
    
}
- (void)setRightBarButtonItem
{
    UIButton * rightItem = [[UIButton alloc]init];
    [rightItem.titleLabel setFont:systemFont(15)];
    [rightItem setTitle:LocalizationKey(@"help") forState:UIControlStateNormal];
    [rightItem setTitleColor:barTitle forState:UIControlStateNormal];
    [rightItem dn_addActionHandler:^{
        
        
    }];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = right;
}

- (IBAction)backup:(UIButton *)sender {
    //密码框的View
    HBAlertPasswordView *alertPasswordView = [[HBAlertPasswordView alloc] initWithFrame:self.view.bounds];
    alertPasswordView.delegate = self;
    [self.view addSubview:alertPasswordView];
}

#pragma mark - <HBAlertPasswordViewDelegate>
- (void)sureActionWithAlertPasswordView:(HBAlertPasswordView *)alertPasswordView password:(NSString *)password {
    [alertPasswordView removeFromSuperview];
    NSLog(@"%@", [NSString stringWithFormat:@"输入的密码为:%@", password]);
    BackupMnemonicController *mnemonicVc = [[BackupMnemonicController alloc] init];
    [self.navigationController pushViewController:mnemonicVc animated:YES];
    
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
