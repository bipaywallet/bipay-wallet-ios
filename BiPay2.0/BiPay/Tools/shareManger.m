
//
//  shareManger.m
//  Bipay 2.0
//
//  Created by sunliang on 2018/7/27.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "shareManger.h"
#import <CoreData/CoreData.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信
#import "WXApi.h"



static shareManger *_engine;
@implementation shareManger
{
    BOOL isOK;
}
+ (shareManger *)defaultShareManger{
    @synchronized (self) {
        if (_engine == nil) {
            _engine = [[shareManger alloc]init];
        }
    }
    return _engine;
}
- (void)registerClients{
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformSubTypeWechatSession),
                                                                                                @(SSDKPlatformSubTypeWechatTimeline)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;

             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {

         switch (platformType)
         {

             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WeChatID
                                       appSecret:WeChatSecret];
                 break;

             default:
                 break;
         }
     }];

}

//微信好友
- (void)shareWithWxiFriend:(NSDictionary *)dic{
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:[self setShareComparment:dic] onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == 1) {
            [self addPointWithShareSuccessed];
        }
    }];
}
//朋友圈
- (void)shareWithWxiFriendQuan:(NSDictionary *)dic{
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:[self setShareComparment:dic] onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == 1) {
            [self addPointWithShareSuccessed];
        }
    }];
}

- (NSMutableDictionary *)setShareComparment:(NSDictionary *)dic{
    //1、创建分享参数
    UIImage *shareImage = [dic objectForKey:@"Screenshot"];//截屏图片
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"Bipay"
                                     images:shareImage
                                        url:nil
                                      title:@"Bipay"
                                       type:SSDKContentTypeAuto];
    return shareParams;
}


//分享成功
- (void)addPointWithShareSuccessed{
  
    NSLog(@"分享成功");
}
@end
