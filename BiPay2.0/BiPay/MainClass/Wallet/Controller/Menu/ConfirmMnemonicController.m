//
//  ConfirmMnemonicController.m
//  BiPay
//
//  Created by 褚青骎 on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ConfirmMnemonicController.h"
#import "MnemonicView.h"

@interface ConfirmMnemonicController () <MnemonicDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipsTitle;
@property (weak, nonatomic) IBOutlet UIView *mnemonicContainer;
@property (weak, nonatomic) IBOutlet UILabel *tipsContent;
@property (weak, nonatomic) IBOutlet UIView *confirmContainer;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

- (IBAction)clickBtn:(id)sender;
@property (nonatomic, strong) MnemonicView *mnemonicView;
@property (nonatomic, strong) MnemonicView *confirmView;
@property (nonatomic, strong) NSArray *mnemonicArr;     //助记词列表
@property (nonatomic, strong) NSMutableArray *selectWordArr;    //记录已选助记词的列表

@end

@implementation ConfirmMnemonicController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"备份助记词";
    self.tipsTitle.text = @"确认你的钱包助记词";
    self.tipsContent.text = @"请按顺序点击助记词，已确认你的备份助记词正确";
    
    [self loadMnemonicView];
    self.mnemonicView.mnemonicWord = self.selectWordArr;
    self.confirmView.mnemonicWord = self.mnemonicArr;
    
    [self randomArray];
    [self.mnemonicView reloadData];
}

//初始化助记词View
- (void)loadMnemonicView
{
    self.mnemonicView = [MnemonicView init:CGRectMake(0, 0, SCREEN_WIDTH - 20, CGRectGetHeight(self.mnemonicContainer.bounds))];
    self.confirmView = [MnemonicView init:CGRectMake(0, 0, SCREEN_WIDTH - 20, CGRectGetHeight(self.confirmContainer.bounds))];
    self.confirmView.backgroundColor = [UIColor whiteColor];
    self.confirmView.mnemonicDelegate = self;

    [_mnemonicContainer addSubview:_mnemonicView];
    [_confirmContainer addSubview:_confirmView];
}

#pragma mark --懒加载
- (NSArray *)mnemonicArr
{
    if(_mnemonicArr == nil) {
        _mnemonicArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    }
    return _mnemonicArr;
}

- (NSMutableArray *)selectWordArr
{
    if(_selectWordArr == nil) {
        _selectWordArr = [NSMutableArray array];
    }
    return _selectWordArr;
}

#pragma mark --MnemonicDelegate
- (void)selectWord:(NSString *)word {
    if(self.selectWordArr.count < 12) {
        [self.selectWordArr addObject:word];
        [self.mnemonicView reloadData];
    }
}

//随机打乱助记词顺序
- (void)randomArray {
    self.confirmView.mnemonicWord = [self.confirmView.mnemonicWord sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)clickBtn:(id)sender {

}
@end
