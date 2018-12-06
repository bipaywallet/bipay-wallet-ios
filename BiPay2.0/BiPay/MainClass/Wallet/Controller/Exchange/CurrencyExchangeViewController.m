//
//  CurrencyExchangeViewController.m
//  BiPay
//
//  Created by sunliang on 2018/10/24.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "CurrencyExchangeViewController.h"
#import "confirmExchangeController.h"
#import "changellyView.h"
#import "changeHistoryController.h"
#import "changeSelectCell.h"
#import "changeModel.h"
#import "UIImageView+WebCache.h"
@interface CurrencyExchangeViewController ()<UITextFieldDelegate>
{
    changellyView*_boardView;
    BOOL _flag;//标示是否是搜索状态
    NSString*_minAmount;//最小卖出量
}
@property (weak, nonatomic) IBOutlet UITextField *inputTF;//得到的数量
@property (weak, nonatomic) IBOutlet UITextField *outputTF;//卖出数量
@property (weak, nonatomic) IBOutlet UILabel *coinRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *FeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *minNumLabel;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property(nonatomic,strong)UIButton*defaultBtn;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (nonatomic, strong) NSMutableArray * coinArray;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fromImageV;
@property (weak, nonatomic) IBOutlet UIImageView *toImageV;
@property (weak, nonatomic) IBOutlet UILabel *basicFromLabel;
@property (weak, nonatomic) IBOutlet UIImageView *basicFromImageV;
@property (weak, nonatomic) IBOutlet UILabel *basicToLabel;
@property (weak, nonatomic) IBOutlet UIImageView *baiscToImageV;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property(nonatomic,strong)NSMutableArray *searchArr;
@property(nonatomic,strong)NSMutableArray *saveArr;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorOut;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorIn;
@property (weak, nonatomic) IBOutlet UILabel *sellLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end

@implementation CurrencyExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=LocalizationKey(@"exchange");
    self.searchArr=[[NSMutableArray alloc]init];
    self.view.backgroundColor =ViewBackColor;
    self.inputTF.delegate=self;
    self.outputTF.delegate=self;
    self.searchTF.delegate=self;
    [self setRightBarBuutonItem];
    [self.inputTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.outputTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.menuView.hidden=YES;
    self.menuView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.tableView.tableFooterView=[UIView new];
    self.tableView.rowHeight=70;
    [self.tableView registerNib:[UINib nibWithNibName:@"changeSelectCell" bundle:nil] forCellReuseIdentifier:@"changeSelectCell"];
    self.FeeLabel.text=[NSString stringWithFormat:@"%@(0.5%%) ≈%.8f %@",LocalizationKey(@"serviceCharge"),[self.inputTF.text doubleValue]*5/1000,self.toLabel.text];
    self.indicatorOut.hidden=YES;
    self.indicatorIn.hidden=YES;
    [self getCurrenciesFull];
    [self getMinAmount:self.basicFromLabel.text withto:self.basicToLabel.text];
    [self getExchangeAmount:self.basicFromLabel.text withto:self.basicToLabel.text withNum:@"1" withtype:2];
    self.buyLabel.text=LocalizationKey(@"buy");
    self.sellLabel.text=LocalizationKey(@"sell");
    self.inputTF.placeholder=LocalizationKey(@"quantity");
    self.outputTF.placeholder=LocalizationKey(@"quantity");
    self.searchTF.placeholder=LocalizationKey(@"search");
    [self.changeBtn setTitle:LocalizationKey(@"exchange") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = ViewBackColor;
 
}
#pragma mark 右侧添加资产按钮
- (void)setRightBarBuutonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"record")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(rightItemClick)];
}
#pragma mark 右侧菜单按钮
- (void)rightItemClick
{
    
    [self.navigationController pushViewController:[[changeHistoryController alloc]init] animated:YES];
}
/**
 交换币种
 
 */
- (IBAction)currencyExchange:(UIButton *)sender {
    UIImage*basicimage=self.fromImageV.image;
    NSString*basicStr=self.fromLabel.text;
    self.basicFromImageV.image=self.toImageV.image;
    self.basicFromLabel.text=self.toLabel.text;
    self.fromImageV.image=self.toImageV.image;
    self.fromLabel.text=self.toLabel.text;
    self.baiscToImageV.image=basicimage;
    self.basicToLabel.text=basicStr;
    self.toImageV.image=basicimage;
    self.toLabel.text=basicStr;
    self.inputTF.text=@"";
    self.outputTF.text=@"";
    self.inputTF.placeholder=LocalizationKey(@"quantity");
    self.outputTF.placeholder=LocalizationKey(@"quantity");
    self.FeeLabel.text=[NSString stringWithFormat:@"%@(0.5%%) ≈%.8f %@",LocalizationKey(@"serviceCharge"),[self.inputTF.text doubleValue]*5/1000,self.toLabel.text];
    [self getExchangeAmount:self.basicFromLabel.text withto:self.basicToLabel.text withNum:@"1" withtype:2];
    [self getMinAmount:self.basicFromLabel.text withto:self.basicToLabel.text];//最小卖出量
}


/**
 显示menu菜单

 */
- (IBAction)selectedView:(UIButton *)sender {
    
    self.menuView.hidden=NO;
    int tag=(int)sender.tag;
    UIButton *selectBtn = (UIButton *)[self.btnView viewWithTag:tag];
    [selectBtn setBackgroundImage:UIIMAGE(@"BtnView1") forState:UIControlStateNormal];
    self.defaultBtn=selectBtn;
    for (UIView* subview in self.btnView .subviews)
    {
        if ([subview isKindOfClass:[UIButton class]]&&subview.tag!=tag) {
            [(UIButton*)subview setBackgroundImage:UIIMAGE(@"BtnView2") forState:UIControlStateNormal];
        }
    }
    [self.tableView reloadData];
}

/**
 关闭menu菜单

 */
- (IBAction)closeView:(UIButton *)sender {
    self.menuView.hidden=YES;
    
}


/**
 选择币种
 
 */
- (IBAction)selectCoin:(UIButton *)sender {
    
    [self.defaultBtn setBackgroundImage:UIIMAGE(@"BtnView2") forState:UIControlStateNormal];
    [sender setBackgroundImage:UIIMAGE(@"BtnView1") forState:UIControlStateNormal];
    self.defaultBtn=sender;
    [self.tableView reloadData];
}


/**
 弹出提示视图

 */
- (IBAction)popView:(id)sender {
   
    if (!_boardView) {
        _boardView = [[NSBundle mainBundle] loadNibNamed:@"changellyView" owner:nil options:nil].firstObject;
        _boardView.frame=[UIScreen mainScreen].bounds;
        _boardView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
        _boardView.titleLabel.text=LocalizationKey(@"changeinfo");
    }
   
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    _boardView.transform= CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    _boardView.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_boardView.transform = transform;
        self->_boardView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    [UIApplication.sharedApplication.keyWindow addSubview:_boardView];

}

#pragma mark--确定兑换按钮
- (IBAction)exchangeClick:(id)sender {
    
    if (self.outputTF.editing||self.inputTF.editing) {
        [self.view endEditing:YES];
        return;
    }
   
    if ([self.fromLabel.text isEqualToString:self.toLabel.text]) {
        [self.view makeToast:LocalizationKey(@"between") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.outputTF.text doubleValue]<[_minAmount doubleValue]) {
         [self.view makeToast:LocalizationKey(@"minimumselling") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    NSMutableArray*dataArray=(NSMutableArray*) [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id]]];
    coinModel*fromModel;
    coinModel*toModel;
    for (coinModel*coin in dataArray) {
        if ([coin.brand isEqualToString:self.fromLabel.text]) {
            fromModel=coin;
        }else if ([coin.brand isEqualToString:self.toLabel.text]) {
            toModel=coin;
        }else{
            
        }
    }
#warning
    
    if ([fromModel.totalAmount doubleValue]<[self.outputTF.text doubleValue]) {
        [self.view makeToast:LocalizationKey(@"balancelack") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    confirmExchangeController*confirmVC=[[confirmExchangeController alloc]init];
    confirmVC.fromCoinModel=fromModel;
    confirmVC.toCoinModel=toModel;
    confirmVC.fromValue=self.outputTF.text;
    confirmVC.toValue=self.inputTF.text;
    confirmVC.rate=self.coinRateLabel.text;
    [self.navigationController pushViewController:confirmVC animated:YES];
}
/**
 实时监听文字内容变化
 
 */
- (IBAction)textFieldChangede:(UITextField *)sender {
    if (sender.tag==0) {//卖出
        self.indicatorOut.hidden=YES;
        self.indicatorIn.hidden=NO;
        self.inputTF.text=@"";
        self.inputTF.placeholder=@"";
         [self getExchangeAmount:self.basicFromLabel.text withto:self.basicToLabel.text withNum:sender.text withtype:0];
    }
    else{  //买入
        self.indicatorOut.hidden=NO;
        self.indicatorIn.hidden=YES;
        self.outputTF.text=@"";
        self.outputTF.placeholder=@"";
        [self getExchangeAmount:self.basicToLabel.text withto:self.basicFromLabel.text withNum:sender.text withtype:1];
    }
   
}
/**
 搜索框
 
 */
- (IBAction)changeing:(UITextField *)sender {
    [self.searchArr removeAllObjects];
   
    if ([sender.text isEqualToString:@""]) {
        _flag=NO;
        [self.tableView reloadData];
    }else{
        _flag=YES;
        NSString*searchStr= [sender.text lowercaseString];
        for (changeModel *model in self.coinArray) {
            if ([model.name containsString:searchStr]) {
                [self.searchArr addObject:model];
            }
        }
        
        [self.tableView reloadData];
    }
}


/**
 获取支持的兑换币种
 */
-(void)getCurrenciesFull{
    [SVProgressHUD showWithStatus:LocalizationKey(@"Currencyquery")];
    // 请求参数字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"Bipay" forKey:@"id"];
    [params setValue:@"2.0" forKey:@"jsonrpc"];
    [params setValue:@"getCurrenciesFull" forKey:@"method"];
    [RequestManager postRequestWithURLPath:ChangellyHOST withParamer:params completionHandler:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSMutableArray*localArray=(NSMutableArray*) [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[UserinfoModel shareManage].wallet.bg_id]]];
        NSArray*dataArray=[changeModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
        self.coinArray=[[NSMutableArray alloc]init];
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            changeModel*model=dataArray[idx];
            [localArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                coinModel*coin=localArray[idx];
                if ([[model.name uppercaseString] isEqualToString:coin.brand]) {
                    [self.coinArray addObject:model];
                }
            }];
        }];
        [self.tableView reloadData];
        self.saveArr=self.coinArray;
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        [SVProgressHUD dismiss];
        [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
    }];
   
}


/**
 兑换量
 */
-(void)getExchangeAmount:(NSString*)from withto:(NSString*)to withNum:(NSString*)num withtype:(int)tag{
    [SVProgressHUD show];
    if (tag==0) {
        [self.indicatorIn startAnimating];
        self.inputTF.enabled=NO;
    }else  if (tag==1) {
         [self.indicatorOut startAnimating];
         self.outputTF.enabled=NO;
    }else{
        
    }
   
    // 请求参数字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"Bipay" forKey:@"id"];
    [params setValue:@"2.0" forKey:@"jsonrpc"];
    [params setValue:@"getExchangeAmount" forKey:@"method"];
    [params setValue:@{@"from":from,@"to":to,@"amount":num} forKey:@"params"];
    
    [RequestManager postRequestWithURLPath:ChangellyHOST withParamer:params completionHandler:^(id responseObject) {
        [SVProgressHUD dismiss];
        if (tag==0) {
            [self.indicatorIn stopAnimating];
            self.indicatorIn.hidden=YES;
            self.inputTF.text=[NSString stringWithFormat:@"%.8f", [responseObject[@"result"] doubleValue]];
            self.inputTF.enabled=YES;
            if ([self.outputTF.text doubleValue]>0) {
                self.coinRateLabel.text=[NSString stringWithFormat:@"%@ 1 %@ ≈ %.8f %@",LocalizationKey(@"exchangeRate"),self.fromLabel.text,[self.inputTF.text doubleValue]/[self.outputTF.text doubleValue],self.toLabel.text];
            }else{
                
            }
            
        }else  if (tag==1) {
            [self.indicatorOut stopAnimating];
            self.indicatorOut.hidden=YES;
            self.outputTF.text=[NSString stringWithFormat:@"%.8f", [responseObject[@"result"] doubleValue]];
            self.outputTF.enabled=YES;
            if ([self.outputTF.text doubleValue]>0) {
                self.coinRateLabel.text=[NSString stringWithFormat:@"%@ 1 %@ ≈ %.8f %@",LocalizationKey(@"exchangeRate"),self.fromLabel.text,[self.inputTF.text doubleValue]/[self.outputTF.text doubleValue],self.toLabel.text];
            }
            
        }else{
            self.coinRateLabel.text=[NSString stringWithFormat:@"%@ 1 %@ ≈ %.8f %@",LocalizationKey(@"exchangeRate"),self.fromLabel.text,[responseObject[@"result"] doubleValue],self.toLabel.text];
        }
        
        self.FeeLabel.text=[NSString stringWithFormat:@"%@(0.5%%) ≈%.8f %@",LocalizationKey(@"serviceCharge"),[self.inputTF.text doubleValue]*5/1000,self.toLabel.text];
        
        if ([from isEqualToString:to]) {//同币种
            self.coinRateLabel.text=[NSString stringWithFormat:@"%@ 1 %@ ≈ %.8f %@",LocalizationKey(@"exchangeRate"),self.fromLabel.text,1.00000000,self.toLabel.text];
        }
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        [SVProgressHUD dismiss];
        if (tag==0) {
            [self.indicatorIn stopAnimating];
            self.indicatorIn.hidden=YES;
            self.inputTF.enabled=YES;
        }else  if (tag==1) {
            [self.indicatorOut stopAnimating];
            self.indicatorOut.hidden=YES;
            self.outputTF.enabled=YES;
        }else{
            
        }
        [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
    }];
  
  
}

/**
 获取最小卖出量
 */
-(void)getMinAmount:(NSString*)from withto:(NSString*)to{
    
    // 请求参数字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"Bipay" forKey:@"id"];
    [params setValue:@"2.0" forKey:@"jsonrpc"];
    [params setValue:@"getMinAmount" forKey:@"method"];
    [params setValue:@{@"from":from,@"to":to} forKey:@"params"];
    [RequestManager postRequestWithURLPath:ChangellyHOST withParamer:params completionHandler:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.minNumLabel.text=[NSString stringWithFormat:@"%@%@：%@",self.fromLabel.text,LocalizationKey(@"minimum"),responseObject[@"result"]];
        self->_minAmount=responseObject[@"result"];
        if ([from isEqualToString:to]) {//同币种
            self.minNumLabel.text=[NSString stringWithFormat:@"%@%@：%@",self.fromLabel.text,LocalizationKey(@"minimum"),@"0.00000000"];
            self->_minAmount=@"0.00000000";
        }
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        [SVProgressHUD dismiss];
        [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
    }];
   
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_flag) {
        return self.searchArr.count;
    }else{
        return self.coinArray.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    changeSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"changeSelectCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (_flag) {
        [cell configModel:self.searchArr[indexPath.row] withButton:self.defaultBtn withFrom:self.fromLabel.text withTo:self.toLabel.text];
    }else{
      [cell configModel:self.coinArray[indexPath.row] withButton:self.defaultBtn withFrom:self.fromLabel.text withTo:self.toLabel.text];
    }
    
   
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    changeModel*model;
    if (_flag) {
      model =self.searchArr[indexPath.row];
    }else{
        model =self.coinArray[indexPath.row];
    }
    if (self.defaultBtn.tag==1) {
     
        self.fromImageV.image=UIIMAGE([model.name uppercaseString]);
        self.fromLabel.text=[model.name uppercaseString];
        self.basicFromImageV.image=UIIMAGE([model.name uppercaseString]);
        self.basicFromLabel.text=[model.name uppercaseString];
    }else{
       
        self.toImageV.image=UIIMAGE([model.name uppercaseString]);
        self.toLabel.text=[model.name uppercaseString];
        self.baiscToImageV.image=UIIMAGE([model.name uppercaseString]);
        self.basicToLabel.text=[model.name uppercaseString];
    }
    self.menuView.hidden=YES;
    self.inputTF.text=@"";
    self.outputTF.text=@"";
    self.inputTF.placeholder=LocalizationKey(@"quantity");
    self.outputTF.placeholder=LocalizationKey(@"quantity");
    [self getExchangeAmount:self.basicFromLabel.text withto:self.basicToLabel.text withNum:@"1" withtype:2];//汇率
    [self getMinAmount:self.basicFromLabel.text withto:self.basicToLabel.text];//最小卖出量
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
