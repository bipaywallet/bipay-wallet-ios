//
//  KchatViewController.m
//  BiPay
//
//  Created by 褚青骎 on 2018/7/4.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "KchatViewController.h"

@interface KchatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *Collection;
- (IBAction)buy:(id)sender;
- (IBAction)sell:(id)sender;

@end

@implementation KchatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =LocalizationKey(@"marketDetail");
    [self stepTableView];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buy:(id)sender {
    
}

- (IBAction)sell:(id)sender {
    
}

- (void) stepTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor=lineColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KlineCell" bundle:nil] forCellReuseIdentifier:@"KlineCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KlineHeaderCell" bundle:nil] forCellReuseIdentifier:@"KlineHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DepthCell" bundle:nil] forCellReuseIdentifier:@"DepthCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TradeNumCell" bundle:nil] forCellReuseIdentifier:@"TradeNumCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DepthmapCell" bundle:nil] forCellReuseIdentifier:@"DepthmapCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    return cell;
}

@end
