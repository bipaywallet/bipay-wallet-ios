//
//  AddContactController.h
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "BaseController.h"
#import "contactsModel.h"

typedef NS_ENUM(int, contactType) {
    AddContact,//添加联系人
    EditContact//编辑联系人
};
@interface AddContactController : BaseController
@property (nonatomic, strong) UITableView  * tableView;
@property(nonatomic,assign)contactType popType;  //0 添加联系人 ，1 编辑联系人
@property(nonatomic,strong)contactsModel*model;
@end
