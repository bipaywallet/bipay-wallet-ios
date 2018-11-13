//
//  AddAssetsController.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "AddAssetsController.h"
#import "AddMoneyCell.h"
#import "UIButton+indexPath.h"
@interface AddAssetsController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSArray*modelArray;
@property(nonatomic,strong)NSMutableArray*section1Array;
@property(nonatomic,strong)NSMutableArray*section2Array;
@end

@implementation AddAssetsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=LocalizationKey(@"addProperty");
    self.view.backgroundColor = ViewBackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"AddMoneyCell" bundle:nil] forCellReuseIdentifier:@"AddMoneyCell"];
    self.modelArray=[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.wallet.bg_id]]];
    self.section1Array = [NSMutableArray array];
    self.section2Array = [NSMutableArray array];
    //MARK:--分组
    for (coinModel *model in self.modelArray) {
        if ([model.fatherCoin isEqualToString:@"ETH"]) {
            [self.section2Array addObject:model];
        }else{
            [self.section1Array addObject:model];
        }
    }
    
    
    
}
#pragma mark -tablviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.section2Array.count>0) {
       return 2;
    }
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.section1Array.count;
    }else{
        return self.section2Array.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    coinModel*model=nil;
    if (indexPath.section == 0) {
        model=self.section1Array[indexPath.row];
    }else{
        model=self.section2Array[indexPath.row];
    }
    
    AddMoneyCell*cell=[tableView dequeueReusableCellWithIdentifier:@"AddMoneyCell" forIndexPath:indexPath];
    cell.switchBtn.tag=indexPath.row;
    cell.switchBtn.indexPath = indexPath;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.nameLabel.text=model.brand;
    [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    if (model.collect==0) {
        cell.switchBtn.selected=NO;
        [cell.switchBtn setBackgroundImage:[UIImage imageNamed:@"switchOff"] forState:UIControlStateNormal];
    }else{
        cell.switchBtn.selected=YES;
        [cell.switchBtn setBackgroundImage:[UIImage imageNamed:@"switchOn"] forState:UIControlStateNormal];

    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0.0,SCREEN_WIDTH,30)];
    headView.backgroundColor = ViewBackColor;
    
    UILabel *label = [[UILabel alloc] init];
    
    if (section==0) {
        
        return headView;
    }
    
    label.frame = CGRectMake(12,3,SCREEN_WIDTH - 30,24);
    label.textColor = [ToolUtil colorWithHexString:@"#b4b5ba"];;
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = LocalizationKey(@"Etherenm");
    
    [headView addSubview:label];
    
    
    
    return headView;
}

/**
 添加币种
 */
-(void)switchAction:(UIButton*)sender{
    NSIndexPath *indexPath = sender.indexPath;
    coinModel*coin=nil;
    if (indexPath.section == 0) {
        coin=self.section1Array[indexPath.row];
    }else{
        coin=self.section2Array[indexPath.row];
    }
    coin.collect=!coin.collect;
    coin.addtime=[self getNowTimeTimestamp];
    [coin bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:self.wallet.bg_id],[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:coin.bg_id]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:AddAssets object:nil];
    [self.tableView reloadData];
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
