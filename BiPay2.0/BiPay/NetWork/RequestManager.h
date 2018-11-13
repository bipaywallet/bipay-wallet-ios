 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "AFHTTPRequestOperationManager.h"

typedef void(^RequestCompletionHandler)(id responseObject);
typedef void(^ProgressHandler)(CGFloat progress);
typedef void(^FailureHandler)(NSError *error,NSUInteger statusCode);

@interface MKRequestTask : NSObject
@property(strong, nonatomic)id sessionTaskOrOperation;
-(void)cancel;
@end

@interface RequestManager : NSObject

#pragma mark --
#pragma mark --  POST
+ (MKRequestTask *) postRequestWithURLPath:(NSString *)requestPath withParamer:(NSMutableDictionary *)paramer completionHandler:(RequestCompletionHandler)completionHandler failureHandler:(FailureHandler)failureHandler;

#pragma mark --
#pragma mark --  GET
+ (MKRequestTask *) getRequestWithURLPath:(NSString *)requestPath withParamer:(NSMutableDictionary *)paramer completionHandler:(RequestCompletionHandler)completionHandler failureHandler:(FailureHandler)failureHandler;

+ (NSString *)requestURLGenetatedWithURL:(NSString *const) path;


@end
