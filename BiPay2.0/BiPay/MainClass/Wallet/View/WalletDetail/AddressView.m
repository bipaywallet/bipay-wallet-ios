//
//  AddressView.m
//  BiPay
//
//  Created by sunliang on 2018/8/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "AddressView.h"
#import "DetailSeletedCell.h"
@implementation AddressView
static NSString * identifier = @"cell";

-(void)awakeFromNib{
    
    [super awakeFromNib];
    [self.confirmBtn setTitleColor:[ToolUtil colorWithHexString:@"#0398fe"] forState:UIControlStateNormal];
    
}
+(AddressView *)instanceViewWithFrame:(CGRect)Rect withcontact:(contactsModel*)model{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddressView" owner:nil options:nil];
    AddressView*View=[nibView objectAtIndex:0];
    View.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    View.frame=Rect;
    [View configModel:model];
    return View;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    coinModel*coin=self.contentArray[indexPath.row];
    DetailSeletedCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressLabel.text=[NSString stringWithFormat:@"%@:%@",coin.brand,coin.address];
    [cell.checkBtn setBackgroundImage:IMAGE(@"cellUnselected") forState:UIControlStateNormal];
    if (indexPath==_oldIndex) {
         [cell.checkBtn setBackgroundImage:IMAGE(@"cellSelected") forState:UIControlStateNormal];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_oldIndex != nil) {
        DetailSeletedCell *oldCell = [tableView cellForRowAtIndexPath:self.oldIndex];
       [oldCell.checkBtn setBackgroundImage:IMAGE(@"cellUnselected") forState:UIControlStateNormal];
    }
    coinModel*model=self.contentArray[indexPath.row];
    
    DetailSeletedCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.checkBtn setBackgroundImage:IMAGE(@"cellSelected") forState:UIControlStateNormal];
     _oldIndex = indexPath;
    self.coin=model;
}

-(void)configModel:(contactsModel*)model{
//    self.tableview.backgroundColor = CellBackColor;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorColor=[UIColor groupTableViewBackgroundColor];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailSeletedCell" bundle:nil] forCellReuseIdentifier:identifier];
    self.tableview.rowHeight=45;
    self.tableview.tableFooterView=[UIView new];
    self.namelabel.text=model.name;
    self.contentArray=[[ContactsDataBase sharedDataBase] getAllCoinsFromContact:model];
    [self.tableview reloadData];
    
}

- (IBAction)toucheEvent:(UIButton *)sender {
    if (sender.tag==1) {
    //确定
        if (!self.coin) {
             [self makeToast:LocalizationKey(@"pleaseSelectTransferAddress") duration:1.5 position:CSToastPositionCenter];
            return;
        }
        if (self.getBackBlock)
        {
            [self removeFromSuperview];
            self.getBackBlock(self.coin.address);
        }
    }else{
        [self removeFromSuperview];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
