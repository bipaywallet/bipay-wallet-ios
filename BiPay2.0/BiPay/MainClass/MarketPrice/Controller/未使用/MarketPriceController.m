//
//  MarketPriceController.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MarketPriceController.h"
#import <objc/runtime.h>
#import "MarketSearchController.h"
#import "CNScollPositionView.h"
#import "marketCell.h"
#import "KchatViewController.h"
#import "marketModel.h"


#define Scrolltag  10086
@interface MarketPriceController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ScollPositionDelegate>
{
    int _currentIndex;
}
@property(nonatomic)CNScollPositionView  *positionView;
@property(nonatomic)UIScrollView         *scroView;
@property(nonatomic,strong)NSArray*contentArray;
@property (weak, nonatomic) IBOutlet UILabel *assetNameLab;
@property (weak, nonatomic) IBOutlet UILabel *aNewsPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *zhangdieLab;
@end

@implementation MarketPriceController


#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setLeftBarBuutonItem];
    CNScollPositionView *postionView = [[CNScollPositionView alloc]init];
    //postionView.titlesArr = @[@"自选",@"OKEX",@"BINANCE",@"BITTREX",@"HUOBI"];
    postionView.titlesArr = @[@"HUOBI"];
    postionView.contentScrollView = self.scroView;
    postionView.delegate=self;
    postionView.backgroundColor = barColor;
    self.navigationItem.titleView=postionView;
    self.positionView = postionView;
    [self.view addSubview:self.scroView];
    [self addScroviewSubViews];
    [self getMarketPrice];
    _currentIndex=0;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.aNewsPriceLab.text = LocalizationKey(@"newPrice");
    self.zhangdieLab.text = LocalizationKey(@"applies");
    self.assetNameLab.text = LocalizationKey(@"assetName");
}

- (void)setLeftBarBuutonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(leftItemClick)];
}
-(void)addScroviewSubViews{
    for (int i = 0; i<self.positionView.titlesArr.count; i++) {
        UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(self.scroView.bounds.size.width*i, 0, self.scroView.bounds.size.width, self.scroView.bounds.size.height) style:UITableViewStylePlain];
        [tableView registerNib:[UINib nibWithNibName:@"marketCell" bundle:nil] forCellReuseIdentifier:@"marketCell"];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.tag=i+100;
        tableView.separatorColor=lineColor;
        tableView.rowHeight=60;
        tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [self.scroView addSubview:tableView];
    }
}
-(UIScrollView *)scroView{
    if (!_scroView ) {
        _scroView = [[UIScrollView alloc]init];
        _scroView.bounces = NO;
        _scroView.delegate =self;
        _scroView.pagingEnabled=YES;
        _scroView.tag=Scrolltag;
        _scroView.showsHorizontalScrollIndicator=NO;
        
    }
    return _scroView;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag==Scrolltag) {
        NSInteger   pageIndex = scrollView.contentOffset.x/self.scroView.bounds.size.width;
        NSLog(@"----%ld",(long)pageIndex);
        [self.positionView resetTitileViewState:pageIndex];
        self.positionView.titleContentView.scroll=NO;
        _currentIndex=(int)pageIndex ;
        [self getMarketPrice];
    }
   
}
-(void)viewWillLayoutSubviews{
    if (@available(iOS 11.0, *)) {
        self.positionView.frame = CGRectMake(0,self.view.safeAreaInsets.top, self.view.bounds.size.width, 30);
         self.scroView.frame = CGRectMake(0, self.positionView.frame.origin.y+self.positionView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.positionView.bounds.size.height-self.positionView.frame.origin.y);
    } else {
        self.positionView.frame = CGRectMake(0,0, self.view.bounds.size.width, 30);
         self.scroView.frame = CGRectMake(0, self.positionView.frame.origin.y+self.positionView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.positionView.bounds.size.height-self.positionView.frame.origin.y-49);
    }
   
    self.scroView.contentSize = CGSizeMake(self.view.bounds.size.width*self.positionView.titlesArr.count, 0);
    for (int  i = 0; i<self.scroView.subviews.count; i++) {
        UIView*view=self.scroView.subviews[i];
        if ([view isKindOfClass:[UITableView class]]) {
            view.frame=CGRectMake(self.scroView.bounds.size.width*i, 0, self.scroView.bounds.size.width, self.scroView.bounds.size.height);
        }
    }
}
-(void)leftItemClick{
    MarketSearchController *vc = [[MarketSearchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- target Methods

#pragma mark -- UITableView Delegate && DataSource


 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     marketModel*model=self.contentArray[indexPath.row];
     marketCell*cell=[tableView dequeueReusableCellWithIdentifier:@"marketCell"];
     cell.coinKind.text=self.positionView.titlesArr[tableView.tag-100];
     [cell configMode:model];
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
     return cell;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 60;
 }
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KchatViewController *klineVc = [[KchatViewController alloc] init];
    [self.navigationController pushViewController:klineVc animated:YES];
}
*/

- (void)selectedItemButton:(NSInteger)index{
    
    NSLog(@"选择了---%ld",(long)index);
    _currentIndex=(int)index;
    [self getMarketPrice];
}

/**
 火币数据
 */
-(void)getMarketPrice{
    [SVProgressHUD show];
    [RequestManager postRequestWithURLPath:@"http://www.qkljw.com/app/Kline/get_currency_data" withParamer:[[NSMutableDictionary alloc]init] completionHandler:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.contentArray = [marketModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        UITableView *tableView = (UITableView *)[self.scroView viewWithTag:(100+self->_currentIndex)];
        [tableView reloadData];
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        [SVProgressHUD dismiss];
        [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
    }];
    
}


#pragma mark -- other Deleget

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
