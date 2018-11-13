//
//  TradeModel.h
//  BiPay
//
//  Created by sunliang on 2018/8/9.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferModel.h"
@interface TradeModel : NSObject
/**
 *  所有者
 */
@property(nonatomic,strong ) NSNumber *own_id;
/**
 *  trade的ID
 */
@property(nonatomic,strong) NSNumber *trade_id;
@property(nonatomic,copy) NSString* time;
@property(nonatomic,copy) NSString* amount;
@property(nonatomic,copy) NSString* value;
@property(nonatomic,copy) NSString* txid;
@property(nonatomic,copy) NSString* blockHash;
@property(nonatomic,copy) NSString* blockHeight;
@property(nonatomic,copy) NSString* confirmations;
@property(nonatomic,copy) NSString* fee;
@property(nonatomic,copy) NSString* remark;      //备注
@property(nonatomic,strong) NSArray* inputs;    //UTXO类币种专有（如DVC，BTC等）
@property(nonatomic,strong) NSArray* outputs;  //UTXO类币种专有（如DVC，BTC等）
@property(nonatomic,copy) NSString* Toaddress;
@property(nonatomic,copy) NSString* contractAddress;//合约地址
/**
 非UTXO类
 */
@property(nonatomic,copy) NSString* from;    //转出地址（非UTXO类币种专有，如ETH等）
@property(nonatomic,copy) NSString* to;     //收款地址  （非UTXO类币种专有，如ETH等）

@property(nonatomic,copy) NSString* tradeType; //记录交易记录类型（区分UTXO和非UTXO）

/**
 用来标记属于哪个钱包的某些币种的交易记录，方便删除钱包时，该交易记录也随之删除
 */
@property(nonatomic,strong)NSNumber*walletID;
//USDT类
@property(nonatomic,copy)NSString*blockTime;
@property(nonatomic,copy)NSString*sendingAddress;
@property(nonatomic,copy)NSString*referenceAddress;

@end
