//
//  YSActionSheetView.m
//  ShareAlertDemo
//
//  Created by dev on 2018/5/23.
//  Copyright © 2018年 nys. All rights reserved.
//

#import "YSActionSheetView.h"

#import "ShareTableViewCell.h"


#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#define SafeAreaHeight (([[UIScreen mainScreen] bounds].size.height-812)?0:34)

#define SPACE 10



@interface YSActionSheetView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,   copy) NSString *cancelTitle;
@property (nonatomic, strong) NSMutableArray * buttonsArr;

@end


@implementation YSActionSheetView


-(instancetype)initNYSView
{
    if (self = [super init]) {
        
        
        [self craetUI];
    }
    return self;
    
}

- (void)craetUI {
    
    self.buttonsArr =[[NSMutableArray alloc]initWithCapacity:0];
    
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
    
    
}


- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .0;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.clipsToBounds = YES;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
    
}
#pragma mark TableViewDel
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        return 140;
    }
    else
    {
        return 44;
    }
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    if (indexPath.section == 0)
    {
        
        ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"top_Cell"];
        
        if (!cell)
        {
            
            cell=[[ShareTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"top_Cell"];
            
            
        }
        
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.layer.cornerRadius = 10;

        
        [cell.shareBtn1 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn2 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.shareBtn3 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.shareBtn4 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.buttonsArr addObject:cell.shareBtn1];
        [self.buttonsArr addObject:cell.shareBtn2];
//        [self.buttonsArr addObject:cell.shareBtn3];
//        [self.buttonsArr addObject:cell.shareBtn4];
        
        
        [self.buttonsArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            [UIView animateWithDuration:1.1 delay:0.05 * (idx +1) usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                
                obj.transform = CGAffineTransformIdentity;
                
                
                
            } completion:^(BOOL finished) {
                
                
                
            }];
            
        }];
        
        
        return cell;
        
    }
    else
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottom_Cell"];
        
        if (!cell)
        {
            
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bottom_Cell"];
            
        }
        
        cell.backgroundColor=[UIColor whiteColor];
        
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.textLabel.text = LocalizationKey(@"cancel");
        cell.layer.cornerRadius = 10;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor =[UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
        
        return cell;
        
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [self dismiss];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0)
    {
        return SPACE;
    }
    else
    {
        return 15;
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    CGFloat selfHeight ;
    if (section==0)
    {
        selfHeight = SPACE ;
    }
    else
    {
        selfHeight = 15 ;
    }
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, selfHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
    
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}


-(void)shareBtnClick:(YSActionSheetButton *)btn
{
    
    
    if (btn.tag==0 || btn.tag==1)
    {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
        {
            
            if ([_delegate respondsToSelector:@selector(customActionSheetButtonClick:)]) {
                [_delegate customActionSheetButtonClick:btn];
            }
            
        }
        else
        {
            
            //[Dialog simpleToast:@"请安装微信"];
            
            UIAlertAction * confirmAction=[UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            
            
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:LocalizationKey(@"warmTip") message:LocalizationKey(@"pleaseInstallWechat") preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:confirmAction];
            
            
            [[self appRootViewController] presentViewController:alertView animated:YES completion:nil];
            
            
            
        }
    }
    else if (btn.tag==2 || btn.tag==3)
    {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
        {
            
            if ([_delegate respondsToSelector:@selector(customActionSheetButtonClick:)]) {
                [_delegate customActionSheetButtonClick:btn];
            }
            
        }
        else
        {
           // [Dialog simpleToast:@"请安装QQ"];
            
            
            UIAlertAction * confirmAction=[UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];

            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:LocalizationKey(@"warmTip") message:LocalizationKey(@"pleaseInstallqq") preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:confirmAction];
            
            
            [[self appRootViewController] presentViewController:alertView animated:YES completion:nil];

            
        }
    }
    
    
    
    
    [self dismiss];
    
    
}

- (void)show {
    
    _tableView.frame = CGRectMake(SPACE, Screen_height, Screen_Width - (SPACE * 2), 140+44 +(SPACE * 2));
    
    [UIView animateWithDuration:.35 animations:^{
        
        
        self.maskView.alpha = .3;
        
        CGRect rect = self.tableView.frame;
        rect.origin.y -= self.tableView.bounds.size.height;
        
        
        //适配iPhone X
        rect.origin.y -= SafeAreaHeight;
        
        self.tableView.frame = rect;
        
    }];
    
    
}

- (void)dismiss {
    
    [UIView animateWithDuration:.15 animations:^{
        
        self.maskView.alpha = .0;
        
        
        CGRect rect = self.tableView.frame;
        rect.origin.y += self.tableView.bounds.size.height;
        
        //适配iPhone X
        rect.origin.y += SafeAreaHeight;
        
        self.tableView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}


- (UIViewController *)appRootViewController
{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
   UIViewController *topVC =appRootVC;
        while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
    

    
}



@end
