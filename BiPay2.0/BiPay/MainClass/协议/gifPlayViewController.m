//
//  gifPlayViewController.m
//  BiPay
//
//  Created by sunliang on 2018/11/28.
//  Copyright © 2018 zjs. All rights reserved.
//

#import "gifPlayViewController.h"
#import "UIImage+GIF.h"
#import "NavigationController.h"
#import "WalletController.h"
#import "KSGuaidViewManager.h"
@interface gifPlayViewController ()

@end

@implementation gifPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self playGif];//播放gif
    // Do any additional setup after loading the view from its nib.
}
-(void)playGif{
    [self performSelector:@selector(record) withObject:nil afterDelay:3.5];
    //得到图片的路径
    NSString *path;
    if (kWindowH == 812.0) {
       path = [[NSBundle mainBundle] pathForResource:@"1125" ofType:@"gif"];
    }else{
       path = [[NSBundle mainBundle] pathForResource:@"750" ofType:@"gif"];
    }
    //将图片转为NSData
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    
    UIImage *image = [UIImage sd_animatedGIFWithData:gifData];
    
    UIImageView *gifView = [[UIImageView
                             alloc] initWithFrame:CGRectMake(0,
                                                             0, kWindowW, kWindowH)];
    gifView.tag=10086;
    gifView.backgroundColor = [UIColor
                               orangeColor];
    gifView.image = image;
    [self.view addSubview:gifView];
     
}

-(void)record{
    UIImageView *findImageV = (UIImageView *)[self.view viewWithTag:10086];
    [UIView animateWithDuration:1.0 animations:^{
        findImageV.alpha=0;
    } completion:^(BOOL finished) {
        [findImageV removeFromSuperview];
    }];
     NavigationController * walletNav = [[NavigationController alloc]initWithRootViewController:[[WalletController alloc]init]];
     APPLICATION.window.rootViewController = walletNav;
    [self initKSGuaidManager];

}
-(void)initKSGuaidManager{
    
    KSGuaidManager.images = @[[UIImage imageNamed:@"guid01"],
                              [UIImage imageNamed:@"guid02"],
                              [UIImage imageNamed:@"guid03"]
                              ];
    KSGuaidManager.shouldDismissWhenDragging =NO ;
    KSGuaidManager.dismissButtonImage=UIIMAGE(@"tiyan");
    KSGuaidManager.dismissButtonCenter=CGPointMake(kWindowW/2.0, kWindowH-150);
    KSGuaidManager.pageIndicatorTintColor=barColor;
    KSGuaidManager.currentPageIndicatorTintColor=barTitle;
    [KSGuaidManager begin];
    
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
