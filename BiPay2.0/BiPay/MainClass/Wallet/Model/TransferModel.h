//
//  TransferModel.h
//  BiPay
//
//  Created by sunliang on 2018/8/10.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferModel : NSObject
@property(nonatomic,strong ) NSNumber *own_id;
/**
 *  Transfer的ID
 */
@property(nonatomic,strong) NSNumber *transfer_id;
@property(nonatomic,copy) NSString* address;
@property(nonatomic,copy) NSString* amount;
@property(nonatomic,copy) NSString* indexNo;
@property(nonatomic,copy) NSString* txid;
@property(nonatomic,copy) NSString* nonce;//非UTXO类专有，如ETH
@property(nonatomic,copy) NSString* transfeType; //记录交易记录类型（区分UTXO和非UTXO）
@property(nonatomic,copy) NSString* creatTime; //本地数据库记录此条数据时间
/**
 用来标记属于哪个钱包的某些币种的交易记录，方便删除钱包时，该交易记录也随之删除
 */
@property(nonatomic,strong)NSNumber*walletID;
@end
