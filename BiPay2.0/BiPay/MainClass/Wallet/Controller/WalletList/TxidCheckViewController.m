//
//  TxidCheckViewController.m
//  BiPay
//
//  Created by sunliang on 2018/10/11.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "TxidCheckViewController.h"
#import <WebKit/WebKit.h>
#import "WYWebProgressLayer.h"
@interface TxidCheckViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView*webView;
@property (strong, nonatomic) WYWebProgressLayer *progressLayer;
@end

@implementation TxidCheckViewController
- (UIWebView *)webView   {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.scalesPageToFit=YES;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"Transactionquery");
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.webView.delegate=self;
    self.progressLayer=[WYWebProgressLayer layerWithFrame:CGRectMake(0, -1, kWindowW, 1)];
    [self.view.layer addSublayer:self.progressLayer];
    
    if (self.coin.fatherCoin) {
        //代币
        if ([self.coin.brand isEqualToString:@"USDT"]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://omniexplorer.info/tx/%@",self.txid]]]];
        }
        else{
            //ETH的代币
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://etherscan.io/tx/%@",self.txid]]]];
            
        }
        
    }else{
        //非代币
        if ([self.coin.brand isEqualToString:@"BTC"]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://btc.com/%@",self.txid]]]];
        }
        else if ([self.coin.brand isEqualToString:@"ETH"])
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://etherscan.io/tx/%@",self.txid]]]];
            
        }
        else if ([self.coin.brand isEqualToString:@"BCH"])
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://bch.btc.com/%@",self.txid]]]];
        
            
        }
        else if ([self.coin.brand isEqualToString:@"LTC"])
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://live.blockcypher.com/ltc/tx/%@",self.txid]]]];
            
        }
        else{
            
            
        }
    }

}

// 页面开始加载时调用
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progressLayer startLoad];
}

// 页面加载完成之后调用
- (void)webViewDidFinishLoad:(UIWebView *)webView{//这里修改导航栏的标题，动态改变
   // self.title = webView.title;
     [self.progressLayer finishedLoad];
}
// 页面加载失败时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progressLayer finishedLoad];
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
