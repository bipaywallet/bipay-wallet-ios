//
//  FastNewsController.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "FastNewsController.h"
#import "FastNewsCell.h"
#import "NewsContentController.h"
#import "FastNewsManager.h"
#import "FastNewModel.h"
@interface FastNewsController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _pageNo;
    NSTimer * _timer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *maxId;//当前缓存最大ID
@property(nonatomic,strong) NSMutableArray*contentArray;
@property (weak, nonatomic) IBOutlet UIImageView *upArrowImg;
@property (weak, nonatomic) IBOutlet UIButton *aNewKXBtn;//新快讯按钮
@property (weak, nonatomic) IBOutlet UILabel *aNewsTipLab;
@end

@implementation FastNewsController
static NSString * identifier = @"cell";
#pragma mark -- lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentArray = [NSMutableArray array];
    //MARK:--初始化数据
    [self getMaxIDFromInfo];
    [self PostAfNWithtype:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
//    _tableView.estimatedRowHeight = 0;
//    _tableView.estimatedSectionHeaderHeight = 0;
//    _tableView.estimatedSectionFooterHeight = 0;
    
    _tableView.separatorColor=lineColor;
    if(@available(iOS 11.0,*)){
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"FastNewsCell" bundle:nil] forCellReuseIdentifier:@"fastNews"];

    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"notrade" titleStr:LocalizationKey(@"nodata")];
    self.tableView.ly_emptyView = emptyView;
    
    if (@available(iOS 10.0, *)) {
        _timer = [NSTimer timerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self startTimerToRequestNews];

        }];
    } else {
        // Fallback on earlier versions
    }
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    //MARK:--注册国际化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeNotificaiton:) name:LanguageChange object:nil];
}
- (void)languageChangeNotificaiton:(NSNotification *)notification{
    [self.tableView reloadData];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.title = LocalizationKey(@"fastNews");
}
- (void)startTimerToRequestNews{
        //DLog(@"当前最大ID=%@",self.maxId);
    [FastNewsManager getFastInfoCountWithID:self.maxId withCompletion:^(id resultObject, int isSuccessed) {
        if (kRequestSucceed) {
            
            NSString * countStr = resultObject[@"data"][@"count"];
            //            DLog(@"countstr %@",countStr);
            //            DLog(@"%@",resultObject);
            NSInteger count = [countStr integerValue];
            if ( count > 0) {
                [self shoewTip];
                NSString *tip = [NSString stringWithFormat:@"%@%ld%@",LocalizationKey(@"has"),(long)count,LocalizationKey(@"newKx")];
                self.aNewsTipLab.text = tip;
                
            }
        }
        
    }];
    
    
}
- (void)hiddenTip{
    self.aNewKXBtn.hidden = YES;
    self.upArrowImg.hidden = YES;
    self.aNewsTipLab.hidden = YES;
}
- (void)shoewTip
{
    self.aNewKXBtn.hidden = NO;
    self.upArrowImg.hidden = NO;
    self.aNewsTipLab.hidden = NO;
}
-(void)PostAfNWithtype:(int)type{
    [SVProgressHUD show];
    [FastNewsManager getNearnewsWithPageSize:10 WithpageNo:_pageNo withkeywords:nil CompleteHandle:^(id resPonseObj, int code) {
        [SVProgressHUD dismiss];
        
        if ([resPonseObj[@"code"] integerValue] == 0) {
            if (type==1) {
                if (self->_pageNo == 1) {
                    [self.contentArray removeAllObjects];
                    
                }
            }
            NSArray * data = resPonseObj[@"data"];
            
            for (int i = 0; i < data.count; i ++) {
                FastNewModel * model = [FastNewModel mj_objectWithKeyValues:data[i]];
                model.isOpen = NO;
                [self.contentArray addObject:model];
                
            }
            
            [self.tableView reloadData];
        }
        else{
            [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

//MARK:--点击最新资讯按钮
- (IBAction)getNewsInfomationClick:(id)sender {
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark -- didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark -- target Methods

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FastNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fastNews"];
    cell.openOrCloseBtn.tag = indexPath.row;
    cell.model = self.contentArray[indexPath.row];
    [cell.shareBtn setTitle:LocalizationKey(@"share") forState:UIControlStateNormal];
    if (cell.model.isOpen) {
        [cell.openOrCloseBtn setTitle:LocalizationKey(@"close") forState:UIControlStateNormal];
        [cell.openOrCloseBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    }else{
        [cell.openOrCloseBtn setTitle:LocalizationKey(@"open") forState:UIControlStateNormal];
        [cell.openOrCloseBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
        
    }
    //MARK:--展开收起点击
    cell.block = ^(UIButton *button) {

        FastNewsCell* currentCell = (FastNewsCell *)[[button superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

    };
    //MARK:--分享
    cell.shareBlock = ^(UIButton *button) {
        NewsContentController *newsContent = [[NewsContentController alloc] init];
        newsContent.model=self.contentArray[indexPath.row];
        [self.navigationController pushViewController:newsContent animated:YES];
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NewsContentController *newsContent = [[NewsContentController alloc] init];
//    newsContent.model=self.contentArray[indexPath.row];
//    [self.navigationController pushViewController:newsContent animated:YES];
    
}


/** 上拉加载
 */
- (void)refreshFooterAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
    _pageNo+=1;
    [self PostAfNWithtype:0];
}
/** 下拉刷新
 */
- (void)refreshHeaderAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    _pageNo=1;
    [self hiddenTip];
    [self PostAfNWithtype:1];
    [self getMaxIDFromInfo];
}
//MARK:--获取最大ID
- (void)getMaxIDFromInfo{
    [FastNewsManager getNearnewsWithPageSize:1 WithpageNo:_pageNo withkeywords:nil CompleteHandle:^(id resPonseObj, int code) {
        if ([resPonseObj[@"code"] integerValue] == 0) {
            
            NSArray * data = resPonseObj[@"data"];
            if (data.count == 0) {
//                Toast(@"没有更多了");
            }
            FastNewModel * model = [FastNewModel mj_objectWithKeyValues:data[0]];
            
            self.maxId = model.newsID;
            DLog(@"%@",model.newsID);
            
        }
    }];
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     FastNewModel * model = self.contentArray[indexPath.row];
      return model.height;
 }


#pragma mark -- other Deleget

#pragma mark -- NetWork Methods

#pragma mark -- Setter && Getter


@end
