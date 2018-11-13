//
//  SystemSettingController.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "SystemSettingController.h"
#import "SettingDetailController.h"

@interface SystemSettingController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray * titleArray;

@end

@implementation SystemSettingController
static NSString * identifier = @"cell";
#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.title = LocalizationKey(@"systemSetting");
    
    self.titleArray = @[LocalizationKey(@"selectCoin"),LocalizationKey(@"selectLanguage")];
//    self.titleArray = @[LocalizationKey(@"selectCoin")];
    [self setControlForSuper];
    [self addConstrainsForSuper];
    //MARK:--注册国际化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNotificaiton:) name:LanguageChange object:nil];
}
- (void)languageChangeNotificaiton:(NSNotification *)notification{
    [self.tableView reloadData];
    self.title = LocalizationKey(@"systemSetting");
    self.titleArray = @[LocalizationKey(@"selectCoin"),LocalizationKey(@"selectLanguage")];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
 
}
/**
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

#pragma mark -- UITableView Delegate && DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [NSString stringWithFormat:@"%ldcell",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = CellBackColor;
        cell.textLabel.textColor = barTitle;
        cell.detailTextLabel.textColor = barTitle;
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    if (indexPath.row == 0)
    {
        
        cell.detailTextLabel.text = [NSUserDefaultUtil GetDefaults:MoneyChange];
    }
    else if (indexPath.row == 1)
    {
        cell.detailTextLabel.text = [NSUserDefaultUtil GetDefaults:LanguageChange];
    }
    else
    {
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2)
    {
        
    }
    else
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        SettingDetailController * vc = [[SettingDetailController alloc]init];
        vc.baseStr = cell.textLabel.text;
        vc.selectItem = cell.detailTextLabel.text;
        // block 回调选择的结果，并在 cell 上显示
        vc.getBackBlock = ^(NSString *text) {
            
            cell.detailTextLabel.text = text;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
///===========================================================================
///                           行高
///===========================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableHeight;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = ViewBackColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorColor=lineColor;
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
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
#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter


@end
