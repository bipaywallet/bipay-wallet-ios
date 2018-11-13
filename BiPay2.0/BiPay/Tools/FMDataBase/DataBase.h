//
//  DataBase.h
//  BiPay
//
//  Created by sunliang on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class walletModel;
@class coinModel;
@class TradeModel;
@class TransferModel;

@interface DataBase : NSObject
//
//@property(nonatomic,strong) walletModel *wallet;
//
//
//+ (instancetype)sharedDataBase;
//
//
//#pragma mark - wallet
///**
// *  添加钱包
// *
// */
//- (void)addwallet:(walletModel *)wallet;
///**
// *  删除钱包
// *
// */
//- (void)deletewallet:(walletModel *)wallet;
///**
// *  更新钱包
// *
// */
//- (void)updatewallet:(walletModel *)wallet;
//
///**
// *  获取所有钱包
// *
// */
//- (NSMutableArray *)getAllwallet;
//
//#pragma mark - Coin
//
//
///**
// *  给wallet添加币种
// *
// */
//- (void)addcoin:(coinModel *)coin toWallet:(walletModel *)wallet;
///**
// *  给wallet删除币种
// *
// */
//- (void)deletecoin:(coinModel *)coin fromWallet:(walletModel *)wallet;
///**
// *  获取wallet的所有币种
// *
// */
//- (NSMutableArray *)getAllCoinsFromwallet:(walletModel *)wallet;
//
//
///**
// *  获取wallet的所有添加进资产的币种
// *
// */
//- (NSMutableArray *)getAllAddedCoinsFromwallet:(walletModel *)wallet;
///**
// 根据钱包ID获取指定的某个钱包
//
// */
//-(walletModel*)getDesignatedWalletWithWalletID:(NSNumber*)walletID;
///**
// *  更新币种
// *
// */
//- (void)updatecoin:(coinModel *)coin toWallet:(walletModel *)wallet;
///**
// *  删除wallet的所有币种
// *
// */
//- (void)deleteAllCoinsFromwallet:(walletModel *)wallet;
//
//#pragma mark - TradeModel,记录
///**
// *  添加币种的交易记录
// *
// */
//- (void)addtrade:(TradeModel *)trade toCoin:(coinModel *)coin;
///**
// *  获取币种的全部交易记录
// *
// */
//- (NSMutableArray *)getAlltradesFromCoin:(coinModel *)coin;
///**
// *  更新币种的某条交易记录
// *
// */
//
//- (void)updatetrade:(TradeModel*)trade toCoin:(coinModel *)coin;
//
///**
// *  删除币种所有交易记录
// *
// */
//- (void)deleteAlltradesFromCoin:(coinModel *)coin;
//
//
///**
// *  删除某个钱包内所有币种的交易记录
// *
// */
//- (void)deleteAlltradesFromWallet:(walletModel *)wallet;
//
//#pragma mark - Transfer
////向币种添加未花交易
//- (void)addTransfer:(TransferModel *)transfer toCoin:(coinModel *)coin;
////获取某种币的全部未花交易
//- (NSMutableArray *)getAllTransferFromCoin:(coinModel *)coin;
////  删除某个钱包内所有币种的未花交易
//- (void)deleteAlltransfersFromWallet:(walletModel *)wallet;
//// 删除某个币种的未花交易
//- (void)deleteAlltransfersFromCoin:(coinModel *)coin;
// // 更新某个币种的未花交易
//- (void)updatetransfer:(TransferModel*)transfer toCoin:(coinModel *)coin;
//// 删除某个币种的一个未花交易
//- (void)deleteOnetransfers:(TransferModel*)transfer FromCoin:(coinModel *)coin;

@end
