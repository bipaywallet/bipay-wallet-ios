//
//  webViewprotocolVC.m
//  BaseProject
//
//  Created by sunliang on 2017/9/4.
//  Copyright © 2017年 YLCai. All rights reserved.
//

#import "webViewprotocolVC.h"
#import "UIView+Toast.h"

@interface webViewprotocolVC ()<UIWebViewDelegate>
{
    UIWebView* _webView;
}
@property(nonatomic,strong)UITextView *textView;
@end

@implementation webViewprotocolVC
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(0, SafeAreaTopHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - SafeAreaTopHeight);
        _textView.editable=NO;
        [self.view addSubview:_textView];
        
    }
    return _textView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, SafeAreaTopHeight-20-14, 21, 21)];
    [backBtn setImage:[UIImage imageNamed:@"页面返回按钮_03"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SafeAreaTopHeight)];
    barView.backgroundColor = NavColor;
    [self.view addSubview:barView];
    [barView addSubview:backBtn];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, SafeAreaTopHeight-20-14, 200, 20)];
    titleLabel.text = _navTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = barTitle;
    [barView addSubview:titleLabel];
    self.textView.text = LocalizationKey(@"protocolContent");
    self.textView.textColor = barTitle;
    self.textView.backgroundColor = ViewBackColor;
}


- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
