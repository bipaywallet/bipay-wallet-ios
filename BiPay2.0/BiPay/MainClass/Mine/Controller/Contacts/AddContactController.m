//
//  AddContactController.m
//  BiPay
//
//  Created by zjs on 2018/6/19.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "AddContactController.h"
#import "AddContactViewCell.h"
#import "MMScanViewController.h"
#import "OptionalCell.h"
#import "HSGenderPickerVC.h"
#import "nameModel.h"
@interface AddContactController ()<UITableViewDelegate,UITableViewDataSource,HSGenderPickerVCDelegate,UITextFieldDelegate>
{
    NSIndexPath* _currentIndexPath;
}

@property (nonatomic, strong) UIButton       * saveBtn;
@property(nonatomic,strong)NSMutableArray*modelArray;//内容
@end

@implementation AddContactController
static NSString * identifier = @"cell";
#pragma mark -- LifeCycle

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

-(NSMutableArray*)modelArray{
    if (_modelArray == nil) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ViewBackColor;
    if (self.popType==AddContact) {
        self.title = LocalizationKey(@"createContanct");
        [self setRightBarButtonItemtype1];
        [self initModelArray];
    }else{
        self.title = LocalizationKey(@"editContanct");
        [self setRightBarButtonItemtype2];
        NSMutableArray*section1Array=[[NSMutableArray alloc]init];
        NSArray*coinArray=[[ContactsDataBase sharedDataBase] getAllCoinsFromContact:self.model];
        nameModel*model=[[nameModel alloc]init];
        model.content=self.model.name;
        model.placeholder=LocalizationKey(@"name");
        [section1Array addObject:model];
        for (int i=0; i<coinArray.count; i++) {
            coinModel*coin=coinArray[i];
            nameModel*model=[[nameModel alloc]init];
            model.content=coin.address;
            model.btnTitle=coin.brand;
            [section1Array addObject:model];
        }
        NSMutableArray*section2Array=[[NSMutableArray alloc]init];
        NSMutableArray*section2Title=[NSMutableArray arrayWithObjects:LocalizationKey(@"mobilePhoneOption"),LocalizationKey(@"emailOption"),LocalizationKey(@"remarkOption"),nil];
        for (int i=0; i<3; i++) {
            nameModel*model=[[nameModel alloc]init];
            if (i==0) {
                model.content=self.model.phone;
            }else if (i==1){
                model.content=self.model.email;
            }else{
                model.content=self.model.remark;
            }
            model.placeholder=section2Title[i];
            [section2Array addObject:model];
        }
        [self.modelArray addObject:section1Array];
        [self.modelArray addObject:section2Array];
    }
    [self setControlForSuper];
    [self addConstrainsForSuper];
    
}

- (void)setRightBarButtonItemtype2
{
    UIButton * rightItem = [[UIButton alloc]init];
    [rightItem.titleLabel setFont:systemFont(15)];
    [rightItem setTitle:LocalizationKey(@"delete") forState:UIControlStateNormal];
    [rightItem setTitleColor:barTitle forState:UIControlStateNormal];
    __weak AddContactController *weakself=self;
    [rightItem dn_addActionHandler:^{
        [weakself showAlert];
    }];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = right;
}

/**
 初始化模型数组
 */
-(void)initModelArray{
    NSMutableArray*section1Array=[[NSMutableArray alloc]init];
    NSMutableArray*section1Title=[NSMutableArray arrayWithObjects:LocalizationKey(@"name"), LocalizationKey(@"receivedWalletAddress"),nil];
    for (int i=0; i<2; i++) {
        nameModel*model=[[nameModel alloc]init];
        model.content=@"";
        model.placeholder=section1Title[i];
        model.btnTitle=@"BTC";
        [section1Array addObject:model];
    }
    NSMutableArray*section2Array=[[NSMutableArray alloc]init];
    NSMutableArray*section2Title=[NSMutableArray arrayWithObjects:LocalizationKey(@"mobilePhoneOption"),LocalizationKey(@"emailOption"),LocalizationKey(@"remarkOption"),nil];
    for (int i=0; i<3; i++) {
        nameModel*model=[[nameModel alloc]init];
        model.content=@"";
        model.placeholder=section2Title[i];
        [section2Array addObject:model];
    }
    [self.modelArray addObject:section1Array];
    [self.modelArray addObject:section2Array];
}
-(void)showAlert{
     __weak AddContactController *weakself=self;
    [self addUIAlertControlWithString:LocalizationKey(@"okDeleteContact") withActionBlock:^{
        [SVProgressHUD showWithStatus:LocalizationKey(@"deleting")];
        [[ContactsDataBase sharedDataBase] deleteContact:weakself.model];
        [[ContactsDataBase sharedDataBase] deleteAllCoinsFromContact:weakself.model];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [weakself.navigationController popViewControllerAnimated:YES];
           
        });
        
    }andCancel:^{
        
    }];
}
#pragma mark -- SetControlForSuper
- (void)setControlForSuper
{
    self.saveBtn = [[UIButton alloc]init];
    [self.saveBtn setTitle:LocalizationKey(@"save") forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"btnBackground"] forState:UIControlStateNormal];
    // 点击事件
    [self.saveBtn dn_addActionHandler:^{
        [self createContacts];
    }];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.tableView];
}

#pragma mark--创建联系人
-(void)createContacts{
    //新建联系人
    if (self.popType==AddContact) {
        contactsModel*contact=[[contactsModel alloc]init];
        NSMutableArray*section1Array=[self.modelArray firstObject];
        nameModel*model=[section1Array firstObject];
        contact.name=model.content;//获取联系人姓名
        NSMutableArray*section2Array=[self.modelArray lastObject];
        nameModel*phoneModel=section2Array[0] ;
        contact.phone=phoneModel.content;//获取联系人手机号
        nameModel*emailModel=section2Array[1] ;
        contact.email=emailModel.content;//获取联系人邮箱
        nameModel*remarkModel=section2Array[2];
        contact.remark=remarkModel.content;
        contact.name = [contact.name  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉首位空格
        if ([NSString stringIsNull:contact.name]) {
            [self.view makeToast:LocalizationKey(@"pleaseInputName") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        if ([self judgeIsSameName:contact.name withtype:1]) {
            [self.view makeToast:LocalizationKey(@"namesame") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        if (contact.phone.length!=0&&contact.phone.length!=11) {
            [self.view makeToast:LocalizationKey(@"mobileFormat") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        if (contact.email.length!=0&&![self isValidateEmail:contact.email]) {
            [self.view makeToast:LocalizationKey(@"emailFormat") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        [[ContactsDataBase sharedDataBase] addContact:contact];
        [SVProgressHUD showWithStatus:LocalizationKey(@"creatingCantact")];
        __block BOOL _IsContinue=NO;//至少存在一个地址
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            contactsModel*contactmodel=[[[ContactsDataBase sharedDataBase] getAllcontact] lastObject];
            if (![contact.name isEqualToString:contactmodel.name]) {
                [SVProgressHUD dismiss];
                [self.view makeToast:LocalizationKey(@"walletFail") duration:1.5 position:CSToastPositionCenter];
                return ;//创建联系人失败
            }
            
            NSArray *smallArray = [section1Array subarrayWithRange:NSMakeRange(1, section1Array.count-1)];
            [smallArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                nameModel*model=smallArray[idx];
                coinModel*coin=[[coinModel  alloc]init];
                coin.brand=model.btnTitle;
                coin.address=model.content;
                NSLog(@"币的种类--%@",coin.brand);
                if (![NSString stringIsNull:coin.address]) {
                    _IsContinue=YES;
                    [[ContactsDataBase sharedDataBase] addcoin:coin toContact:contactmodel];
                }
            }];
            if (!_IsContinue) {
                [self.view makeToast:LocalizationKey(@"pleaseImputReAddress") duration:1.5 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
                [[ContactsDataBase sharedDataBase] deleteAllCoinsFromContact:contactmodel];
                [[ContactsDataBase sharedDataBase]deleteContact:contactmodel];
                return ;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
    }
    else{
       //编辑联系人
        NSMutableArray*section1Array=[self.modelArray firstObject];
        nameModel*model=[section1Array firstObject];
        self.model.name=model.content;//获取联系人姓名
        NSMutableArray*section2Array=[self.modelArray lastObject];
        nameModel*phoneModel=section2Array[0] ;
        self.model.phone=phoneModel.content;//获取联系人手机号
        nameModel*emailModel=section2Array[1] ;
        self.model.email=emailModel.content;//获取联系人邮箱
        nameModel*remarkModel=section2Array[2];
        self.model.remark=remarkModel.content;
        self.model.name = [self.model.name  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉首位空格
        if ([NSString stringIsNull:self.model.name]) {
            [self.view makeToast:LocalizationKey(@"pleaseInputName") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        if ([self judgeIsSameName:self.model.name withtype:0]) {
            [self.view makeToast:LocalizationKey(@"namesame") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        if (self.model.phone.length!=0&&self.model.phone.length!=11) {
            [self.view makeToast:LocalizationKey(@"mobileFormat") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        if (self.model.email.length!=0&&![self isValidateEmail:self.model.email]) {
            [self.view makeToast:LocalizationKey(@"emailFormat") duration:1.5 position:CSToastPositionCenter];
            return ;
        }
        [SVProgressHUD showWithStatus:LocalizationKey(@"changing")];
        __block BOOL _IsContinue=NO;//至少存在一个地址
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *smallArray = [section1Array subarrayWithRange:NSMakeRange(1, section1Array.count-1)];
            [smallArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                nameModel*model=smallArray[idx];
                if (![NSString stringIsNull:model.content]) {
                    [[ContactsDataBase sharedDataBase] deleteAllCoinsFromContact:self.model];
                }
            }];
            [smallArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                nameModel*model=smallArray[idx];
                coinModel*coin=[[coinModel  alloc]init];
                coin.brand=model.btnTitle;
                coin.address=model.content;
                NSLog(@"币的种类--%@",coin.brand);
                if (![NSString stringIsNull:coin.address]) {
                    _IsContinue=YES;
                    [[ContactsDataBase sharedDataBase] addcoin:coin toContact:self.model];
                   
                }
            }];
            if (!_IsContinue) {
                [self.view makeToast:LocalizationKey(@"pleaseImputReAddress") duration:1.5 position:CSToastPositionCenter];
                [SVProgressHUD dismiss];
                return ;
            }
            [[ContactsDataBase sharedDataBase] updateContact:self.model];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
        
        
        
    }
  
}
#pragma mark -- AddConstrainsForSuper
- (void)addConstrainsForSuper
{
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.mas_offset(SCREEN_WIDTH*0.12);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.saveBtn.mas_top).mas_offset(0);
    }];
}

#pragma mark -- Target Methods

- (void)scanClick
{
    MMScanViewController *scanVC = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error);
        } else {
            NSLog(@"扫描结果：%@",result);
            NSArray *array = [result componentsSeparatedByString:@":"];
            nameModel*coin=[[nameModel alloc]init];
            coin.btnTitle=[array firstObject];
            coin.content=[array objectAtIndex:1];
            coin.placeholder=LocalizationKey(@"receivedWalletAddress");
            NSMutableArray*modelArray=[self.modelArray firstObject];
            __block BOOL _isContinue=NO;
            [modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                nameModel*model=modelArray[idx];
                if (idx!=0) {
                    if ([model.content isEqualToString:@""]||!model.content) {
                        _isContinue=YES;
                        [modelArray replaceObjectAtIndex:idx withObject:coin];
                        *stop=YES;
                        [self.modelArray replaceObjectAtIndex:0 withObject:modelArray];
                        [self.tableView reloadData];
                        
                    }
                }
                
            }];
            if (!_isContinue) {
                
                [modelArray addObject:coin];
                [self.modelArray replaceObjectAtIndex:0 withObject:modelArray];
                [self.tableView reloadData];
            }
        }
    }];
    scanVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:scanVC animated:YES];
}
// 添加,删除收款人的钱包地址响应事件
- (void)addContactClick:(UIButton*)sender
{
    AddContactViewCell* currentCell = (AddContactViewCell *)[sender superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
    if (indexPath.row==1) {
        NSMutableArray*modelArray=[self.modelArray firstObject];
        nameModel*model=[[nameModel alloc]init];
        model.content=@"";
        model.placeholder=LocalizationKey(@"receivedWalletAddress");
        model.btnTitle=@"BTC";
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:modelArray.count inSection:0];
        [modelArray addObject:model];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.modelArray replaceObjectAtIndex:0 withObject:modelArray];
    }else{
        NSMutableArray*modelArray=[self.modelArray firstObject];
        [modelArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.modelArray replaceObjectAtIndex:0 withObject:modelArray];
        
    }
    
}


#pragma mark -- Private Methods

- (void)setRightBarButtonItemtype1
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"新建联系人-扫一扫_03")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(scanClick)];
}



#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.modelArray.count>0) {
        return [self.modelArray[section] count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
    if (indexPath.section == 0)
    {
        //姓名
        if (indexPath.row==0) {
            
            nameModel*model=self.modelArray[indexPath.section][indexPath.row];
            OptionalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OptionalCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.popType==EditContact) {
                //编辑联系人
                cell.textField.placeholder = model.placeholder;
                cell.textField.text=model.content;
                cell.textField.delegate=self;
                cell.textField.tag=0;
            }else{
                //添加联系人
                cell.textField.placeholder = model.placeholder;
                cell.textField.text=model.content;
                cell.textField.delegate=self;
                cell.textField.tag=0;
            }
            cell.textField.textColor = TFTextColor;
            [cell.textField setValue:TFContactPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
            return cell;
        }else{
            nameModel*model=self.modelArray[indexPath.section][indexPath.row];
            AddContactViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.popType==EditContact) {
                //编辑联系人
                cell.textField.placeholder = model.placeholder;
                cell.textField.text=model.content;
                cell.textField.delegate=self;
                [cell.selectBtn setTitle:model.btnTitle forState:UIControlStateNormal];
            }else{
                //添加联系人
                cell.textField.placeholder = model.placeholder;
                cell.textField.text=model.content;
                cell.textField.delegate=self;
                [cell.selectBtn setTitle:model.btnTitle forState:UIControlStateNormal];
            }
            cell.textField.textColor = TFTextColor;
            [cell.textField setValue:TFContactPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
             [cell.addBtn addTarget:self action:@selector(addContactClick:) forControlEvents:UIControlEventTouchUpInside];
            if (indexPath.row==1) {
                [cell.addBtn setBackgroundImage:IMAGE(@"add_address_white") forState:UIControlStateNormal];
                
            }else{
                 [cell.addBtn setBackgroundImage:IMAGE(@"delete_address_white") forState:UIControlStateNormal];
            }
            [cell.selectBtn addTarget:self action:@selector(genderPickerView:) forControlEvents:UIControlEventTouchUpInside];
            cell.textField.tag=1;
            return cell;
        }
    }
    else
    {
        nameModel*model=self.modelArray[indexPath.section][indexPath.row];
        OptionalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OptionalCell" forIndexPath:indexPath];
        cell.textField.tag=0;
        if (self.popType==EditContact) {
            //编辑联系人
            cell.textField.placeholder = model.placeholder;
            cell.textField.text=model.content;
            cell.textField.delegate=self;
        }else{
          //添加联系人
            cell.textField.placeholder = model.placeholder;
            cell.textField.text=model.content;
            cell.textField.delegate=self;
        }
        cell.textField.textColor = TFTextColor;
        [cell.textField setValue:TFContactPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
        if (indexPath.row==0) {
            //手机号，纯数字
            cell.textField.keyboardType=UIKeyboardTypeNumberPad;
        }else{
           cell.textField.keyboardType=UIKeyboardTypeDefault;
        }
        
        return cell;
    }
    
}
- (void)genderPickerView:(UIButton*)sender {
    
    HSGenderPickerVC *vc = [[HSGenderPickerVC alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
     AddContactViewCell*cell = (AddContactViewCell *)[sender superview];
    _currentIndexPath = [self.tableView indexPathForCell:cell];
}

#pragma mark - HSGenderPickerVCDelegate
-(void)genderPicker:(HSGenderPickerVC*)genderPicker
    selectedGernder:(NSString*)gender
{
    NSLog(@"选择了   %@",gender);
    NSMutableArray*modelArray=[self.modelArray firstObject];
    nameModel*model=modelArray[_currentIndexPath.row];
    model.btnTitle=gender;
    [modelArray replaceObjectAtIndex:_currentIndexPath.row withObject:model];
    [self.modelArray replaceObjectAtIndex:0 withObject:modelArray];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:_currentIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = tableViewColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor=lineColor;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        if(@available(iOS 11.0,*)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"AddContactViewCell" bundle:nil] forCellReuseIdentifier:identifier];
         [_tableView registerNib:[UINib nibWithNibName:@"OptionalCell" bundle:nil] forCellReuseIdentifier:@"OptionalCell"];
        _tableView.rowHeight=55;
    }
    return _tableView;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell* currentCell;
    if (textField.tag==0) {
        currentCell = (UITableViewCell *)[[textField superview] superview];
    }else{
        currentCell = (UITableViewCell *)[textField superview];
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
    
    if (indexPath.section==0) {
        NSMutableArray*modelArray=[self.modelArray firstObject];
        nameModel*model=modelArray[indexPath.row];
        model.content=textField.text;
        [modelArray replaceObjectAtIndex:indexPath.row withObject:model];
        [self.modelArray replaceObjectAtIndex:0 withObject:modelArray];
        
        
    }else{
        NSMutableArray*modelArray=[self.modelArray lastObject];
        nameModel*model=modelArray[indexPath.row];
        model.content=textField.text;
        [modelArray replaceObjectAtIndex:indexPath.row withObject:model];
        [self.modelArray replaceObjectAtIndex:1 withObject:modelArray];
    }
    
    NSLog(@"输入的内容--%@--%ld-%ld",textField.text,(long)indexPath.section,(long)indexPath.row);
}

/**
 判断联系人名字是否重复
type：0 编辑联系人
type：1 新建联系人
 */
-(BOOL)judgeIsSameName:(NSString*)name withtype:(int)type{
    NSMutableArray*array;
    if (type==1) {
        //新建
       array= [[ContactsDataBase sharedDataBase] getAllcontact];
       
    }else{
        //编辑
        array=[[ContactsDataBase sharedDataBase] getAllcontact];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            contactsModel*model=array[idx];
            if ([model.name isEqualToString:self.model.name]) {
                [array removeObject:model];
            }
            
        }];
        
    }
    if (array.count==0) {
        return NO;
    }
    __block  BOOL _isSame=NO;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        contactsModel*model=array[idx];
        if ([model.name isEqualToString:name]) {
            _isSame=YES;
            *stop=YES;
        }
    }];
    if (_isSame) {
        return YES;
    }else{
        return NO;
    }
}
// 利用正则表达式验证邮箱格式是否正确

-(BOOL )isValidateEmail:( NSString  *)email

{
    
    NSString  *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    
    NSPredicate  *emailTest = [ NSPredicate   predicateWithFormat : @"SELF MATCHES%@",emailRegex];
    
    return  [emailTest  evaluateWithObject :email];
    
}
#pragma mark -- DidReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Other Delegate

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter

@end
