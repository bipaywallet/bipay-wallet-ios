//
//  LeftMenuViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+LeftSlide.h"
#import "RightSubCell.h"
#import "AppDelegate.h"
#import "HeadView.h"
#import "ContactController.h"
@interface LeftMenuViewController ()
{
    NSArray*_titleArray;
    NSArray*_detailArray;
    BOOL _isOpen;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (nonatomic, assign) BOOL updateFlag;//版本更新标记
@property (nonatomic, copy) NSString * downloadUrl;
@property (weak, nonatomic) IBOutlet UIView *rightBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widConstant;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateVersion];
    self.rightBarView.backgroundColor = ViewBackColor;
    self.tableView.tableFooterView=[UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeadViewsection"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RightSubCell" bundle:nil] forCellReuseIdentifier:@"RightSubCell"];
    self.tableView.separatorColor=lineColor;
    // 添加从左划入的功能
    [self initSlideFoundation];
    self.heightConstant.constant=SafeAreaTopHeight;
    _titleArray=[NSArray arrayWithObjects:LocalizationKey(@"Pursemanagement"),LocalizationKey(@"richscan"),LocalizationKey(@"contanctMan"),LocalizationKey(@"msgCenter"),LocalizationKey(@"selectCoin"),LocalizationKey(@"selectLanguage"),LocalizationKey(@"ShareApp"),LocalizationKey(@"sysSetting"),nil];
    _detailArray=[NSArray arrayWithObjects:LocalizationKey(@"helpCenter"),LocalizationKey(@"aboutUs"),LocalizationKey(@"versionUpdate"),nil];
    _isOpen=NO;
    //MARK:--注册国际化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNotificaiton:) name:LanguageChange object:nil];
    
}

- (void)languageChangeNotificaiton:(NSNotification *)notification{
     _titleArray=[NSArray arrayWithObjects:LocalizationKey(@"Pursemanagement"),LocalizationKey(@"richscan"),LocalizationKey(@"contanctMan"),LocalizationKey(@"msgCenter"),LocalizationKey(@"selectCoin"),LocalizationKey(@"selectLanguage"),LocalizationKey(@"ShareApp"),LocalizationKey(@"sysSetting"),nil];
    _detailArray=[NSArray arrayWithObjects:LocalizationKey(@"helpCenter"),LocalizationKey(@"aboutUs"),LocalizationKey(@"versionUpdate"),nil];
    [self.tableView reloadData];
  
}
#pragma mark--版本更新

-(void)updateVersion{
    __weak LeftMenuViewController*welkSelf=self;
    [RequestManager postRequestWithURLPath:@"http://om.xinhuokj.com/getway/api/cms/appInfo/findInfo" withParamer:[[NSMutableDictionary alloc]init] completionHandler:^(id responseObject) {
        NSDictionary*dic=responseObject[@"result"][@"ios"];
        // app当前版本
        NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        welkSelf.downloadUrl=dic[@"download"];
        if ([app_Version compare:dic[@"code"]] == NSOrderedSame ||[app_Version compare:dic[@"code"]] == NSOrderedDescending) {
            //不需要更新
            welkSelf.updateFlag = NO;
        }else{
            welkSelf.updateFlag = YES;
        }
        [self.tableView reloadData];
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        
    }];
   
    
}
//MARK:--国际化通知处理事件

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:YES];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==_titleArray.count-1) {
        if (_isOpen) {
            return _detailArray.count;
        }else{
            return 0;
        }
    }else{
      return 0;
    }
 
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RightSubCell * subcell = [tableView dequeueReusableCellWithIdentifier:@"RightSubCell" forIndexPath:indexPath];
    subcell.titleLab.text=_detailArray[indexPath.row];
    subcell.selectionStyle=UITableViewCellSelectionStyleNone;
    subcell.backgroundColor=[UIColor clearColor];
    if (_detailArray.count-1==indexPath.row) {
        if (_updateFlag) {
            subcell.alertLab.hidden = NO;
            
        }else{
            subcell.alertLab.hidden = YES;
        }
    }else{
        subcell.alertLab.hidden = YES;
    }
    return subcell;


}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeadViewsection"];
    view.backgroundColor = ViewBackColor;
    view.lineView.backgroundColor = lineColor;
    view.titleLabel.text=_titleArray[section];
    view.indexBtn.tag=section;
    [view.indexBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    if (section==_titleArray.count-1) {
        view.rowImage.hidden=NO;
        if (_isOpen) {
            view.rowImage.image=UIIMAGE(@"downRow");
        }
        else
        {
            view.rowImage.image=UIIMAGE(@"upRow");
        }
        
    }else{
        view.rowImage.hidden=YES;
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

/**
 点击事件
 */
-(void)clickEvent:(UIButton*)sender{
    if (sender.tag!=_titleArray.count-1) {
        [self hide];
        NSString*title=_titleArray[sender.tag];
        if (self.getBackBlock)
        {
            self.getBackBlock(title);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
      //系统设置
        
        _isOpen=!_isOpen;
        [self.tableView reloadData];
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString*title=_detailArray[indexPath.row];
    
    if ([title isEqualToString:LocalizationKey(@"versionUpdate")]) {
        //MARK:--点击版本更新
    
        if (_updateFlag) {
            NSURL *url = [NSURL URLWithString:self.downloadUrl];
            if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{}
                                                 completionHandler:^(BOOL success) {
                                                     NSLog(@"11Open %d",success);
                                                 }];
                    } else {
                        
                    }
                } else {
                    BOOL success = [[UIApplication sharedApplication] openURL:url];
                    NSLog(@"22Open  %d",success);
                }
                
            } else{
                bool can = [[UIApplication sharedApplication] canOpenURL:url];
                if(can){
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            [self hide];
        }else{
            [self.view makeToast:LocalizationKey(@"updated") duration:1.5 position:CSToastPositionCenter];
            return;
        }
    }else{
        [self hide];
        if (self.getBackBlock)
        {
            self.getBackBlock(title);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
    
}


#pragma mark -- show or hide
- (void)showFromLeft
{
    [self show];
}
- (IBAction)hideToLeft:(id)sender {
    [self hide];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
