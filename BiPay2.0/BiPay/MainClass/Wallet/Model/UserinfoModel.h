//
//  UserinfoModel.h
//  BiPay
//
//  Created by sunliang on 2018/8/6.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserinfoModel : NSObject
@property (nonatomic, strong) walletModel* wallet;
@property(nonatomic,strong) NSArray*Namearray;//存储支持的币种名称
@property(nonatomic,strong) NSArray*englishNameArray;//币种英文全称
@property(nonatomic,strong) NSArray*coinTypeArray;//存储支持的币种cointype
@property(nonatomic,strong) NSArray*PriveprefixTypeArray;//比特币系列增加整型的prefix参数，用于衍生代币的地址前缀，其它币暂时可任意值
@property(nonatomic,strong) NSArray*AddressprefixTypeArray;//比特币系列增加整型的prefix参数，用于衍生代币的地址前缀，其它币暂时可任意值]//地址前缀
@property(nonatomic,strong) NSArray*tradeTypeArray;//存储支持的币种交易类型
+(UserinfoModel *)shareManage;
-(void)reloadLocalDataWithWallet:(walletModel*)model;
@property (nonatomic,strong) NSMutableArray *marketArray;//行情数组
@property (nonatomic,strong) NSMutableArray *dataArray;//数据源
@end
