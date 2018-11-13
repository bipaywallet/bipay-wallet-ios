//
//  TransferSuccessController.m
//  BiPay
//
//  Created by sunliang on 2018/8/10.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "TransferSuccessController.h"

@interface TransferSuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation TransferSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    //隐藏导航栏左侧返回按钮
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]init];
    barBtn.title=@"";
    self.navigationItem.leftBarButtonItem = barBtn;
    self.navigationItem.title=LocalizationKey(@"transfer");
    [self.confirmBtn setTitle:LocalizationKey(@"confirm") forState:UIControlStateNormal];
    if (self.popType==0) {
        self.alertLabel.text=LocalizationKey(@"Transfersuccess");
    }else{
        self.alertLabel.text=LocalizationKey(@"Exchangesuccess");
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
    
}

- (IBAction)confirm:(UIButton *)sender {
    
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
