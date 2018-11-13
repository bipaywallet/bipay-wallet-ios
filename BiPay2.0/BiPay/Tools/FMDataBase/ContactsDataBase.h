//
//  ContactsDataBase.h
//  BiPay
//
//  Created by sunliang on 2018/8/18.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class contactsModel;
@class coinModel;
@interface ContactsDataBase : NSObject
@property(nonatomic,strong) walletModel *wallet;


+ (instancetype)sharedDataBase;


#pragma mark - wallet
/**
 *  添加联系人
 *
 */
- (void)addContact:(contactsModel *)contact;
/**
 *  删除联系人
 *
 */
- (void)deleteContact:(contactsModel *)contact;
/**
 *  更新联系人
 *
 */
- (void)updateContact:(contactsModel *)contact;

/**
 *  获取所有联系人
 *
 */
- (NSMutableArray *)getAllcontact;

#pragma mark - Coin


/**
 *  给联系人添加币种地址
 *
 */
- (void)addcoin:(coinModel *)coin toContact:(contactsModel *)contact;
/**
 *  给联系人删除币种
 *
 */
- (void)deletecoin:(coinModel *)coin fromContact:(contactsModel *)contact;
/**
 *  获取联系人的所有币种
 *
 */
- (NSMutableArray *)getAllCoinsFromContact:(contactsModel *)contact;
/**
 *  更新币种
 *
 */
- (void)updatecoin:(coinModel *)coin toContact:(contactsModel *)contact;
/**
 *  删除联系人的所有币种
 *
 */
- (void)deleteAllCoinsFromContact:(contactsModel *)contact;
@end
