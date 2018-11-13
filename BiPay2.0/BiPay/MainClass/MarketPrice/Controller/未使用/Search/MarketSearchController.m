//
//  MarketSearchController.m
//  BiPay
//
//  Created by 褚青骎 on 2018/7/3.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MarketSearchController.h"
#import "AddMoneyCell.h"
#import "MoneyListHead.h"

@interface MarketSearchController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MarketSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =LocalizationKey(@"addmarket");
    
    [self stepTableView];
    [self setSearchBarColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 初始化tableview时的设置
 */
- (void)stepTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor=lineColor;
    //去掉tableview自带分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 设置搜索框颜色与框线
 */
- (void)setSearchBarColor {
    //此处修改searchBar外部背景颜色
    self.searchBar.barTintColor = [UIColor whiteColor];
    
    //此处修改searchBar内部输入框的背景颜色
    UITextField * searchTextField = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    [searchTextField setBackgroundColor:lineColor];
    
    //此处去掉searchBar底部黑线
    [self.searchBar setBackgroundImage:[UIImage new]];
    
}

#pragma mark -tablviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MoneyListHead *head = [[[NSBundle mainBundle] loadNibNamed:@"MoneyListHead" owner:self options:nil] lastObject];
    head.title.text = [NSString stringWithFormat:@"这是第%ld个标题",section];
    return head;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMoneyCell"];
    if (cell == nil) {
        cell = (AddMoneyCell *)[[[NSBundle mainBundle]loadNibNamed:@"AddMoneyCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle= UITableViewCellSeparatorStyleNone;
    return cell;
}

@end
