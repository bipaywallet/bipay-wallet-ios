//
//  WalletAlertPickerView.m
//  BiPay
//
//  Created by zjs on 2018/6/15.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "WalletAlertPickerView.h"

@interface WalletAlertPickerView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView      * bgView;
@property (nonatomic, strong) UIImageView * extension;
@property (nonatomic, strong) UITableView * tableView;

@end

static WalletAlertPickerView * pickerView;

@implementation WalletAlertPickerView

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        [self setControlForSuper];
        [self addConstraintsForSuper];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setControlForSuper
{
    self.extension = [UIImageView dn_imageWithName:@"三角形-down"];
    
    self.bgView.userInteractionEnabled = NO;
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = RGB(46, 42, 40, 1.0);
    
    self.bgView.layer.cornerRadius  = 4.0f;
    self.bgView.layer.masksToBounds = YES;
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = RGB(46, 42, 40, 1.0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor=lineColor;
    [self addSubview:self.bgView];
    [self addSubview:self.extension];
    [self.bgView addSubview:self.tableView];
}

- (void)addConstraintsForSuper
{
    [self.extension mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).inset(NAVIGATION_BAR_HEIGHT);
        make.right.mas_equalTo(self.mas_right).inset(spaceSize(18));
        make.width.height.mas_offset(spaceSize(18));
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.extension.mas_bottom).mas_offset(-7);
        make.right.mas_equalTo(self.mas_right).inset(spaceSize(10));
        make.width.mas_offset(SCREEN_WIDTH*0.35);
        make.height.mas_offset(168);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.bgView);
    }];
}

+ (instancetype)shareView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        pickerView = [[self alloc]init];
    });
    return pickerView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    // NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark -- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [NSString stringWithFormat:@"%ldcell",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text  = self.titleArray[indexPath.row];
    cell.textLabel.font  = systemFont(13);
    cell.imageView.image = IMAGE(self.imageArray[indexPath.row]);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.titleArray.count-1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//移除最后一条分割线
    }else{
      //  cell.separatorInset = UIEdgeInsetsMake(0, FTDefaultMenuTextMargin, 0, 10+FTDefaultMenuTextMargin);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击弹起
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 代理传值
    if (_delegate && [_delegate respondsToSelector:@selector(walletAlertPickerSelectIndexPath:)])
    {
        [_delegate walletAlertPickerSelectIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    }];
    
    CATransition *transition = [CATransition animation];
    transition.duration = .5f;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    [self.layer addAnimation:transition forKey:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss
{
    [UIView animateWithDuration: 0.5
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseInOut animations: ^{

                            self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
                            
                        } completion: ^(BOOL finished) {
                            
                            [self.tableView removeFromSuperview];
                            [self.bgView    removeFromSuperview];
                            [self           removeFromSuperview];
                            self.alpha = 0;
                        }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismiss];
}
- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
}
@end
