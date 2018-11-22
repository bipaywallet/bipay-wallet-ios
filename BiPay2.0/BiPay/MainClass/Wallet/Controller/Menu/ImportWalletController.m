//
//  ImportWalletController.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ImportWalletController.h"
#import "SegmentViewController.h"
#import "ImportDetailController.h"
static CGFloat const ButtonHeight = 50;
@interface ImportWalletController ()

@end

@implementation ImportWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
//    屏蔽系统的右划返回手势，防止与页面中的左右换切换导入方式发生冲突
   //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.title=LocalizationKey(@"importPacket");
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.0];
   
    // Do any additional setup after loading the view from its nib.
}

-(void)delayMethod{
    [self configSegment];
}
-(void)configSegment{
    
    SegmentViewController *vc = [[SegmentViewController alloc]init];
    NSArray *titleArray = @[LocalizationKey(@"mnemonicword"),LocalizationKey(@"privateKey")];
    vc.headViewBackgroundColor = NavColor;
    vc.bottomLineBackColor = BGViewBackColor;
    vc.titleArray = titleArray;
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    ImportDetailController *vc1 = [[ImportDetailController alloc]initWithType:@"help"];
    [controlArray addObject:vc1];
    ImportDetailController *vc2 = [[ImportDetailController alloc]initWithType:@"key"];
    [controlArray addObject:vc2];
    vc.titleSelectedColor = barTitle;
    vc.titleColor = barUnSelectTitle;
    vc.bottomLineColor = barUnderLineColor;
    vc.subViewControllers = controlArray;
    vc.buttonWidth = self.view.frame.size.width/2;
    vc.buttonHeight = ButtonHeight;
    vc.bottomCount = titleArray.count;
    [vc initSegment];
    [vc addParentController:self];
    
}



- (void)setRightBarButtonItem
{
    UIButton *button = [[UIButton alloc] init];
    [button.titleLabel setFont:systemFont(15)];
    [button setTitle:@"English" forState:UIControlStateNormal];
    [button setTitleColor:barTitle forState:UIControlStateNormal];
    [button dn_addActionHandler:^{
        if([button.titleLabel.text isEqualToString:@"English"]) {
            [button setTitle:@"中文" forState:UIControlStateNormal];
           
        } else {
            [button setTitle:@"English" forState:UIControlStateNormal];
        }
    }];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
