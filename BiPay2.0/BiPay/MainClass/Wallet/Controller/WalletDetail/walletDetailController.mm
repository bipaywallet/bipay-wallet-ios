//
//  walletDetailController.m
//  BiPay
//
//  Created by sunliang on 2018/6/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "walletDetailController.h"
#import "ModifypwController.h"
#import "ZoomView.h"
#import "HBAlertPasswordView.h"
#import "privatekeyView.h"
#import "walletCell.h"
#import "AESCrypt.h"
#import "privatekeyController.h"
#import "TradeModel.h"
#import "TransferModel.h"
#import "changeModel.h"
@interface walletDetailController ()<HBAlertPasswordViewDelegate>
{
    privatekeyView*_keyStoreView;
}
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong) UITextField *alertTF;
@property(nonatomic,strong)NSArray*titleArray;
@property(nonatomic,strong)NSArray*contentArray;
@end

@implementation walletDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=self.wallet.name;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor = ViewBackColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"walletCell" bundle:nil] forCellReuseIdentifier:@"walletCell"];
    self.tableView.tableFooterView=[UIView new];
    self.tableView.rowHeight=55;
    self.tableView.separatorColor=lineColor;
    [self configData];
    // Do any additional setup after loading the view from its nib.
}

-(void)configData{
    if ([self isBlankString:self.wallet.tips]) {
        self.titleArray=[NSArray arrayWithObjects:LocalizationKey(@"changewalletName"),LocalizationKey(@"changePassword"),LocalizationKey(@"exportKey"), nil];
        self.contentArray=[NSArray arrayWithObjects:self.wallet.name,@"",@"", nil];
    }else{
        self.titleArray=[NSArray arrayWithObjects:LocalizationKey(@"changewalletName"),LocalizationKey(@"pswTip"),LocalizationKey(@"changePassword"),LocalizationKey(@"exportKey"), nil];
        self.contentArray=[NSArray arrayWithObjects:self.wallet.name,self.wallet.tips,@"",@"", nil];
    }
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    walletCell*cell=[tableView dequeueReusableCellWithIdentifier:@"walletCell"];
    cell.moreImageV.hidden=NO;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.titleLabel.text=self.titleArray[indexPath.row];
    cell.contentLabel.text=self.contentArray[indexPath.row];
    if ([cell.titleLabel.text isEqualToString:LocalizationKey(@"pswTip")]) {
        cell.moreImageV.hidden=YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        __weak walletDetailController*weakSelf=self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"pleaseImputPacketName") preferredStyle:UIAlertControllerStyleAlert];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *passwordTextField = alertController.textFields.firstObject;
            if ([NSString stringIsNull:passwordTextField.text]) {
                [self.view makeToast:LocalizationKey(@"pleaseImputPacketName") duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            NSArray*walletArray= [walletModel bg_findAll:nil];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ && bg_id!=%@", passwordTextField.text,self.wallet.bg_id];
            NSArray *filteredArray = [walletArray filteredArrayUsingPredicate:predicate];

            if (filteredArray.count>0) {
                [self.view makeToast:LocalizationKey(@"packetNameNoSame") duration:1.5 position:CSToastPositionCenter];
                return ;
            }
            self.navigationItem.title = passwordTextField.text;
            weakSelf.wallet.name=passwordTextField.text;
             [weakSelf.wallet bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:weakSelf.wallet.bg_id]]];
            if ([self.wallet.password isEqualToString:[UserinfoModel shareManage].wallet.password]) {
                [UserinfoModel shareManage].wallet=self.wallet;
            }
            [self configData];
            
        }]];
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            self.alertTF = textField;
            textField.borderStyle = UITextBorderStyleNone;
            textField.placeholder = LocalizationKey(@"pleaseImputPacketName");
            
        }];
        [self presentViewController:alertController animated:YES completion:^{
            
            [[self.alertTF superview] superview].backgroundColor = [UIColor clearColor];
        }];
        
    }
    
    if (indexPath.row==self.titleArray.count-2) {
        ModifypwController*modify=[[ModifypwController alloc]init] ;
        modify.wallet=self.wallet;
        [self.navigationController pushViewController:modify animated:YES];
    }
    else if (indexPath.row==self.titleArray.count-1)
    {
        privatekeyController*importKeyVC=[[privatekeyController alloc]init];
        importKeyVC.wallet=self.wallet;
        [self.navigationController pushViewController:importKeyVC animated:YES];

    }else{
        
    }
  
}

-(void)showKeystore:(NSString*)mastkey{
    if (!_keyStoreView) {
        _keyStoreView = [[NSBundle mainBundle] loadNibNamed:@"privatekeyView" owner:nil options:nil].firstObject;
        _keyStoreView.frame=[UIScreen mainScreen].bounds;
    }
    CGAffineTransform translates = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    _keyStoreView.boardView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,0,_keyStoreView.boardView.height);
    _keyStoreView.keyLabel.text=mastkey;//主私钥
    _keyStoreView.copybtn.backgroundColor=[UIColor colorWithRed:184/255.0 green:157/255.0 blue:113/255.0 alpha:1];
    _keyStoreView.copybtn.userInteractionEnabled=YES;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_keyStoreView.boardView.transform = translates;
        
    } completion:^(BOOL finished) {
        
    }];
     [UIApplication.sharedApplication.keyWindow addSubview:_keyStoreView];
    
}
#pragma mark - <HBAlertPasswordViewDelegate>
- (void)sureActionWithAlertPasswordView:(HBAlertPasswordView *)alertPasswordView password:(NSString *)password {
    [alertPasswordView removeFromSuperview];
    
        NSString*decryptStr=[AESCrypt decrypt:self.wallet.password password:password];;
        if (!decryptStr) {
            [self.view makeToast:LocalizationKey(@"pwdErro")  duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        __weak walletDetailController*weakSelf=self;
        [self addUIAlertControlWithString:LocalizationKey(@"deleteWalletTips") withActionBlock:^{
            [SVProgressHUD showWithStatus:LocalizationKey(@"deleting")];
            [walletModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:weakSelf.wallet.bg_id]]];
            [coinModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:weakSelf.wallet.bg_id]]];
            [TradeModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:weakSelf.wallet.bg_id]]];
            [TransferModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:weakSelf.wallet.bg_id]]];
            [changeModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"walletID"],[NSObject bg_sqlValue:weakSelf.wallet.bg_id]]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([[walletModel bg_findAll:nil] count]>0) {
                    [UserinfoModel shareManage].wallet=[[walletModel bg_findAll:nil] objectAtIndex:0];
                }else{
                    [UserinfoModel shareManage].wallet=nil;
                }
                [SVProgressHUD dismiss];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }andCancel:^{
            
        }];
}

//删除钱包
- (IBAction)deleteWallet:(UIButton *)sender {
    //密码框的View
    HBAlertPasswordView *alertPasswordView = [[HBAlertPasswordView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
    alertPasswordView.delegate = self;
    [APPLICATION.window addSubview:alertPasswordView];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.deleteBtn setTitle:LocalizationKey(@"deleteWallet") forState:UIControlStateNormal];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
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
