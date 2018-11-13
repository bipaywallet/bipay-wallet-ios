//
//  CNScollPositionView.h
//  TransparentNavApp
//
//  Created by WangShaoShuai on 2018/4/26.
//  Copyright © 2018年 中华粮网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CNScollPositionTitleContentView;
@protocol ScollPositionDelegate <NSObject>

- (void)selectedItemButton:(NSInteger)index;
// 只是为了演示这儿是想说明下边这个方法是可选的就是可以实现也可以不实现

@end
@interface CNScollPositionView : UIView
@property(nonatomic)NSArray           *titlesArr;//标题数组
@property(nonatomic,assign)CGFloat    titleViewWidth;//子控件的宽度
@property(nonatomic)CNScollPositionTitleContentView *titleContentView;//顶部title的容器
@property(nonatomic)UIScrollView      *contentScrollView;//传入自己需要联动的内容容器scrollview
@property(nonatomic,weak)id<ScollPositionDelegate> delegate;
/**
 *估计索引确定选中的标题
 */
-(void)resetTitileViewState:(NSInteger)index;
@end

@interface CNScollPositionTitleContentView:UIView
@property(nonatomic)CGPoint         indexPoint;
@property(nonatomic,assign)CGFloat  scrollX;
@property(nonatomic,assign)BOOL     scroll;
@property(nonatomic,assign)BOOL     moveRight;
@property(nonatomic,assign)BOOL     moveLeft;
@property(nonatomic,assign)CGFloat  fixedWidth;
@end
