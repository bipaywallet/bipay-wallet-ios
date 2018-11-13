//
//  CNScollPositionView.m
//  TransparentNavApp
//
//  Created by WangShaoShuai on 2018/4/26.
//  Copyright © 2018年 中华粮网. All rights reserved.
//

#import "CNScollPositionView.h"
@interface CNScollPositionView()
@property(nonatomic)UIScrollView    *scrollView;
@property(nonatomic)UILabel         *animationLineLab;//按钮下面的线

@end
@implementation CNScollPositionView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
-(void)setUp{
//    NSInteger i = 5;
    //self.titleViewWidth=64.0;
    self.titleViewWidth=[UIScreen mainScreen].bounds.size.width/5;
    self.titleContentView.fixedWidth=self.titleViewWidth/2;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleContentView];
    self.titleContentView.indexPoint = CGPointMake(self.titleViewWidth/2.0, self.frame.size.height);
}
-(void)setTitlesArr:(NSArray *)titlesArr{
    _titlesArr = titlesArr;
    [self addTitleViews];
}
-(void)setContentScrollView:(UIScrollView *)contentScrollView{
    _contentScrollView = contentScrollView;
    [_contentScrollView.panGestureRecognizer addTarget:self action:@selector(pan:)];
}
-(void)pan:(UIPanGestureRecognizer *)ges{
    CGPoint  point = [ges translationInView:self.contentScrollView];
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            //此处判断可绘制的最大长度
            if(fabs(point.x*0.5)>self.titleViewWidth*5/4){
                return;
            }
            self.titleContentView.scrollX = point.x*0.5;
            self.titleContentView.scroll=YES;
            break;
        case UIGestureRecognizerStateEnded:{
            
        }
            break;
        default:
            break;
    }
    [self.titleContentView setNeedsDisplay];
    NSLog(@"%@",NSStringFromCGPoint(point));
}
//添加标题子控件
-(void)addTitleViews{
    for (int i = 0; i<_titlesArr.count; i++) {
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_titlesArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        [button addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [self.titleContentView addSubview:button];
        if (i==0) {
            button.selected=YES;
            [self setTitltesViewNormal:button];
        }
    }
}
-(void)titleBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(selectedItemButton:)]) {
        [self.delegate selectedItemButton:btn.tag];
    }
    [self setTitltesViewNormal:btn];
    [self layoutSubviews];
    [self resetScrollViewOffset:btn];
    if(self.contentScrollView==nil)return;
    [self setContentScrollOffSetByIndex:[self.titleContentView.subviews indexOfObject:btn]];
}
-(void)setContentScrollOffSetByIndex:(NSInteger)index{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = CGPointMake(index*self.contentScrollView.bounds.size.width, 0);
    }];
}
//设置scrollview偏移量的逻辑
-(void)resetScrollViewOffset:(UIButton *)btn{
    CGPoint  point = btn.center;
    CGFloat  absoultX = self.scrollView.bounds.size.width/2.0;
    if (self.scrollView.contentSize.width<=self.scrollView.bounds.size.width) return;
    if (point.x>absoultX&&self.scrollView.contentSize.width-point.x>absoultX) {
        //判断点击的按钮的中心点X和scroview的内容宽度减去按钮中心X坐标的长度都大于scroview的一般宽度的时候，才开始向中心移动
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(point.x-absoultX, 0);
        }];
    }
    if (point.x<absoultX) {
        //判断点击按钮的中心X小于scroview一般宽度的时候,设置scoview的偏移量为0；
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
    if (self.scrollView.contentSize.width-point.x<absoultX) {
        //判断scroview的内容宽度减去点击按钮的中心X的距离小于scroview一半宽度的时候，将scroview滑动到最右边。
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width-self.scrollView.bounds.size.width, 0);
    }
}
-(void)setTitltesViewNormal:(UIButton *)btn{
    for (UIButton *button in self.titleContentView.subviews) {
        button.selected = NO;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    }
    btn.selected = YES;
    [btn setTitleColor:barTitle forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
}
-(void)resetTitileViewState:(NSInteger)index{
    UIButton  *btn = self.titleContentView.subviews[index];
    [self setTitltesViewNormal:btn];
    self.titleContentView.indexPoint  = btn.center;
    [self layoutSubviews];
    [self resetScrollViewOffset:btn];

}
-(UILabel *)animationLineLab{
    if (!_animationLineLab) {
        _animationLineLab = [[UILabel alloc]init];
        _animationLineLab.backgroundColor = barTitle;
    }
    return _animationLineLab;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces=NO;
    }
    return _scrollView;
}
-(CNScollPositionTitleContentView *)titleContentView{
    if (!_titleContentView) {
        _titleContentView = [[CNScollPositionTitleContentView alloc]init];
    }
    return _titleContentView;
}
-(void)layoutSubviews{
    self.scrollView.frame = self.bounds;
    self.titleContentView.frame = CGRectMake(0, 0,self.titleViewWidth*self.titlesArr.count, self.scrollView.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.titleViewWidth*self.titlesArr.count, 0);
    for (int i = 0 ; i<self.titleContentView.subviews.count; i++) {
        UIButton  *button = self.titleContentView.subviews[i];
        button.frame = CGRectMake(i*self.titleViewWidth, 0, self.titleViewWidth, self.scrollView.bounds.size.height);
        if (button.selected) {
            if (i==0) {
                self.titleContentView.moveLeft=NO;
            }
            else{
                self.titleContentView.moveLeft=YES;
            }
            if (i==self.titleContentView.subviews.count-1) {
                self.titleContentView.moveRight=NO;
            }
            else{
                self.titleContentView.moveRight=YES;
            }
            self.titleContentView.indexPoint = button.center;
            [self.titleContentView setNeedsDisplay];
        }
    }
}
@end
#pragma mark--装载内容的容器类
@implementation CNScollPositionTitleContentView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = barColor;
        self.scrollX = 0;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 5);
    CGContextSetStrokeColorWithColor(context, barTitle.CGColor);
    if (_scroll) {
            if (self.scrollX>0) {//向左滑
                if (!self.moveLeft) {
                    CGContextMoveToPoint(context, self.indexPoint.x-self.fixedWidth/2,rect.size.height);
                    CGContextAddLineToPoint(context, self.indexPoint.x+self.fixedWidth/2, rect.size.height);
                    CGContextDrawPath(context, kCGPathStroke);
                    return;
                }
                CGContextMoveToPoint(context, self.indexPoint.x+self.fixedWidth/2,rect.size.height);
                CGContextAddLineToPoint(context, self.indexPoint.x-self.scrollX, rect.size.height);
            }
            else{//向右滑
                if (!self.moveRight) {
                    CGContextMoveToPoint(context, self.indexPoint.x-self.fixedWidth/2,rect.size.height);
                    CGContextAddLineToPoint(context, self.indexPoint.x+self.fixedWidth/2, rect.size.height);
                    CGContextDrawPath(context, kCGPathStroke);
                    return;
                }
                CGContextMoveToPoint(context, self.indexPoint.x-self.fixedWidth/2,rect.size.height);
                CGContextAddLineToPoint(context, self.indexPoint.x-self.scrollX, rect.size.height);
            }
            NSLog(@"%f",self.scrollX);
    }
    else{
        CGContextMoveToPoint(context, self.indexPoint.x-self.fixedWidth/2,rect.size.height);
        CGContextAddLineToPoint(context, self.indexPoint.x+self.fixedWidth/2, rect.size.height);
    }

//    NSLog(@"--%f",self.indexPoint.x);
    CGContextDrawPath(context, kCGPathStroke);

}
@end
