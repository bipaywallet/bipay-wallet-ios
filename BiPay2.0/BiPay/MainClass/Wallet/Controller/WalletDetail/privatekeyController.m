//
//  privatekeyController.m
//  BiPay
//
//  Created by sunliang on 2018/9/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "privatekeyController.h"
#import "HBAlertPasswordView.h"
#import "privatekeyView.h"
#import "AESCrypt.h"
@interface privatekeyController ()<HBAlertPasswordViewDelegate>
{
    privatekeyView*_keyStoreView;
}
@property (nonatomic, strong) NSMutableArray * coinArray;

@end

@implementation privatekeyController
-(NSMutableArray*)coinArray{
    if (_coinArray== nil) {
        _coinArray = [NSMutableArray array];
    }
    return _coinArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
   self.coinArray = (NSMutableArray*)[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.wallet.bg_id],[NSObject bg_sqlKey:@"collect"],[NSObject bg_sqlValue:@(1)]]];
    self.tableView.backgroundColor = ViewBackColor;
    self.tableView.tableFooterView=[UIView new];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorColor=ViewBackColor;
    UIEdgeInsets edge = UIEdgeInsetsMake(0,
                                         SCREEN_WIDTH*0.04,
                                         0,
                                         SCREEN_WIDTH*0.04);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view).insets(edge);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.navigationItem.title=LocalizationKey(@"exportKey");
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}
#pragma mark -- UITableView Delegate && DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.coinArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"help"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"help"];
        cell.backgroundColor = CellBackColor;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.layer.cornerRadius = 6.0f;
    cell.layer.masksToBounds = YES;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0) {
        cell.textLabel.text =LocalizationKey(@"mainPrivateKey");//主私钥
        
    }else{
        coinModel*model=self.coinArray[indexPath.section-1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",model.brand,LocalizationKey(@"privateKey")];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
                //密码框的View
                HBAlertPasswordView *alertPasswordView = [[HBAlertPasswordView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
                alertPasswordView.delegate = self;
                alertPasswordView.tag=100;
                [APPLICATION.window addSubview:alertPasswordView];
        
        
        
    }else{
        
        //密码框的View
        HBAlertPasswordView *alertPasswordView = [[HBAlertPasswordView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
        alertPasswordView.delegate = self;
        alertPasswordView.tag=indexPath.section;
        [APPLICATION.window addSubview:alertPasswordView];
    }
}


#pragma mark - <HBAlertPasswordViewDelegate>
- (void)sureActionWithAlertPasswordView:(HBAlertPasswordView *)alertPasswordView password:(NSString *)password {
    [alertPasswordView removeFromSuperview];
    NSString*decryptStr=[AESCrypt decrypt:self.wallet.password password:password];
    if (!decryptStr) {
        [self.view makeToast:LocalizationKey(@"pwdErro") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    if (alertPasswordView.tag==100) {
        //导出主私钥
        [self showKeystore:decryptStr withtitle: LocalizationKey(@"mainPrivateKey")];
    }else{
        
        coinModel*coin=self.coinArray[alertPasswordView.tag-1];
        NSString*wifiStr=[BiPayObject exportWalletWithPrivateKey:decryptStr coinType:coin.cointype Priveprefix:coin.Priveprefix];
        //导出私钥
        [self showKeystore:wifiStr withtitle:[NSString stringWithFormat:@"%@ %@",coin.brand,LocalizationKey(@"privateKey")]];
    }
}

-(void)showKeystore:(NSString*)mastkey withtitle:(NSString*)title{
    if (!_keyStoreView) {
        _keyStoreView = [[NSBundle mainBundle] loadNibNamed:@"privatekeyView" owner:nil options:nil].firstObject;
        _keyStoreView.frame=[UIScreen mainScreen].bounds;
    }
    [_keyStoreView.copybtn setTitle:LocalizationKey(@"copy") forState:UIControlStateNormal];
    _keyStoreView.alertContentLab.text = LocalizationKey(@"safetyWarning");
    CGAffineTransform translates = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    _keyStoreView.boardView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,0,_keyStoreView.boardView.height);
    _keyStoreView.keyLabel.text=mastkey;//主私钥
    _keyStoreView.titlelabel.text=title;
    [_keyStoreView.copybtn setBackgroundImage:[UIImage imageNamed:@"btnBackground"] forState:UIControlStateNormal];
    _keyStoreView.copybtn.userInteractionEnabled=YES;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_keyStoreView.boardView.transform = translates;
        
    } completion:^(BOOL finished) {
        
    }];
    [UIApplication.sharedApplication.keyWindow addSubview:_keyStoreView];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableHeight;
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
