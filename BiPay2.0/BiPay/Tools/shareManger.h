//
//  shareManger.h
//  Bipay 2.0
//
//  Created by sunliang on 2018/7/27.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shareManger : NSObject
+ (shareManger *)defaultShareManger;
- (void)registerClients;//注册mob
//分享
- (void)shareWithWxiFriend:(NSDictionary *)dic;//微信好友
- (void)shareWithWxiFriendQuan:(NSDictionary *)dic;//微信朋友圈

@end
