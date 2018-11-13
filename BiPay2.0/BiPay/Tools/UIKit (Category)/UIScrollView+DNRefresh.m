//
//  UIScrollView+DNRefresh.m
//  DNProject
//
//  Created by zjs on 2018/5/17.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UIScrollView+DNRefresh.h"

@implementation UIScrollView (DNRefresh)

static char blockKey;
static char autoFootKey;
static char backFootKey;


///================================================
///     下拉刷新
///================================================
- (void)startHeaderRefreshWithRefreshBlock:(RefreshBlock)refreshBlock{
    DNWeak(self);
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            refreshBlock();
            [weakself.mj_header endRefreshing];
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.mj_header.automaticallyChangeAlpha = YES;
}

// 带图片下拉刷新
- (void)startGifHeaderWithIdleImages:(NSArray *)idleImages
                          pullImages:(NSArray *)pullImages
                       refreshImages:(NSArray *)refreshImages
                    refreshWithBlock:(RefreshBlock)refreshBlock
{
    objc_setAssociatedObject(self, &blockKey, refreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self
                                                              refreshingAction:@selector(headerRefresh:)];
    
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:pullImages forState:MJRefreshStatePulling];
    [header setImages:refreshImages forState:MJRefreshStateRefreshing];
    
    self.mj_header = header;
    
}
- (void)headerRefresh:(MJRefreshGifHeader *)header{
    
    RefreshBlock block = (RefreshBlock)objc_getAssociatedObject(self, &blockKey);
    if (block) {
        block();
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [header endRefreshing];
    });
}


///================================================
///     上拉加载
///================================================
- (void)startFooterUploadRefreshBlock:(RefreshBlock)refreshBlock
{
    DNWeak(self);
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            refreshBlock();
            [weakself.mj_footer endRefreshing];
        });
    }];
}
// 带图片自动加载
- (void)startGIFAutoFootWithIdleImages:(NSArray *)idleImages
                            pullImages:(NSArray *)pullImages
                         refreshImages:(NSArray *)refreshImages
                      refreshWithBlock:(RefreshBlock)refreshBlock
{
    // runtime 发送消息
    objc_setAssociatedObject(self, &autoFootKey, refreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 上拉控件及添加事件
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(autoFooterRefresh:)];
    // 设置图片
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    [footer setImages:pullImages forState:MJRefreshStatePulling];
    [footer setImages:refreshImages forState:MJRefreshStateRefreshing];
    // 设置上拉控件
    self.mj_footer = footer;
}

- (void)autoFooterRefresh:(MJRefreshAutoGifFooter *)footer
{
    // runtime 接收消息
    RefreshBlock block = (RefreshBlock)objc_getAssociatedObject(self, &autoFootKey);
    // block 传递事件
    if (block) {
        block();
    }
    // 1.0 秒后添加到队列
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 结束上拉加载
        [footer endRefreshing];
    });
}

// 带图片上拉加载
- (void)startGIFBackFootWithIdleImages:(NSArray *)idleImages
                            pullImages:(NSArray *)pullImages
                         refreshImages:(NSArray *)refreshImages
                      refreshWithBlock:(RefreshBlock)refreshBlock
{
    objc_setAssociatedObject(self, &backFootKey, refreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    MJRefreshBackGifFooter * footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(backFooterRefresh:)];
    
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    [footer setImages:pullImages forState:MJRefreshStatePulling];
    [footer setImages:refreshImages forState:MJRefreshStateRefreshing];
    
    self.mj_footer = footer;
}

- (void)backFooterRefresh:(MJRefreshBackFooter *)footer{
    
    RefreshBlock block = (RefreshBlock)objc_getAssociatedObject(self, &backFootKey);
    if (block) {
        block();
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [footer endRefreshing];
    });
}
@end
