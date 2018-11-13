//
//  AddressView.h
//  BiPay
//
//  Created by sunliang on 2018/8/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GetBackBlock)(NSString * text);
@interface AddressView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong) NSMutableArray*contentArray;
@property (nonatomic, strong) NSIndexPath *oldIndex;
@property (nonatomic, copy) GetBackBlock getBackBlock;
@property(nonatomic,strong)coinModel*coin;
+(AddressView *)instanceViewWithFrame:(CGRect)Rect withcontact:(contactsModel*)model;

@end
