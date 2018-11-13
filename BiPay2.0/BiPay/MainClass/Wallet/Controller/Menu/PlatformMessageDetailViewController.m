//
//  PlatformMessageDetailViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/3/21.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "PlatformMessageDetailViewController.h"

@interface PlatformMessageDetailViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation PlatformMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    self.navigationItem.title = self.navtitle;
    [self.view addSubview:[self webView]];
    // Do any additional setup after loading the view.
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-SafeAreaBottomHeight-SafeAreaTopHeight)];
        _webView.delegate = self;
        _webView.backgroundColor=ViewBackColor;
        [_webView scalesPageToFit];
        [_webView loadHTMLString:self.content baseURL:nil];
    }
    return _webView;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
 
    // 字体颜色
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'"];
    // 背景色
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#161835'"];

}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
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
