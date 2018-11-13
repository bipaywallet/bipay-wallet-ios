//
//  SettingDetailController.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "SettingDetailController.h"
#import "SelectItemCell.h"
#import "TabBarController.h"
@interface SettingDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSIndexPath *oldIndex;
@end

@implementation SettingDetailController
static NSString * identifier = @"cell";
#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ViewBackColor;
    self.title = self.baseStr;
   
    if ([self.baseStr isEqualToString:LocalizationKey(@"selectLanguage")])
    {
        self.titleArray = @[@"简体中文",@"English"];
        self.selectItem=[NSUserDefaultUtil GetDefaults:LanguageChange];
    }
    else
    {
        self.titleArray = @[@"CNY",@"USD"];
         self.selectItem=[NSUserDefaultUtil GetDefaults:MoneyChange];
    }
    [self setControlForSuper];
    [self addConstrainsForSuper];
}

/**

- (void)viewWillAppear:(BOOL)animated {
[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
[super viewDidDisappear:animated];
}
*/


#pragma mark -- DidReceiveMemoryWarning
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- SetControlForSuper
- (void)setControlForSuper
{    
    [self.view addSubview:self.tableView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark -- Target Methods

#pragma mark -- Private Methods


- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = ViewBackColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.scrollEnabled = NO;
        _tableView.separatorColor=lineColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 60;
        
        if(@available(iOS 11.0,*)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SelectItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectItemCell"];
    if(cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SelectItemCell" owner:nil options:nil].firstObject;
    }
    cell.title.text = self.titleArray[indexPath.row];
    if([self.titleArray[indexPath.row] isEqualToString:self.selectItem]) {
        [cell.selectImg setHidden:NO];
        _oldIndex = indexPath;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(_oldIndex != nil) {
        SelectItemCell *oldCell = [tableView cellForRowAtIndexPath:self.oldIndex];
        [oldCell.selectImg setHidden:YES];
    }
    
    SelectItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectImg setHidden:NO];
    _oldIndex = indexPath;
    if ([self.baseStr isEqualToString:LocalizationKey(@"selectLanguage")]) {
        [NSUserDefaultUtil PutDefaults:LanguageChange Value:cell.title.text];
        if (indexPath.row==0) {
            [ChangeLanguage setUserlanguage:@"zh-Hans"];
            
        }else{
            [ChangeLanguage setUserlanguage:@"en"];
        }
        //MARK:--通过通知中心发送语言切换通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LanguageChange object:nil];
//        //底部tabbar更改语言
//  TabBarController*tabBarController = (TabBarController*)APPLICATION.window.rootViewController;
//        [tabBarController resettabarItemsTitle];
        
    }else{
        [NSUserDefaultUtil PutDefaults:MoneyChange Value:cell.title.text];
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}


/**
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
return <#height#>;
}
*/

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
