//
//  UserinfoModel.m
//  BiPay
//
//  Created by sunliang on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UserinfoModel.h"
#import "marketModel.h"
#import "HomeNetManager.h"
@implementation UserinfoModel
static UserinfoModel *_ModelClass;

+(UserinfoModel *)shareManage
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        _ModelClass = [[UserinfoModel alloc]init];
        _ModelClass.Namearray=[NSArray arrayWithObjects:@"BTC",@"BCH",@"ETH",@"LTC",@"USDT",@"XNE",@"GCA",@"GCB",@"GCC",@"STO",@"QTUM",@"DASH",@"ZEC",@"ETC",nil];
        _ModelClass.englishNameArray=[NSArray arrayWithObjects:@"Bitcoin",@"Bitcoincash",@"Ethereum",@"Litecoin",@"USDT",@"XNE",@"GCA",@"GCB",@"GalaxyChain",@"STO",@"QTUM",@"DASH",@"Zcash",@"EthereumClassic",nil];
        _ModelClass.coinTypeArray=[NSArray arrayWithObjects:@"0",@"145",@"60",@"2",@"0",@"208",@"500",@"501",@"502",@"99",@"2301",@"5",@"133",@"61", nil];
        _ModelClass.PriveprefixTypeArray=[NSArray arrayWithObjects:@"128",@"128",@"-1",@"176",@"128", @"176",@"176",@"176",@"176",@"176",@"128",@"204",@"128",@"-1",nil];
        _ModelClass.AddressprefixTypeArray=[NSArray arrayWithObjects:@"0",@"0",@"-1",@"48",@"0", @"75",@"38",@"25",@"26",@"63",@"58",@"76",@"35",@"-1",nil];
        _ModelClass.recordTypeArray=[NSArray arrayWithObjects:@"0",@"0",@"1",@"0",@"2",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"1",nil];

    });
    
    return _ModelClass;
}
-(void)reloadLocalDataWithWallet:(walletModel*)model{
    
    [self getMarketPricWithWallet:model];
    
}
/**
 火币数据
 */
-(void)getMarketPricWithWallet:(walletModel*)walletmodel{
    
    [RequestManager postRequestWithURLPath:@"http://www.qkljw.com/app/Kline/get_currency_data" withParamer:[[NSMutableDictionary alloc]init] completionHandler:^(id responseObject) {
        self.marketArray = [marketModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSArray *Namearray=[UserinfoModel shareManage].Namearray;
        [Namearray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString*coinName=Namearray[idx];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",coinName];
            NSArray*filteredArray = [self.marketArray  filteredArrayUsingPredicate:predicate];
            if (filteredArray.count==0) {
                if ([coinName isEqualToString:@"USDT"]) {
                    marketModel*USDTmodel=[[marketModel alloc]init];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"ETH"];
                    NSArray *filteredArray = [self.marketArray  filteredArrayUsingPredicate:predicate];
                    marketModel*ethcoin=[filteredArray firstObject];
                    USDTmodel.name=@"USDT";
                    USDTmodel.close_rmb=[NSString stringWithFormat:@"%.2f",[ethcoin.close_rmb doubleValue]/[ethcoin.close doubleValue]];
                    USDTmodel.close=@"1.00";
                    [self.marketArray addObject:USDTmodel];
                }else{
                    marketModel*otherModel=[[marketModel alloc]init];
                    otherModel.name=coinName;
                    otherModel.close_rmb=@"0.00";
                    otherModel.close=@"0.00";
                    [self.marketArray addObject:otherModel];
                }
            }
        }];
        [self checKMoneyAddressWithWallet:walletmodel];//查询币种地址余额
        
    } failureHandler:^(NSError *error, NSUInteger statusCode) {
        
    }];
    
    
}
#pragma mark--根据币地址查询余额
-(void)checKMoneyAddressWithWallet:(walletModel*)walletModel{
    DNWeak(self);
    NSMutableArray*dataArray=(NSMutableArray*) [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:walletModel.bg_id],[NSObject bg_sqlKey:@"collect"],[NSObject bg_sqlValue:@(1)]]];
    self.dataArray=[self sortwithArray:dataArray];
    //遍历数组
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        coinModel*coinmodel=weakself.dataArray[idx];
        [self.marketArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            marketModel*marketmodel=weakself.marketArray[idx];
            if ([marketmodel.name isEqualToString:coinmodel.brand]) {
                coinmodel.closePrice=marketmodel.close_rmb;
                coinmodel.usdPrice=marketmodel.close;
                //更新
                [coinmodel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:walletModel.bg_id],[NSObject bg_sqlKey:@"bg_id"], [NSObject bg_sqlValue:coinmodel.bg_id]]];
                NSString*coinname;
                if ([coinmodel.brand isEqualToString:@"USDT"]) {
                    coinname=@"OMNI";
                }else{
                    coinname=coinmodel.brand ;
                }
                [HomeNetManager coinNamechecksingleAddress:coinmodel.address coinName:coinname CompleteHandle:^(id resPonseObj, int code,NSString*coinName) {//查询地址余额
                    if (code) {
                        if ([resPonseObj[@"code"] integerValue] == 0) {
                            if (![resPonseObj[@"data"] isKindOfClass:[NSArray class]]) {
                              
                                return ;
                            }
                            NSDictionary*dic=[resPonseObj[@"data"] firstObject];
                            //科学计数法转化成字符串
                            NSString*address=dic[@"address"];
                            if ([address isEqualToString:coinmodel.address]&&[[coinName uppercaseString] isEqualToString:coinname]) {
                                if ([coinmodel.recordType intValue]==1) {
                                    //ETH类
                                    coinmodel.totalAmount=[NSString stringWithFormat:@"%.8f",[dic[@"totalAmount"] doubleValue]/pow(10, 18)];
                                }else{
                                    //BTC类
                                    coinmodel.totalAmount=[NSString stringWithFormat:@"%.8f",[dic[@"totalAmount"] doubleValue]/pow(10, 8)];
                                }
                                //更新数据
                                [coinmodel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@" ,[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:walletModel.bg_id],[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:coinmodel.bg_id]]];
                                
                            }
                            
                            
                        }else{
                          
                        }
                    }else{
                        
                    }
                }];
            }
            
        }];
    }];
}
-(NSMutableArray*)sortwithArray:(NSMutableArray*)dataArray{
    
    NSArray *sortArray = [dataArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                          {
                              coinModel *Model1 = obj1;
                              coinModel *Model2 = obj2;
                              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                              [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                              NSDate *date1= [dateFormatter dateFromString:Model1.addtime];
                              NSDate *date2= [dateFormatter dateFromString:Model2.addtime];
                              if (date1 == [date1 earlierDate: date2]) { //不使用intValue比较无效
                                  return NSOrderedAscending;//降序
                              }else if (date1 == [date1 laterDate: date2]) {
                                  return NSOrderedDescending;//
                              }
                              else{
                                  return NSOrderedSame;//相等
                              }
                          }];
    return [NSMutableArray arrayWithArray:sortArray];
}
@end
