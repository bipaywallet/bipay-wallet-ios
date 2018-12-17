//
//  ConfirmMnemonicController.m
//  BiPay
//
//  Created by 褚青骎 on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ConfirmMnemonicController.h"
#import "MnemonicView.h"
#import "ImportSuccessController.h"
#import "TabBarController.h"
#import "AppDelegate.h"
#import "AESCrypt.h"
#import "MnemonicViewCell.h"
#import "selectedModel.h"
@interface ConfirmMnemonicController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *tipsTitle;
@property (weak, nonatomic) IBOutlet UIView *mnemonicContainer;
@property (weak, nonatomic) IBOutlet UILabel *tipsContent;
@property (weak, nonatomic) IBOutlet UIView *confirmContainer;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (nonatomic, strong) MnemonicView *mnemonicView;//上方
@property (nonatomic, strong) MnemonicView *confirmView;//下方
@property (nonatomic, strong) NSMutableArray *selectWordArr;//记录已选助记词的列表
@property (nonatomic, strong) NSMutableArray *confirmArr;
@end

@implementation ConfirmMnemonicController

- (NSMutableArray *)selectWordArr
{
    if(_selectWordArr == nil) {
        _selectWordArr = [NSMutableArray array];
    }
    return _selectWordArr;
}

- (NSMutableArray *)confirmArr
{
    if(_confirmArr == nil) {
        _confirmArr = [NSMutableArray array];
    }
    return _confirmArr;
}

-(NSMutableArray *)gibberishArray:(NSArray *)array{
    NSMutableArray *arr = [NSMutableArray  arrayWithCapacity:array.count];
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:array];
    int count = (int)array.count;
    int randCount = 0;//索引
    int nowCount = 0;//当前数组的元素个数
    
    for (;count != 0; ) {
        nowCount = (int)tempArr.count;//当前数组的元素个数
        count = nowCount;
        if (nowCount != 0) {
            randCount = (arc4random() % nowCount);
            [arr addObject:tempArr[randCount]];
            tempArr[randCount] = tempArr.lastObject;
            [tempArr removeLastObject];
        }
    }
    return arr;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=ViewBackColor;
    self.tipsContent.textColor = barTitle;
    self.tipsTitle.textColor = barTitle;
    [self setLeftButtonItem];
    [self loadMnemonicView];
    self.confirmView.mnemonicWord = [self gibberishArray:self.mnemonicWord];//打乱助记词
   // self.confirmView.mnemonicWord = self.mnemonicWord;
    [self.confirmView.mnemonicWord  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        selectedModel*model=[[selectedModel alloc]init];
        model.name=self.confirmView.mnemonicWord[idx];
        model.type=0;
        [self.confirmArr addObject:model];
    }];
    
    [self.confirmView reloadData];
    CGRect rect = self.bgView.frame;
    rect.size.width = kWindowW;
    self.bgView.frame = rect;
    [self.bg_scrollView addSubview:self.bgView];
    self.bg_scrollView.contentSize = self.bgView.frame.size;
    DLog(@"%@",NSStringFromCGRect(rect));
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = ViewBackColor;
    self.title = LocalizationKey(@"remarkmnemonic");
    self.tipsTitle.text = LocalizationKey(@"confirmmnemonic");
    self.tipsContent.text = LocalizationKey(@"pleaseSortmnemonicTip");
    [self.nextStepBtn setTitle:LocalizationKey(@"confirm") forState:UIControlStateNormal];
}

//初始化助记词View
- (void)loadMnemonicView
{
    self.mnemonicView = [MnemonicView init:CGRectMake(0, 0, SCREEN_WIDTH - 20, CGRectGetHeight(self.mnemonicContainer.bounds))];
    self.mnemonicView.delegate = self;
    self.mnemonicView.dataSource=self;
    self.confirmView = [MnemonicView init:CGRectMake(0, 0, SCREEN_WIDTH - 20, CGRectGetHeight(self.confirmContainer.bounds))];
    self.mnemonicContainer.backgroundColor= [UIColor clearColor];
    self.mnemonicView.backgroundColor = NavColor;
    self.confirmView.backgroundColor = [UIColor clearColor];
    self.confirmView.delegate = self;
    self.confirmView.dataSource=self;
    [_mnemonicContainer addSubview:_mnemonicView];
    [_confirmContainer addSubview:_confirmView];
}

-(void)setLeftButtonItem{
    UIButton * navBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    // 返回按钮的图片
    [navBack setImage:IMAGE(@"页面返回按钮_03") forState:UIControlStateNormal];
    // 设置按钮的对齐方式
    navBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 设置按钮的内边距（左侧贴近边缘）
    [navBack setImageEdgeInsets:UIEdgeInsetsMake(0, -spaceSize(5), 0, 0)];
    // 按钮添加点击事件
    [navBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    // 将按钮添加到导航栏上
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:navBack];
    self.navigationItem.leftBarButtonItem = left;
}
/**
 重写导航返回事件
 
 */
- (void)backClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalizationKey(@"warmTip") message:LocalizationKey(@"backWalletTips") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark --UICollectionView Delegate
///** 初始化cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.confirmView]) {
        selectedModel*model=self.confirmArr[indexPath.row];
        //下方
        MnemonicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MnemonicViewCell" forIndexPath:indexPath];
        cell.wordCell.text = model.name;
        if (model.type==0) {
            cell.wordCell.backgroundColor=[UIColor clearColor];
        }else{
            cell.wordCell.backgroundColor=CellBackColor;
        }
        
        return cell;
    }else{
        //上方
        selectedModel*model=self.selectWordArr[indexPath.row];
        MnemonicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MnemonicViewCell" forIndexPath:indexPath];
        cell.wordCell.text = model.name;
        if (model.type==0) {
            cell.wordCell.backgroundColor=[UIColor clearColor];
        }else{
            cell.wordCell.backgroundColor=ViewBackColor;
        }
        return cell;
    }
  
}

/** cell的点击事件*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   //下方-confirmView
    if ([collectionView isEqual:self.confirmView]) {
        selectedModel*model=self.confirmArr[indexPath.row];
        if (model.type==0) {
            model.type=1;
            [self.selectWordArr addObject:model];
            [self.confirmArr removeObjectAtIndex:indexPath.row];
            [self.mnemonicView reloadData];
            [self.confirmView reloadData];
            
            
        }
    }else{//上方
        selectedModel*model=self.selectWordArr[indexPath.row];
        model.type=0;
        [self.selectWordArr removeObject:model];
        [self.confirmArr addObject:model];//
        [self.mnemonicView reloadData];
        [self.confirmView reloadData];
    }
     [self resetConfirmTframeWithArray:self.confirmArr];//重置确认按钮的位置
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每组中cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.confirmView]) {
        return self.confirmArr.count;
    }else{
        return self.selectWordArr.count;
    }
}
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 20)/4, 60);
}

/** 分区内cell之间的最小行间距*/
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
/** 分区内cell之间的最小列间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)resetConfirmTframeWithArray:(NSMutableArray*)confirmArr {
    if (confirmArr.count>8) {
        self.heightConstant.constant=180;
    }else if (confirmArr.count<=8&&confirmArr.count>4){
        self.heightConstant.constant=120;
    }
    else{
        self.heightConstant.constant=60;
    }
  
}

#pragma mark-下一步,创建钱包

- (IBAction)nextStep:(UIButton *)sender {
    
    if ([self.selectWordArr count]==0) {
        [self.view makeToast:LocalizationKey(@"pleaseInputmnemonic") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    __block  NSMutableArray*strArray=[NSMutableArray array];
    [self.selectWordArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        selectedModel*model=self.selectWordArr[idx];
        [strArray addObject:model.name];
        
    }];
    
    if (![strArray isEqualToArray:self.mnemonicWord]) {
        [self.view makeToast:LocalizationKey(@"mnemonicErroTip") duration:1.5 position:CSToastPositionCenter];
        return ;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalizationKey(@"warmTip") message:LocalizationKey(@"mnemonicTips") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self crearwallet];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
   
}

/**
 开始创建钱包
 */
-(void)crearwallet{
    
    __block NSString*str=@"";
    [self.mnemonicWord enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        str=[NSString stringWithFormat:@"%@ %@",str,self.mnemonicWord[idx]];
    }];
    NSString*laststr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *seedString = [BiPayObject getSeedWithMnemonic:laststr];
    NSString *MasterKey= [BiPayObject getMasterKey:seedString];
    self.model.password=[AESCrypt encrypt:MasterKey password:self.model.password];
    BOOL isSuccess= [self.model bg_save];
    if(isSuccess){ //创建钱包成功
        [SVProgressHUD showWithStatus:LocalizationKey(@"walletGeneration")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray * arr = [walletModel bg_findAll:nil];
            walletModel*wallet=[arr lastObject];
            if (![self.model.password isEqualToString:wallet.password]) {
                [SVProgressHUD dismiss];
                [self.view makeToast:LocalizationKey(@"walletFail") duration:1.5 position:CSToastPositionCenter];
                return ;//没有创建钱包成功
            }
            NSString*coinNames = [BiPayObject getSupportedCoins];
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\\[\\]"];
            coinNames = [coinNames stringByTrimmingCharactersInSet:set];//去掉两头括号
            coinNames = [coinNames stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSArray *Namearray=[UserinfoModel shareManage].Namearray;
            NSArray *typeArray=[UserinfoModel shareManage].coinTypeArray;
            NSArray *tradeTypeArray=[UserinfoModel shareManage].tradeTypeArray;
            NSArray *AddressprefixArray=[UserinfoModel shareManage].AddressprefixTypeArray;
            NSArray *PriveprefixArray=[UserinfoModel shareManage].PriveprefixTypeArray;
            NSArray *englishNameArray=[UserinfoModel shareManage].englishNameArray;
            for (int i=0; i<Namearray.count; i++) {
                [self creatCoins:Namearray[i] withEnglishName:englishNameArray[i] withCointype:[typeArray[i] intValue] withAddressprefix:[AddressprefixArray[i] intValue] withPriveprefix:[PriveprefixArray[i] intValue]  withTradetype:tradeTypeArray[i] withID:wallet.bg_id  withMasterKey:MasterKey withWallet:wallet];
            }
            [wallet bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:wallet.bg_id]]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                ImportSuccessController*importVC=[[ImportSuccessController alloc]init];
                importVC.popType=0;
                [self.navigationController pushViewController:importVC animated:YES];
            });
        });
        
    }else{
          NSLog(@"创建钱包失败");
          [self.view makeToast:LocalizationKey(@"walletGenerationFail") duration:1.5 position:CSToastPositionCenter];
        
    }
 
}
/**
 往钱包内添加币种
 */
-(void)creatCoins:(NSString*)coinName withEnglishName:(NSString*)englishName withCointype:(int)type withAddressprefix:(int)addressprefix withPriveprefix:(int)priveprefix withTradetype:(NSString*)tradeType withID:(NSNumber*)ID withMasterKey:(NSString*)MasterKey withWallet:(walletModel*)wallet{
    coinModel*coin=[[coinModel  alloc]init];
    coin.brand=coinName;
    coin.englishName=englishName;
    coin.own_id=ID;
    coin.cointype=type;
    coin.Addressprefix=addressprefix;
    coin.Priveprefix=priveprefix;
    coin.recordType=tradeType;
    coin.blockHeight=0;
    coin.usdPrice=@"0";
    coin.closePrice=@"0";
    coin.addtime=[self getNowTimeTimestamp];
    coin.totalAmount=@"0";
    if ([coin.brand isEqualToString:@"BTC"]||[coin.brand isEqualToString:@"ETH"]) {
        coin.collect=1;
    }else{
        coin.collect=0;
    }
    if ([coin.brand isEqualToString:@"USDT"]) {
        coin.fatherCoin=@"BTC";
    }
    coin.address=[BiPayObject createWalletWithPrivateKey:MasterKey coinType:type addressPrefix:addressprefix];
    //NSLog(@"新建的地址--%@--%@----钱包ID-%d",coin.brand,coin.address,addressprefix);
    [coin bg_save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
