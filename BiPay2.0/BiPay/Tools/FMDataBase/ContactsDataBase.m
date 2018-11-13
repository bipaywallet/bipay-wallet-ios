//
//  ContactsDataBase.m
//  BiPay
//
//  Created by sunliang on 2018/8/18.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ContactsDataBase.h"
#import <FMDB.h>
#import "contactsModel.h"
#import "coinModel.h"
static ContactsDataBase *_DBCtl = nil;

@interface ContactsDataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
    
}

@end
@implementation ContactsDataBase
+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[ContactsDataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"contacts.sqlite"];
    
    // 实例化FMDataBase对象
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表
    NSString *contactSql = @"CREATE TABLE IF NOT EXISTS 'contactModel' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'contactModel_id' VARCHAR(255),'contactModel_name' VARCHAR(255),'contactModel_phone' VARCHAR(255),'contactModel_email'VARCHAR(255),'contactModel_remark'VARCHAR(255)) ";
    NSString *coinSql = @"CREATE TABLE IF NOT EXISTS 'coinModel' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'coin_id' VARCHAR(255),'coinModel_brand' VARCHAR(255),'coinModel_address'VARCHAR(255)) ";
    [_db executeUpdate:contactSql];
    [_db executeUpdate:coinSql];
    [_db close];
}
#pragma mark - 接口

- (void)addContact:(contactsModel *)contact{
    [_db open];
    
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM contactModel "];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"contactModel_id"] integerValue]) {
            maxID = @([[res stringForColumn:@"contactModel_id"] integerValue] ) ;
        }
        
    }
    maxID = @([maxID integerValue] + 1);
    
    [_db executeUpdate:@"INSERT INTO contactModel(contactModel_id,contactModel_name,contactModel_phone,contactModel_email,contactModel_remark)VALUES(?,?,?,?,?)",maxID,contact.name,contact.phone,contact.email,contact.remark];
    
    
    
    [_db close];
    
}

- (void)deleteContact:(contactsModel *)contact{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM contactModel WHERE contactModel_id = ?",contact.ID];
    
    [_db close];
}

- (void)updateContact:(contactsModel *)contact{
    [_db open];
    
    [_db executeUpdate:@"UPDATE 'contactModel' SET contactModel_name = ?  WHERE contactModel_id = ? ",contact.name,contact.ID];
    [_db executeUpdate:@"UPDATE 'contactModel' SET contactModel_phone = ?  WHERE contactModel_id = ? ",contact.phone,contact.ID];
    [_db executeUpdate:@"UPDATE 'contactModel' SET contactModel_email = ?  WHERE contactModel_id = ? ",contact.email ,contact.ID];
    [_db executeUpdate:@"UPDATE 'contactModel' SET contactModel_remark = ?  WHERE contactModel_id = ? ",contact.remark ,contact.ID];
    
    
    [_db close];
}

- (NSMutableArray *)getAllcontact{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM contactModel"];
    
    while ([res next]) {
        contactsModel *contact = [[contactsModel alloc] init];
        contact.ID = @([[res stringForColumn:@"contactModel_id"] integerValue]);
        contact.name = [res stringForColumn:@"contactModel_name"];
        contact.phone = [res stringForColumn:@"contactModel_phone"];
        contact.email = [res stringForColumn:@"contactModel_email"];
        contact.remark = [res stringForColumn:@"contactModel_remark"];
        [dataArray addObject:contact];
        
    }
    
    [_db close];
    return dataArray;
    
}
/**
 *  给contact添加币种
 *
 */
- (void)addcoin:(coinModel *)coin toContact:(contactsModel *)contact{
    [_db open];
    
    //根据contact是否拥有coin来添加coin_id
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM coinModel where own_id = %@ ",contact.ID]];
    
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"coin_id"] integerValue]) {
            maxID = @([[res stringForColumn:@"coin_id"] integerValue]);
        }
        
    }
    maxID = @([maxID integerValue] + 1);
    
    [_db executeUpdate:@"INSERT INTO coinModel(own_id,coin_id,coinModel_brand,coinModel_address)VALUES(?,?,?,?)",contact.ID,maxID,coin.brand,coin.address];
    
    
    [_db close];
    
}
/**
 *  给contact删除币种
 *
 */
- (void)deletecoin:(coinModel *)coin fromContact:(contactsModel *)contact{
    [_db open];
    
    
    [_db executeUpdate:@"DELETE FROM coinModel WHERE own_id = ?  and coin_id = ? ",contact.ID,coin.coin_id];
    
    [_db close];
    
    
    
}
/**
 *  获取contact的所有币种
 *
 */
- (NSMutableArray *)getAllCoinsFromContact:(contactsModel *)contact{
    
    [_db open];
    NSMutableArray  *coinArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM coinModel where own_id = %@",contact.ID]];
    while ([res next]) {
        coinModel *coin = [[coinModel alloc] init];
        coin.own_id = contact.ID;
        coin.coin_id = @([[res stringForColumn:@"coin_id"] integerValue]);
        coin.brand = [res stringForColumn:@"coinModel_brand"];
        coin.address = [res stringForColumn:@"coinModel_address"];
        [coinArray addObject:coin];
        
    }
    [_db close];
    
    return coinArray;
    
}

- (void)updatecoin:(coinModel *)coin toContact:(contactsModel *)contact
{
    [_db open];
    [_db executeUpdate:@"UPDATE 'coinModel' SET coin_id = ? WHERE own_id = ? and coin_id = ?",coin.coin_id,contact.ID,coin.coin_id];
    [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_brand = ? WHERE own_id = ? and coin_id = ?",coin.brand,contact.ID,coin.coin_id];
    [_db executeUpdate:@"UPDATE 'coinModel' SET coinModel_address = ? WHERE own_id = ? and coin_id = ?",coin.address,contact.ID,coin.coin_id];
    
    [_db close];
}
- (void)deleteAllCoinsFromContact:(contactsModel *)contact{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM coinModel WHERE own_id = ?",contact.ID];
    
    [_db close];
}

@end
