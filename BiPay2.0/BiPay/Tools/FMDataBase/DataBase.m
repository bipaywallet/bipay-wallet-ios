//
//  DataBase.m
//  BiPay
//
//  Created by sunliang on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//
//
//#import "DataBase.h"
//
//#import <FMDB.h>
//
//#import "walletModel.h"
//#import "coinModel.h"
//#import "TradeModel.h"
//#import "TransferModel.h"
//static DataBase *_DBCtl = nil;
//
//@interface DataBase()<NSCopying,NSMutableCopying>{
//    FMDatabase  *_db;
//    
//}
//
//
//
//
//@end
//
//@implementation DataBase
//
//+(instancetype)sharedDataBase{
//    
//    if (_DBCtl == nil) {
//        
//        _DBCtl = [[DataBase alloc] init];
//        
//        [_DBCtl initDataBase];
//        
//    }
//    
//    return _DBCtl;
//    
//}
//
//+(instancetype)allocWithZone:(struct _NSZone *)zone{
//    
//    if (_DBCtl == nil) {
//        
//        _DBCtl = [super allocWithZone:zone];
//        
//    }
//    
//    return _DBCtl;
//    
//}
//
//-(id)copy{
//    
//    return self;
//    
//}
//
//-(id)mutableCopy{
//    
//    return self;
//    
//}
//
//-(id)copyWithZone:(NSZone *)zone{
//    
//    return self;
//    
//}
//
//-(id)mutableCopyWithZone:(NSZone *)zone{
//    
//    return self;
//    
//}
//
//
//-(void)initDataBase{
//    // 获得Documents目录路径
//    
//    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    // 文件路径
//    
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
//    
//    // 实例化FMDataBase对象
//    
//    _db = [FMDatabase databaseWithPath:filePath];
//    
//    [_db open];
//    
//    // 初始化数据表
//    NSString *walletSql = @"CREATE TABLE  IF NOT EXISTS 'walletModel' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'walletModel_id' VARCHAR(255),'walletModel_name' VARCHAR(255),'walletModel_password' VARCHAR(255),'walletModel_tips'VARCHAR(255),'walletModel_Mastkey'VARCHAR(255),'walletModel_isHide' VARCHAR(255)) ";//钱包
//    NSString *coinSql = @"CREATE TABLE  IF NOT EXISTS 'coinModel' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'coin_id' VARCHAR(255),'coinModel_brand' VARCHAR(255),'coinModel_cointype'VARCHAR(255),'coinModel_address'VARCHAR(255),'coinModel_collect'VARCHAR(255),'coinModel_blockHeight'VARCHAR(255),'coinModel_totalAmount'VARCHAR(255),'coinModel_closePrice'VARCHAR(255),'coinModel_usdPrice'VARCHAR(255),'coinModel_recordType'VARCHAR(255)) ";//币种
//     NSString *tradeSql = @"CREATE TABLE IF NOT EXISTS 'trade' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'trade_id' VARCHAR(255),'trade_time' VARCHAR(255),'trade_amount'VARCHAR(255),'trade_txid'VARCHAR(255),'trade_blockHeight'VARCHAR(255),'trade_fee'VARCHAR(255),'trade_remark'VARCHAR(255),'trade_Toaddress'VARCHAR(255),'trade_from'VARCHAR(255),'trade_to'VARCHAR(255),'trade_walletID'VARCHAR(255),'trade_tradeType'VARCHAR(255)) ";//交易记录
//     NSString *transferSql = @"CREATE TABLE IF NOT EXISTS 'transfer' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'transfer_id' VARCHAR(255),'transfer_address' VARCHAR(255),'transfer_amount'VARCHAR(255),'transfer_txid'VARCHAR(255),'transfer_walletID'VARCHAR(255),'transfer_tradeType'VARCHAR(255),'transfer_creatTime'VARCHAR(255),'transfer_nonce'VARCHAR(255))";//未花交易
//    [_db executeUpdate:walletSql];
//    [_db executeUpdate:coinSql];
//    [_db executeUpdate:tradeSql];
//    [_db executeUpdate:transferSql];
//    [_db close];
//}
//#pragma mark - 钱包管理
//
//- (void)addwallet:(walletModel *)wallet{
//    [_db open];
//    
//    NSNumber *maxID = @(0);
//    
//    FMResultSet *res = [_db executeQuery:@"SELECT * FROM walletModel "];
//    //获取数据库中最大的ID
//    while ([res next]) {
//        if ([maxID integerValue] < [[res stringForColumn:@"walletModel_id"] integerValue]) {
//            maxID = @([[res stringForColumn:@"walletModel_id"] integerValue] ) ;
//        }
//        
//    }
//    maxID = @([maxID integerValue] + 1);
//    
//    [_db executeUpdate:@"INSERT INTO walletModel(walletModel_id,walletModel_name,walletModel_password,walletModel_tips,walletModel_Mastkey,walletModel_isHide)VALUES(?,?,?,?,?,?)",maxID,wallet.name,wallet.password,wallet.tips,wallet.Mastkey,wallet.isHide];
//    
//    
//    
//    [_db close];
//    
//}
//
//- (void)deletewallet:(walletModel *)wallet{
//    [_db open];
//    
//    [_db executeUpdate:@"DELETE FROM walletModel WHERE walletModel_id = ?",wallet.ID];
//
//    [_db close];
//}
//
//- (void)updatewallet:(walletModel *)wallet{
//    [_db open];
//    
//    [_db executeUpdate:@"UPDATE 'walletModel' SET walletModel_name = ?  WHERE walletModel_id = ? ",wallet.name,wallet.ID];
//    [_db executeUpdate:@"UPDATE 'walletModel' SET walletModel_password = ?  WHERE walletModel_id = ? ",wallet.password,wallet.ID];
//    [_db executeUpdate:@"UPDATE 'walletModel' SET walletModel_tips = ?  WHERE walletModel_id = ? ",wallet.tips ,wallet.ID];
//    [_db executeUpdate:@"UPDATE 'walletModel' SET walletModel_Mastkey = ?  WHERE walletModel_id = ? ",wallet.Mastkey ,wallet.ID];
//    [_db executeUpdate:@"UPDATE 'walletModel' SET walletModel_isHide = ?  WHERE walletModel_id = ? ",wallet.isHide ,wallet.ID];
//    
//    [_db close];
//}
//
//- (NSMutableArray *)getAllwallet{
//    [_db open];
//    
//    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
//    
//    FMResultSet *res = [_db executeQuery:@"SELECT * FROM walletModel"];
//    
//    while ([res next]) {
//        walletModel *wallet = [[walletModel alloc] init];
//        wallet.ID = @([[res stringForColumn:@"walletModel_id"] integerValue]);
//        wallet.name = [res stringForColumn:@"walletModel_name"];
//        wallet.password = [res stringForColumn:@"walletModel_password"];
//        wallet.tips = [res stringForColumn:@"walletModel_tips"];
//        wallet.Mastkey = [res stringForColumn:@"walletModel_Mastkey"];
//        wallet.isHide = [res stringForColumn:@"walletModel_isHide"];
//        [dataArray addObject:wallet];
//        
//    }
//    
//    [_db close];
//    return dataArray;
//  
//}
//
//#pragma mark--币种管理
///**
// *  给wallet添加币种
// *
// */
//- (void)addcoin:(coinModel *)coin toWallet:(walletModel *)wallet{
//    [_db open];
//    
//    //根据wallet是否拥有coin来添加coin_id
//    NSNumber *maxID = @(0);
//    
//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM coinModel where own_id = %@ ",wallet.ID]];
//    
//    while ([res next]) {
//        if ([maxID integerValue] < [[res stringForColumn:@"coin_id"] integerValue]) {
//             maxID = @([[res stringForColumn:@"coin_id"] integerValue]);
//        }
//       
//    }
//     maxID = @([maxID integerValue] + 1);
//    
//    [_db executeUpdate:@"INSERT INTO coinModel(own_id,coin_id,coinModel_brand,coinModel_cointype,coinModel_address,coinModel_collect,coinModel_blockHeight,coinModel_totalAmount,coinModel_closePrice,coinModel_usdPrice,coinModel_recordType)VALUES(?,?,?,?,?,?,?,?,?,?,?)",wallet.ID,maxID,coin.brand,@(coin.cointype),coin.address,@(coin.collect),@(coin.blockHeight),coin.totalAmount,coin.closePrice,coin.usdPrice,coin.recordType];
//    
//    
//    [_db close];
//    
//}
///**
// *  给wallet删除币种
// *
// */
//- (void)deletecoin:(coinModel *)coin fromWallet:(walletModel *)wallet{
//    [_db open];
//    
//    
//    [_db executeUpdate:@"DELETE FROM coinModel WHERE own_id = ?  and coin_id = ? ",wallet.ID,coin.coin_id];
//    
//    [_db close];
//    
//    
//    
//}
//
///**
// *  获取wallet的所有添加进资产的币种
// *
// */
//- (NSMutableArray *)getAllAddedCoinsFromwallet:(walletModel *)wallet{
//    
//    [_db open];
//    NSMutableArray  *coinArray = [[NSMutableArray alloc] init];
//    
//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM coinModel where own_id = %@ and coinModel_collect = ?",wallet.ID],@(1)];
//    while ([res next]) {
//        coinModel *coin = [[coinModel alloc] init];
//        coin.own_id = wallet.ID;
//        coin.coin_id = @([[res stringForColumn:@"coin_id"] integerValue]);
//        coin.brand = [res stringForColumn:@"coinModel_brand"];
//        coin.cointype = [[res stringForColumn:@"coinModel_cointype"] intValue];
//        coin.collect = [[res stringForColumn:@"coinModel_collect"] intValue];
//        coin.address = [res stringForColumn:@"coinModel_address"];
//        coin.blockHeight = [[res stringForColumn:@"coinModel_blockHeight"] longLongValue];
//        coin.totalAmount = [res stringForColumn:@"coinModel_totalAmount"];
//        coin.closePrice = [res stringForColumn:@"coinModel_closePrice"];
//        coin.usdPrice = [res stringForColumn:@"coinModel_usdPrice"];
//        coin.recordType = [res stringForColumn:@"coinModel_recordType"];
//        [coinArray addObject:coin];
//        
//    }
//    [_db close];
//    
//    return coinArray;
//    
//}
///**
// *  获取wallet的所有币种
// *
// */
//- (NSMutableArray *)getAllCoinsFromwallet:(walletModel *)wallet{
//    
//    [_db open];
//    NSMutableArray  *coinArray = [[NSMutableArray alloc] init];
//    
//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM coinModel where own_id = %@",wallet.ID]];
//    while ([res next]) {
//        coinModel *coin = [[coinModel alloc] init];
//        coin.own_id = wallet.ID;
//        coin.coin_id = @([[res stringForColumn:@"coin_id"] integerValue]);
//        coin.brand = [res stringForColumn:@"coinModel_brand"];
//        coin.cointype = [[res stringForColumn:@"coinModel_cointype"] intValue];
//        coin.collect = [[res stringForColumn:@"coinModel_collect"] intValue];
//        coin.address = [res stringForColumn:@"coinModel_address"];
//        coin.blockHeight = [[res stringForColumn:@"coinModel_blockHeight"] longLongValue];
//        coin.totalAmount = [res stringForColumn:@"coinModel_totalAmount"];
//        coin.closePrice = [res stringForColumn:@"coinModel_closePrice"];
//        coin.usdPrice = [res stringForColumn:@"coinModel_usdPrice"];
//        coin.recordType = [res stringForColumn:@"coinModel_recordType"];
//        [coinArray addObject:coin];
//        
//    }
//    [_db close];
//    
//    return coinArray;
//    
//}
//
///**
// 根据钱包ID获取指定的某个钱包
//
// */
//-(walletModel*)getDesignatedWalletWithWalletID:(NSNumber*)walletID{
//    
//    [_db open];
//    walletModel*wallet=[[walletModel alloc]init];
//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM walletModel where walletModel_id = %@",walletID]];
//    if ([res next]) {
//        
//        wallet.ID = @([[res stringForColumn:@"walletModel_id"] integerValue]);
//        wallet.name = [res stringForColumn:@"walletModel_name"];
//        wallet.password = [res stringForColumn:@"walletModel_password"];
//        wallet.tips = [res stringForColumn:@"walletModel_tips"];
//        wallet.Mastkey = [res stringForColumn:@"walletModel_Mastkey"];
//        wallet.isHide = [res stringForColumn:@"walletModel_isHide"];
//    }else{
//        wallet=nil;//
//    }
//    [res close];//
//    [_db close];
//    
//    return wallet;
//    
//}
//
////更新钱包币种
//- (void)updatecoin:(coinModel *)coin toWallet:(walletModel *)wallet{
//    [_db open];
//    [_db executeUpdate:@"UPDATE 'coinModel' SET coin_id = ? WHERE own_id = ? and coin_id = ?",coin.coin_id,coin.own_id,coin.coin_id];
//    [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_brand = ? WHERE own_id = ? and coin_id = ?",coin.brand,coin.own_id,coin.coin_id];
//    [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_cointype = ? WHERE own_id = ? and coin_id = ?",@(coin.cointype),coin.own_id,coin.coin_id];
//    [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_collect = ? WHERE own_id = ? and coin_id = ?",@(coin.collect),coin.own_id,coin.coin_id];
//    [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_address = ? WHERE own_id = ? and coin_id = ?",coin.address,coin.own_id,coin.coin_id];
//     [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_blockHeight = ? WHERE own_id = ? and coin_id = ?",@(coin.blockHeight),coin.own_id,coin.coin_id];
//     [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_totalAmount = ? WHERE own_id = ? and coin_id = ?",coin.totalAmount,coin.own_id,coin.coin_id];
//    [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_closePrice = ? WHERE own_id = ? and coin_id = ?",coin.closePrice,coin.own_id,coin.coin_id];
//    [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_usdPrice = ? WHERE own_id = ? and coin_id = ?",coin.usdPrice,coin.own_id,coin.coin_id];
//    [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_recordType = ? WHERE own_id = ? and coin_id = ?",coin.recordType,coin.own_id,coin.coin_id];
//    [_db close];
//}
//- (void)deleteAllCoinsFromwallet:(walletModel *)wallet{
//    [_db open];
//    
//    [_db executeUpdate:@"DELETE FROM coinModel WHERE own_id = ?",wallet.ID];
//    
//    
//    [_db close];
//}
//#pragma mark--交易记录管理
////向币中添加交易记录
//- (void)addtrade:(TradeModel *)trade toCoin:(coinModel *)coin{
//    //根据coin是否拥有交易记录来添加trade_id
//    [_db open];
//    NSNumber *maxID = @(0);
//    
//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM trade where own_id = %@ ",coin.coin_id]];
//    
//    while ([res next]) {
//        if ([maxID integerValue] < [[res stringForColumn:@"trade_id"] integerValue]) {
//            maxID = @([[res stringForColumn:@"trade_id"] integerValue]);
//        }
//        
//    }
//    maxID = @([maxID integerValue] + 1);
//    
//    [_db executeUpdate:@"INSERT INTO trade(own_id,trade_id,trade_time,trade_amount,trade_txid,trade_blockHeight,trade_fee,trade_remark,trade_Toaddress,trade_from,trade_to,trade_walletID,trade_tradeType)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",coin.coin_id,maxID,trade.time,trade.amount,trade.txid,trade.blockHeight,trade.fee,trade.remark,trade.Toaddress,trade.from,trade.to,trade.walletID,trade.tradeType];
//    
//    [_db close];
//    
//}
////获取某种币的交易记录
//- (NSMutableArray *)getAlltradesFromCoin:(coinModel *)coin{
//    
//    [_db open];
//    NSMutableArray  *tradeArray = [[NSMutableArray alloc] init];
//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM trade where own_id = %@ and trade_walletID= %@",coin.coin_id,coin.own_id]];
//    while ([res next]) {
//        TradeModel *trade = [[TradeModel alloc] init];
//        trade.own_id = coin.coin_id;
//        trade.trade_id = @([[res stringForColumn:@"trade_id"] integerValue]);
//        trade.time = [res stringForColumn:@"trade_time"];
//        trade.amount =[res stringForColumn:@"trade_amount"];
//        trade.txid =[res stringForColumn:@"trade_txid"];
//        trade.blockHeight =[res stringForColumn:@"trade_blockHeight"];
//        trade.fee =[res stringForColumn:@"trade_fee"];
//        trade.remark=[res stringForColumn:@"trade_remark"];
//        trade.Toaddress=[res stringForColumn:@"trade_Toaddress"];
//        trade.from=[res stringForColumn:@"trade_from"];
//        trade.to=[res stringForColumn:@"trade_to"];
//        trade.walletID= @([[res stringForColumn:@"trade_walletID"] integerValue]);
//        trade.tradeType=[res stringForColumn:@"trade_tradeType"];
//        [tradeArray addObject:trade];
//        
//    }
//    [_db close];
//    
//    return tradeArray;
// 
//}
///**
// *  更新币种的某条交易记录
// *
// */
//
//- (void)updatetrade:(TradeModel*)trade toCoin:(coinModel *)coin{
//    [_db open];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_id = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.trade_id,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_time = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.time,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_amount = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.amount,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_txid = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.txid,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_blockHeight = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.blockHeight,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_fee = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.fee,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_remark = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.remark,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_Toaddress = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.Toaddress,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_from = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.from,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_to = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.to,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_walletID = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.walletID,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'trade' SET trade_tradeType = ? WHERE own_id = ? and trade_id = ? and trade_walletID= ?",trade.tradeType,coin.coin_id,trade.trade_id,coin.own_id];
//    [_db close];
//    
//}
///**
// *  删除币种所有交易记录
// *
// */
//- (void)deleteAlltradesFromCoin:(coinModel *)coin{
//    
//    [_db open];
//    
//    [_db executeUpdate:@"DELETE FROM trade WHERE own_id = ? and trade_walletID= ?",coin.coin_id,coin.own_id];
//    
//    [_db close];
//    
//    
//}
//
///**
// *  删除某个钱包内所有币种的交易记录
// *
// */
//- (void)deleteAlltradesFromWallet:(walletModel *)wallet{
//    [_db open];
//    
//    [_db executeUpdate:@"DELETE FROM trade WHERE  trade_walletID= ?",wallet.ID];
//    
//    
//    [_db close];
//    
//}
//
//#pragma mark--未花交易
//
////向币种添加未花交易
//- (void)addTransfer:(TransferModel *)transfer toCoin:(coinModel *)coin{
//    //根据coin是否有未花交易来添加transfer _id
//    [_db open];
//    NSNumber *maxID = @(0);
//    
//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM transfer where own_id = %@ ",coin.coin_id]];
//    
//    while ([res next]) {
//        if ([maxID integerValue] < [[res stringForColumn:@"transfer_id"] integerValue]) {
//            maxID = @([[res stringForColumn:@"transfer_id"] integerValue]);
//        }
//        
//    }
//    maxID = @([maxID integerValue] + 1);
//    
//    [_db executeUpdate:@"INSERT INTO transfer(own_id,transfer_id,transfer_address,transfer_amount,transfer_txid,transfer_walletID,transfer_tradeType,transfer_creatTime,transfer_nonce)VALUES(?,?,?,?,?,?,?,?,?)",coin.coin_id,maxID,transfer.address,transfer.amount,transfer.txid,transfer.walletID,transfer.transfeType,transfer.creatTime,transfer.nonce];
//    
//    [_db close];
//    
//}
//
//
////获取某种币的全部未花交易
//- (NSMutableArray *)getAllTransferFromCoin:(coinModel *)coin{
//    
//    [_db open];
//    NSMutableArray  *transferArray = [[NSMutableArray alloc] init];
//   FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM transfer where own_id = %@ and transfer_walletID= %@ and transfer_tradeType= %@",coin.coin_id,coin.own_id,coin.recordType]];
//   
//    while ([res next]) {
//        TransferModel *transfer = [[TransferModel alloc] init];
//        transfer.own_id = coin.coin_id;
//        transfer.transfer_id = @([[res stringForColumn:@"transfer_id"] integerValue]);
//        transfer.address = [res stringForColumn:@"transfer_address"];
//        transfer.amount =[res stringForColumn:@"transfer_amount"];
//        transfer.txid =[res stringForColumn:@"transfer_txid"];
//        transfer.walletID =@([[res stringForColumn:@"transfer_walletID"] integerValue]);
//        transfer.transfeType=[res stringForColumn:@"transfer_tradeType"];
//        transfer.creatTime=[res stringForColumn:@"transfer_creatTime"];
//        transfer.nonce=[res stringForColumn:@"transfer_nonce"];
//        [transferArray addObject:transfer];
//        
//    }
//    [_db close];
//    
//    return transferArray;
//    
//}
//
// //  删除某个钱包内所有币种的未花交易
//
//- (void)deleteAlltransfersFromWallet:(walletModel *)wallet{
//    [_db open];
//    
//    [_db executeUpdate:@"DELETE FROM transfer WHERE  transfer_walletID= ?",wallet.ID];
//    
//    
//    [_db close];
//}
//// 删除某个币种的未花交易
//- (void)deleteAlltransfersFromCoin:(coinModel *)coin{
//    [_db open];
//    
//    [_db executeUpdate:@"DELETE FROM transfer WHERE own_id = ? and transfer_walletID= ?",coin.coin_id,coin.own_id];
//    
//    
//    [_db close];
//}
//
//// 删除某个币种的一个未花交易
//- (void)deleteOnetransfers:(TransferModel*)transfer FromCoin:(coinModel *)coin{
//    [_db open];
//    
//    [_db executeUpdate:@"DELETE FROM transfer WHERE own_id = ? and transfer_walletID= ? and transfer_id= ?",coin.coin_id,coin.own_id,transfer.transfer_id];
//    
//    
//    [_db close];
//}
///**
// *  更新某个币种的未花交易
// *
// */
//
//- (void)updatetransfer:(TransferModel*)transfer toCoin:(coinModel *)coin{
//    [_db open];
//    [_db executeUpdate:@"UPDATE 'transfer' SET transfer_id = ? WHERE own_id = ? and transfer_id = ? and transfer_walletID= ?",transfer.transfer_id,coin.coin_id,transfer.transfer_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'transfer' SET transfer_address = ? WHERE own_id = ? and transfer_id = ? and transfer_walletID= ?",transfer.address,coin.coin_id,transfer.transfer_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'transfer' SET transfer_amount = ? WHERE own_id = ? and transfer_id = ? and transfer_walletID= ?",transfer.amount,coin.coin_id,transfer.transfer_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'transfer' SET transfer_txid = ? WHERE own_id = ? and transfer_id = ? and transfer_walletID= ?",transfer.txid,coin.coin_id,transfer.transfer_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'transfer' SET transfer_walletID = ? WHERE own_id = ? and transfer_id = ? and transfer_walletID= ?",transfer.walletID,coin.coin_id,transfer.transfer_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'transfer' SET transfer_tradeType = ? WHERE own_id = ? and transfer_id = ? and transfer_walletID= ?",transfer.transfeType,coin.coin_id,transfer.transfer_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'transfer' SET transfer_creatTime = ? WHERE own_id = ? and transfer_id = ? and transfer_walletID= ?",transfer.creatTime,coin.coin_id,transfer.transfer_id,coin.own_id];
//    [_db executeUpdate:@"UPDATE 'transfer' SET transfer_nonce = ? WHERE own_id = ? and transfer_id = ? and transfer_walletID= ?",transfer.nonce,coin.coin_id,transfer.transfer_id,coin.own_id];
//    [_db close];
//    
//}
//@end
