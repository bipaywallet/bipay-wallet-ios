//
//  MessageDetailController.m
//  BiPay
//
//  Created by 褚青骎 on 2018/7/28.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MessageDetailController.h"
#import "MessageTitleCell.h"
#import "MessageTimeCell.h"
#import "MessageDetailCell.h"

@interface MessageDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    self.title =LocalizationKey(@"msgDetail");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ---tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 50;
            break;
            
        case 1:
            return 40;
            break;
            
        case 2:
            return UITableViewAutomaticDimension;
            break;
        
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 50;
            break;
            
        case 1:
            return 40;
            break;
            
        case 2:
            return 200;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            MessageTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTitleCell"];
            if(cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"MessageTitleCell" owner:nil options:nil].firstObject;
            }
            cell.title.text = @"这是一个标题";
            return cell;
        }
            break;
            
        case 1:{
            MessageTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTimeCell"];
            if(cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"MessageTimeCell" owner:nil options:nil].firstObject;
            }
            cell.time.text = @"2018-07-30 12:00:00";
            return cell;
        }
            break;
        
        case 2:{
            MessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageDetailCell"];
            if(cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"MessageDetailCell" owner:nil options:nil].firstObject;
            }
//            cell.detail.text = @"这是一个消息";
            return cell;
        }
            
        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
            
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCell"];
            }
            return cell;
        }
        break;
    }
}

@end
