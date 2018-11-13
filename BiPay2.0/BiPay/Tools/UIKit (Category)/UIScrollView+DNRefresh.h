//
//  UIScrollView+DNRefresh.h
//  DNProject
//
//  Created by zjs on 2018/5/17.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

typedef void(^RefreshBlock)(void);
typedef void(^RefHeadGIFBlock)(MJRefreshGifHeader *head);
typedef void(^RefFootGIFBlock)(MJRefreshAutoGifFooter *foot);

@interface UIScrollView (DNRefresh)

///==============================================
/// 下拉刷新
///==============================================

/**
 *  @brief  普通下拉刷新
 *
 *  @param  refreshBlock 下拉回调
 */
- (void)startHeaderRefreshWithRefreshBlock:(RefreshBlock)refreshBlock;

/**
 *  @brief  带图片下拉刷新
 *
 *  @param  idleImages      下拉时图片数组
 *  @param  pullImages      松手时图片数组
 *  @param  refreshImages   刷新时图片数组
 *  @param  refreshBlock    下拉刷新完成回调
 */
- (void)startGifHeaderWithIdleImages:(NSArray *)idleImages pullImages:(NSArray *)pullImages refreshImages:(NSArray *)refreshImages refreshWithBlock:(RefreshBlock)refreshBlock;


///==============================================
/// 上拉加载
///==============================================

/**
 *  @brief  普通上拉加载
 *
 *  @param  refreshBlock 上拉回调
 */
- (void)startFooterUploadRefreshBlock:(RefreshBlock)refreshBlock;

/**
 *  @brief  带图片上拉加载
 *
 *  @param  idleImages      上拉时图片数组
 *  @param  pullImages      松手时图片数组
 *  @param  refreshImages   刷新时图片数组
 *  @param  refreshBlock    下拉刷新完成回调
 */
- (void)startGIFAutoFootWithIdleImages:(NSArray *)idleImages pullImages:(NSArray *)pullImages refreshImages:(NSArray *)refreshImages refreshWithBlock:(RefreshBlock)refreshBlock;

/**
 *  @brief  带图片上拉加载
 *
 *  @param  idleImages      上拉时图片数组
 *  @param  pullImages      松手时图片数组
 *  @param  refreshImages   刷新时图片数组
 *  @param  refreshBlock    下拉刷新完成回调
 */
- (void)startGIFBackFootWithIdleImages:(NSArray *)idleImages pullImages:(NSArray *)pullImages refreshImages:(NSArray *)refreshImages refreshWithBlock:(RefreshBlock)refreshBlock;
@end
