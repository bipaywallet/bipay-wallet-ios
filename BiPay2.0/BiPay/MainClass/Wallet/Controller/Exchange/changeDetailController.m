//
//  changeDetailController.m
//  BiPay
//
//  Created by sunliang on 2018/10/25.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "changeDetailController.h"
#import "changellyDetailCell.h"
#import "changellyHeaderView.h"
@interface changeDetailController ()

@property(nonatomic,strong)changellyHeaderView*headerView;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * detailArray;

@end

@implementation changeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleView];
    [self headRefreshWithScrollerView:self.tableView];
    self.tableView.backgroundColor =ViewBackColor;
    self.tableView.tableFooterView=[UIView new];
    self.tableView.rowHeight=60;
    [self.tableView registerNib:[UINib nibWithNibName:@"changellyDetailCell" bundle:nil] forCellReuseIdentifier:@"changellyDetailCell"];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.0];
    [self configData];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}
-(void)settitleView{
    // 创建一个富文本
    UILabel*titlelabel=[[UILabel alloc]init];
    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",self.model.fromCoin]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"changeRow"];
    attch.bounds = CGRectMake(0, 0, 29/1.2,14/1.2);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string]; //在文字后面添加图片
    NSAttributedString*str1=[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",self.model.toCoin]];
    [attri appendAttributedString:str1];
    titlelabel.attributedText = attri;
    titlelabel.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titlelabel;
}
-(void)configData{
    NSString*status;
    if ([self.model.status intValue]==0) {
        status=LocalizationKey(@"waitConfirm");
    }else if ([self.model.status intValue]==1)
    {
        status=LocalizationKey(@"Inexchange");
    }
    else if ([self.model.status intValue]==2)
    {
        status=LocalizationKey(@"waitConfirm");
    }
    else if ([self.model.status intValue]==3)
    {
        status=LocalizationKey(@"Exchangesuccess");
    }else{
        status=LocalizationKey(@"Exchangefail");
    }
    self.titleArray = @[LocalizationKey(@"Sendaddress"),LocalizationKey(@"Receivingaddress"),LocalizationKey(@"Typetransaction"),LocalizationKey(@"exchangeRate"),LocalizationKey(@"dealTime"),@"ID"];
    self.detailArray = @[self.model.fromAddress,self.model.toAddress,@"EXchange",[self getsingleRate:self.model.rate WithTocoin:self.model.toCoin],self.model.time,self.model.txid];
    [self.tableView reloadData];
}
-(NSString*)getsingleRate:(NSString*)rate WithTocoin:(NSString*)tocoin{
    NSArray *array = [rate componentsSeparatedByString:@"≈"];
    NSMutableString* str=[[NSMutableString alloc]initWithString:[array lastObject]];
    NSRange ange={1,str.length-1-tocoin.length};
    NSString* lastStr=[str substringWithRange:ange];
    return lastStr;
}

-(void)delayMethod{
    self.headerView=[changellyHeaderView instancesectionHeaderViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
    self.headerView.fromLabel.text=self.model.fromAmount;
    self.headerView.toLabel.text=self.model.toAmount;
    self.tableView.tableHeaderView=self.headerView;
    //配置数据
     [self.headerView setProgressWithLevel:[self.model.status intValue] WithfromCoin:[NSString stringWithFormat:@"%@ %@",self.model.fromAmount,self.model.fromCoin] WithToCoin:[NSString stringWithFormat:@"%@ %@",self.model.toAmount,self.model.toCoin]];
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    changellyDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"changellyDetailCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.titleLabel.text=self.titleArray[indexPath.row];
    cell.detailLabel.text=self.detailArray[indexPath.row];
    
    return cell;
    
}

-(void)setLagerForView:(UIView*)view{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.frame;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0||indexPath.row==1||indexPath.row==5)  {
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:self.detailArray[indexPath.row]];
        if (pab == nil) {
            [self.view makeToast:LocalizationKey(@"copyFail") duration:1.5 position:CSToastPositionCenter];
        }else
        {
            [self.view makeToast:LocalizationKey(@"copySuccess") duration:1.5 position:CSToastPositionCenter];
        }
    }
    else{
        
        
    }
    
    
    
}
#pragma mark--下拉刷新
-(void)refreshHeaderAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });

    [self getStatus];
}

/**
 刷新兑币进度状态
 */
-(void)getStatus{
    [SVProgressHUD show];
    // 请求参数字典
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"Bipay" forKey:@"id"];
    [params setValue:@"2.0" forKey:@"jsonrpc"];
    [params setValue:@"getStatus" forKey:@"method"];
    [params setValue:@{@"id":self.model.txid} forKey:@"params"];
    
    [RequestManager postRequestWithURLPath:ChangellyHOST withParamer:params completionHandler:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"result"] isEqualToString:@"confirming"]||[responseObject[@"result"] isEqualToString:@"waiting"]) {
            [self.headerView setProgressWithLevel:0 WithfromCoin:[NSString stringWithFormat:@"%@ %@",self.model.fromAmount,self.model.fromCoin] WithToCoin:[NSString stringWithFormat:@"%@ %@",self.model.toAmount,self.model.toCoin]];
            self.model.status=@"0";
            [self.model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:self.model.bg_id]]];
            
        }else if ([responseObject[@"result"] isEqualToString:@"exchanging"]) {
            [self.headerView setProgressWithLevel:1 WithfromCoin:[NSString stringWithFormat:@"%@ %@",self.model.fromAmount,self.model.fromCoin] WithToCoin:[NSString stringWithFormat:@"%@ %@",self.model.toAmount,self.model.toCoin]];
            self.model.status=@"1";
            [self.model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:self.model.bg_id]]];
        }
        else if ([responseObject[@"result"] isEqualToString:@"sending"]) {
            [self.headerView setProgressWithLevel:2 WithfromCoin:[NSString stringWithFormat:@"%@ %@",self.model.fromAmount,self.model.fromCoin] WithToCoin:[NSString stringWithFormat:@"%@ %@",self.model.toAmount,self.model.toCoin]];
            self.model.status=@"2";
            [self.model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:self.model.bg_id]]];
        }
        else if ([responseObject[@"result"] isEqualToString:@"finished"]) {
            [self.headerView setProgressWithLevel:3 WithfromCoin:[NSString stringWithFormat:@"%@ %@",self.model.fromAmount,self.model.fromCoin] WithToCoin:[NSString stringWithFormat:@"%@ %@",self.model.toAmount,self.model.toCoin]];
            self.model.status=@"3";
            [self.model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:self.model.bg_id]]];
            
            
        }else{
            [self.headerView setProgressWithLevel:4 WithfromCoin:[NSString stringWithFormat:@"%@ %@",self.model.fromAmount,self.model.fromCoin] WithToCoin:[NSString stringWithFormat:@"%@ %@",self.model.toAmount,self.model.toCoin]];
            self.model.status=@"4";
            [self.model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:self.model.bg_id]]];
            
        }
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        [SVProgressHUD dismiss];
        [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
    }];
   
}


-(void)dealloc{
    
    
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
