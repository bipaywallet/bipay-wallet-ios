//
//  ChooseContactsController.m
//  BiPay
//
//  Created by sunliang on 2018/8/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ChooseContactsController.h"
#import "selectedCell.h"
#import "AddressView.h"
#import "BMChineseSort.h"
#import "AddContactController.h"
@interface ChooseContactsController ()
@property(nonatomic,strong) NSMutableArray *contentArray;
@property(nonatomic,strong) NSMutableArray *sectionArray;
@property (weak, nonatomic) IBOutlet UIButton *addContactBtn;
@end

@implementation ChooseContactsController
static NSString * identifier = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    self.title = LocalizationKey(@"selectContanct");
    [self.addContactBtn setTitle:LocalizationKey(@"addContanct") forState:UIControlStateNormal];
    [self.tableView registerNib:[UINib nibWithNibName:@"selectedCell" bundle:nil] forCellReuseIdentifier:identifier];
    self.tableView.tableFooterView=[UIView new];
    self.tableView.separatorColor=lineColor;
    self.tableView.rowHeight = 65;
    self.tableView.sectionIndexColor = ContanctLabBackColor;
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"nocontent" titleStr:LocalizationKey(@"noContanct")];
    self.tableView.ly_emptyView = emptyView;
//    [self setRightBarButtonItemtype];
}
- (IBAction)addContactClick:(id)sender {
    [self addClick];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [BMChineseSort sortAndGroup:[[ContactsDataBase sharedDataBase] getAllcontact] key:@"name" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        
        self.sectionArray = sectionTitleArr;
        self.contentArray = sortedObjArr;
        [self.tableView reloadData];
    }];
    self.contentArray = [[ContactsDataBase sharedDataBase] getAllcontact];
}




#pragma mark -- Private Methods

//- (void)setRightBarButtonItemtype
//{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"add_contact")
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self
//                                                                            action:@selector(addClick)];
//}
//添加联系人
-(void)addClick{
    AddContactController * vc = [[AddContactController alloc]init];
    vc.popType=0;
    [self.navigationController pushViewController:vc animated:YES];
    
}


//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    contactsModel*contact=self.contentArray[indexPath.section][indexPath.row];
    selectedCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configModel:contact];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    contactsModel*model=self.contentArray[indexPath.section][indexPath.row];
    
    AddressView*view=[AddressView instanceViewWithFrame:[UIScreen mainScreen].bounds withcontact:model];
    [view.cancelBtn setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
    [view.confirmBtn setTitle:LocalizationKey(@"confirm") forState:UIControlStateNormal];
    view.getBackBlock = ^(NSString *text) {
        if (self.getBackBlock)
        {
            self.getBackBlock(text);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    };
    [APPLICATION.window addSubview:view];
}

// 索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionArray;
}

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
