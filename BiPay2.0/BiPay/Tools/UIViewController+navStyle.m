//
//  UIViewController+navStyle.m
//  horizonLoan
//
//  Created by sunliang on 2017/9/30.
//  Copyright © 2017年 XinHuoKeJi. All rights reserved.
//

#import "UIViewController+navStyle.h"
#import <objc/runtime.h>
#import "ToolUtil.h"

@implementation UIViewController (navStyle)

-(void)setNavigationControllerStyle{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)cancelNavigationControllerStyle{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
static char *BackBtnKey = "backBtnKey";
- (void)setBackBtn:(UIButton *)backBtn {
    objc_setAssociatedObject(self, BackBtnKey, backBtn, OBJC_ASSOCIATION_ASSIGN);
}
- (UIButton *)backBtn {
    return objc_getAssociatedObject(self, BackBtnKey);
}
//集成nav上右侧的控件
-(void)RightsetupNavgationItemWithpictureName:(NSString*)picturename{
    UIImage *aimage = [UIImage imageNamed:picturename];
    UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(RighttouchEvent)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)RighttouchEvent{
    
    
}
//集成nav上左侧的控件
- (void)LeftsetupNavgationItemWithpictureName:(NSString*)picturename{
    UIImage *aimage = [UIImage imageNamed:picturename];
    UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(LefttouchEvent)];
    self.navigationItem.leftBarButtonItem = leftItem;
   
}
-(void)LefttouchEvent{
    
    
}
/** 导航左侧按钮-文字
 */
-(void)leftBarItemWithTitle:(NSString *)title{
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(LefttouchEvent)];
    [item setTintColor:[UIColor whiteColor]];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem = item;
    
}
/** 导航右侧按钮-文字
 */
-(void)rightBarItemWithTitle:(NSString *)title{
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(RighttouchEvent)];
    [item setTintColor:[UIColor whiteColor]];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = item;
}
/** 导航右侧按钮-文字
 */
-(void)rightBarItemWithTitle:(NSString *)title color:(UIColor *)color;{
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(RighttouchEvent)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName,color,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName,color,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = item;
}
// 返回按钮：自定义图片
-(void)backBtnNoNavBar:(BOOL)noNavBar normalBack:(BOOL)normalBack
{
    CGFloat ww=25, hh=28;
    //隐藏系统的
    //self.navigationItem.hidesBackButton = YES;
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,ww, hh)];
    [backBtn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backNav:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tag = normalBack;
    backBtn.backgroundColor = [UIColor clearColor];
    if (noNavBar) {
        backBtn.frame = CGRectMake(10,27,ww, hh);
        [self.view addSubview:backBtn];
        self.backBtn = backBtn;
    }else{
        UIBarButtonItem *leftBarBtn= [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem= leftBarBtn;
        self.backBtn = backBtn;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
            self.backBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
            [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        }
    }
}
-(void)backNav:(UIButton *)Btn {
    //正常返回
    if (Btn.tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
   else {
        //其他情况返回
        if (self.backBlock) {
            self.backBlock(Btn);
        }
    }
}

// BackBlock -> backBlock
- (BackBlock)backBlock {
    return objc_getAssociatedObject(self, @selector(backBlock));
}
- (void)setBackBlock:(BackBlock)backBlock {
    objc_setAssociatedObject(self,
                             @selector(backBlock),
                             backBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/** 下拉刷新
 */
- (void)headRefreshWithScrollerView:(UIScrollView *)scrol{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
    header.stateLabel.textColor = [ToolUtil colorWithHexString:@"#3b3c53"];
    header.lastUpdatedTimeLabel.textColor = [ToolUtil colorWithHexString:@"#3b3c53"];
    // 设置文字
    [header setTitle:LocalizationKey(@"Pullrefresh") forState:MJRefreshStateIdle];
    [header setTitle:LocalizationKey(@"Releaserefresh") forState:MJRefreshStatePulling];
    [header setTitle:LocalizationKey(@"Refreshingdata") forState:MJRefreshStateRefreshing];
    if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"]) {
        header.lastUpdatedTimeLabel.hidden =NO;
    }else{
        header.lastUpdatedTimeLabel.hidden =YES;
    }
    
    NSArray *Animation_ImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"Animation_1"], [UIImage imageNamed:@"Animation_2"],[UIImage imageNamed:@"Animation_3"] , [UIImage imageNamed:@"Animation_2"], nil];
    [header setImages:Animation_ImageArray forState:MJRefreshStateRefreshing];
    scrol.mj_header = header;
   
}
/** 上拉加载
 */
- (void)footRefreshWithScrollerView:(UIScrollView *)scrol{

    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
    [refreshFooter setTitle:LocalizationKey(@"pullmore")  forState:MJRefreshStateIdle];
    [refreshFooter setTitle:LocalizationKey(@"loadingmore") forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:LocalizationKey(@"Releasemore") forState:MJRefreshStatePulling];
    refreshFooter.automaticallyChangeAlpha = YES;    //上拉时透明度改变
    scrol.mj_footer = refreshFooter;
}
- (void)refreshFooterAction{
    
}
- (void)refreshHeaderAction{
    
    
}


-(void)hideNavBar{
    UIImage *image = [[UIImage alloc] init];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:image];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
}
//MARK:--显示导航栏
-(void)showNavBar{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
}
@end
