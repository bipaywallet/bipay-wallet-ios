//
//  LeftMenuViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UIViewController+LeftSlide.h"
#import <objc/runtime.h>

@implementation UIViewController (LeftSlide)
static const void *kIsOpenKey = &kIsOpenKey;
static const void *kMaskViewKey = &kMaskViewKey;

#pragma mark - UIPanGestureRecognizer
-(void)initSlideFoundation{
    
    self.view.backgroundColor = [UIColor clearColor];
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0.184 green:0.184 blue:0.216 alpha:0.50];
    self.maskView.alpha = 0;
    self.maskView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow insertSubview:self.maskView aboveSubview:self.view];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    [self.view addGestureRecognizer:pan];
}

#pragma mark -- set & get
-(BOOL)isOpen
{
    return  [objc_getAssociatedObject(self, kIsOpenKey) boolValue];
}

-(void)setIsOpen:(BOOL)isOpen
{
    objc_setAssociatedObject(self, kIsOpenKey, [NSNumber numberWithBool:isOpen], OBJC_ASSOCIATION_ASSIGN);
}

-(UIView *)maskView{
    return objc_getAssociatedObject(self, kMaskViewKey);
}

-(void)setMaskView:(UIView *)maskView
{
    objc_setAssociatedObject(self, kMaskViewKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -- 拖动隐藏
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([otherGestureRecognizer.view isKindOfClass:[UICollectionView class]]||[otherGestureRecognizer.view isKindOfClass:[UITableView class]])
    {
        return NO;
    }
    
    return YES;
}

-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    //NSLog(@"translation.x == %f", translation.x);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if(UIGestureRecognizerStateBegan == recognizer.state ||
       UIGestureRecognizerStateChanged == recognizer.state){
        
        if (translation.x< 0 ) {//SwipLeft
            
            return;
            
        }else
        {//SwipRight
            
            CGFloat tempX = CGRectGetMinX(self.view.frame) + translation.x;
            self.view.frame = CGRectMake(tempX, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        }
        
    }else
    {
        //if (CGRectGetMinX(self.view.frame) >=  CGRectGetWidth(self.view.frame) * 0.5)
         if (CGRectGetMinX(self.view.frame) <=  75) {
            
            [self show];
            
        }else{
            
            [self hide];
        }
    }
}

/**关闭左视图 */
- (void)hide
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.view.frame = CGRectMake(2*CGRectGetHeight(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        self.maskView.alpha = 0;
    }completion:^(BOOL finished) {
        self.isOpen = NO;
        self.maskView.hidden = YES;
    }];
}

/** 打开视图 */
- (void)show
{
    self.maskView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        self.maskView.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.isOpen = YES;
    }];
}
static char *BackBtnKey = "backBtnKey";
- (void)setBackBtn:(UIButton *)backBtn {
    objc_setAssociatedObject(self, BackBtnKey, backBtn, OBJC_ASSOCIATION_ASSIGN);
}
- (UIButton *)backBtn {
    //NSLog(@"--> backBtn");
    return objc_getAssociatedObject(self, BackBtnKey);
}
// 返回按钮：自定义图片
-(void)backBtnNoNavBar:(BOOL)noNavBar normalBack:(BOOL)normalBack
{
    CGFloat ww=25, hh=28;
    //隐藏系统的
    //self.navigationItem.hidesBackButton = YES;
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,ww, hh)];
    [backBtn setImage:[UIImage imageNamed:@"页面返回按钮_03"] forState:UIControlStateNormal];
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
        NSLog(@"--> backBlock");
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
@end
