//
//  ContactController.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ContactController.h"
#import "ContactViewCell.h"
#import "AddContactController.h"
#import "BMChineseSort.h"

@interface ContactController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton * addBtn;
@property(nonatomic,strong) NSMutableArray *contentArray;
@property(nonatomic,strong) NSMutableArray *sectionArray;
@end

@implementation ContactController
static NSString * identifier = @"cell";
#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizationKey(@"contanctMan");
    self.view.backgroundColor=ViewBackColor;
    [self setControlForSuper];
    [self addConstrainsForSuper];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.subviews
     enumerateObjectsUsingBlock:^(UIView
                                  *view, NSUInteger idx,
                                  BOOL *stop) {
         if ([[UIDevice currentDevice].systemVersion intValue]>=10){
             //iOS10,改变了导航栏的私有接口为_UIBarBackground
             if ([view
                  isKindOfClass:NSClassFromString(@"_UIBarBackground")])
             {
                 [view.subviews
                  lastObject].hidden = YES;
             }
             
         }else{
             //iOS10之前使用的是_UINavigationBarBackground
             if ([view
                  isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
             {
                 [view.subviews lastObject].hidden = YES;
             }
         }
         
     }];
    [self getAllData];
}

- (void)getAllData {
    
    [self.contentArray removeAllObjects];
    [self.sectionArray removeAllObjects];
    
    [BMChineseSort sortAndGroup:[[ContactsDataBase sharedDataBase] getAllcontact] key:@"name" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {

        self.sectionArray = sectionTitleArr;
        self.contentArray = sortedObjArr;

        [self.tableView reloadData];
    }];
}
/**
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


#pragma mark -- SetControlForSuper
- (void)setControlForSuper
{
    self.addBtn = [[UIButton alloc]init];
    [self.addBtn setTitle:LocalizationKey(@"addContanct") forState:UIControlStateNormal];
    self.addBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"btnBackground"] forState:UIControlStateNormal];
    // 点击事件
    DNWeak(self);
    [self.addBtn dn_addActionHandler:^{
        
        [weakself addContactClick];
    }];
    
    [self.tableView registerClass:[ContactViewCell class] forCellReuseIdentifier:@"contact"];
    
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.tableView];
}

#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.addBtn.mas_top).mas_offset(0);
    }];
}

#pragma mark -- Target Methods

- (void)addContactClick
{
    AddContactController * vc = [[AddContactController alloc]init];
    vc.popType=0;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- Private Methods

#pragma mark -- UITableView Delegate && DataSource

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self.sectionArray objectAtIndex:section];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10.0,
                                                            0.0,
                                                            320.0,
                                                            100.0)];
    view.backgroundColor = ViewBackColor;
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(12.0,
                             0.0,
                             100.0,
                             24.0);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = sectionTitle;
    label.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    return 24;
}

//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.contentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    contactsModel*contact = self.contentArray[indexPath.section][indexPath.row];
    ContactViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configModel:contact];
    return cell;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.rowHeight = 60;
        _tableView.separatorColor=lineColor;
        LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"nocontent" titleStr:LocalizationKey(@"noContanct")];
        _tableView.ly_emptyView = emptyView;
        _tableView.sectionIndexColor = ContanctLabBackColor;
        if(@available(iOS 11.0,*)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"ContactViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    contactsModel*contact=self.contentArray[indexPath.section][indexPath.row];
    AddContactController * vc = [[AddContactController alloc]init];
    vc.model=contact;
    vc.popType=1;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";//默认文字为 Delete
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    contactsModel*contact=self.contentArray[indexPath.section][indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [[ContactsDataBase sharedDataBase] deleteContact:contact];
        [[ContactsDataBase sharedDataBase] deleteAllCoinsFromContact:contact];
        
        
        [self getAllData];
    }
}

// 索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionArray;
}

#pragma mark -- DidReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
return <#height#>;
}
*/

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
