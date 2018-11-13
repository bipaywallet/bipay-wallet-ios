//
//  BackupMnemonicController.m
//  BiPay
//
//  Created by 褚青骎 on 2018/8/3.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BackupMnemonicController.h"
#import "MnemonicView.h"
#import "ConfirmMnemonicController.h"

@interface BackupMnemonicController ()
@property (weak, nonatomic) IBOutlet UILabel *tipsTitle;
@property (weak, nonatomic) IBOutlet UILabel *tipsContent;
@property (weak, nonatomic) IBOutlet UIView *mnemonicContainer;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@property (nonatomic, strong) NSArray *chineseArr;
@property (nonatomic, strong) NSArray *englishArr;

@property (strong, nonatomic) MnemonicView *mnemonicView;

- (IBAction)nextStep:(id)sender;

@end

@implementation BackupMnemonicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    self.tipsTitle.textColor = barTitle;
    self.tipsContent.textColor = barTitle;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString
                                                    alloc] initWithString:self.tipsContent.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle
                                                    alloc] init];
    
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraphStyle range:NSMakeRange(0, [self.tipsContent.text length])];
    
    self.tipsContent.attributedText = attributedString;
    
    self.tipsContent.lineBreakMode = NSLineBreakByCharWrapping;
    
    [self setLeftButtonItem];
    [self setRightBarButtonItem];
    //初始化助记词view并加入到Controller
    _mnemonicView = [MnemonicView init:CGRectMake(0, 0, SCREEN_WIDTH - 20, CGRectGetHeight(_mnemonicContainer.bounds))];
    [_mnemonicContainer addSubview:_mnemonicView];

    NSString* ChimnemonicString = [BiPayObject getMnemonic:8];
    _chineseArr = [ChimnemonicString componentsSeparatedByString:@" "];

    NSString* engmnemonicString = [BiPayObject getMnemonic:0];
     _englishArr = [engmnemonicString componentsSeparatedByString:@" "];
    _mnemonicView.mnemonicWord = _chineseArr;
    [_mnemonicView reloadData];
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
    self.title =LocalizationKey(@"remarkmnemonic");
    self.tipsTitle.text = LocalizationKey(@"copymnemonic");
    self.tipsContent.text = LocalizationKey(@"copymnemonicTip");
    [self.nextStepBtn setTitle:LocalizationKey(@"next") forState:UIControlStateNormal];
}
-(void)setLeftButtonItem{
    UIButton * navBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    // 返回按钮的图片
    [navBack setImage:IMAGE(@"页面返回按钮_03") forState:UIControlStateNormal];
    // 设置按钮的对齐方式
    navBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 设置按钮的内边距（左侧贴近边缘）
    [navBack setImageEdgeInsets:UIEdgeInsetsMake(0, -spaceSize(5), 0, 0)];
    // 按钮添加点击事件
    [navBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    // 将按钮添加到导航栏上
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:navBack];
    self.navigationItem.leftBarButtonItem = left;
}
/**
 重写导航返回事件

 */
- (void)backClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalizationKey(@"warmTip") message:LocalizationKey(@"backWalletTips") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:action1];
     [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 中英文切换
 */
- (void)setRightBarButtonItem {
    UIButton *button = [[UIButton alloc] init];
    [button.titleLabel setFont:systemFont(15)];
    [button setTitle:@"English" forState:UIControlStateNormal];
    [button setTitleColor:barTitle forState:UIControlStateNormal];
    [button dn_addActionHandler:^{
        if([button.titleLabel.text isEqualToString:@"English"]) {
            [button setTitle:@"中文" forState:UIControlStateNormal];
            self.mnemonicView.mnemonicWord = self.englishArr;
            [self.mnemonicView reloadData];
        } else {
            [button setTitle:@"English" forState:UIControlStateNormal];
            self.mnemonicView.mnemonicWord = self.chineseArr;
            [self.mnemonicView reloadData];
        }
    }];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (IBAction)nextStep:(id)sender {
    ConfirmMnemonicController *confirmVc = [[ConfirmMnemonicController alloc] init];
    confirmVc.mnemonicWord= _mnemonicView.mnemonicWord;
    confirmVc.model=self.model;
    [self.navigationController pushViewController:confirmVc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
