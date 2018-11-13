/**
 *  ReadMe:
 *  AboutLog:
 *  >>>>> 代表请求出的信息
 *  <<<<< 代表获取到的信息
 *
 */

#import "RequestManager.h"
//#import "URLManager.h"
#import "AFNetworkActivityIndicatorManager.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#import "AFHTTPSessionManager.h"
#endif

@implementation MKRequestTask

- (instancetype)initWithTaskOrOperation:(id)obj
{
    self = [super init];
    if (self) {
        _sessionTaskOrOperation = obj;
    }
    return self;
}

- (void)cancel
{
    if ([_sessionTaskOrOperation respondsToSelector:@selector(cancel)]) {
        [_sessionTaskOrOperation cancel];
    }
}
@end

@implementation RequestManager

//post请求
+ (MKRequestTask *)postRequestWithURLPath:(NSString *)requestPath withParamer:(NSMutableDictionary *)paramer completionHandler:(RequestCompletionHandler)completionHandler failureHandler:(FailureHandler)failureHandler{
        //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 
    //设置响应数据的格式
    //AFHTTPResponseSerializer 返回的数据类型为二进制类型
    //AFJSONResponseSerializer 返回数据类型为json类型
    //AFXMLParserResponseSerializer xml类型
    manager.requestSerializer.timeoutInterval = 15.f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    [manager.requestSerializer setValue:APIKEY forHTTPHeaderField:@"api-key"];
    [manager.requestSerializer setValue:[ToolUtil hmac:paramer withKey:Secret] forHTTPHeaderField:@"sign"];
    [manager.requestSerializer setValue:BusinessID forHTTPHeaderField:@"x-auth-token"];
    [manager POST:requestPath parameters:paramer progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        DLog(@"222%@ ------ %@",requestPath,paramer);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSString *dataStr =[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        
        NSData *resData = [[NSData alloc] initWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        //2.将NSData解析为NSDictionary
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:kNilOptions error:nil];
            completionHandler(resultDic);
 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        DLog(@"%@",error);
//        NSError * e = [[NSError alloc] initWithDomain:error.userInfo[@"NSLocalizedDescription"] code:error.code userInfo:error.userInfo];
//        error = e;
        failureHandler(error,0);
        
        
    }];
  
    return nil;
    

}

//get请求
+ (MKRequestTask *) getRequestWithURLPath:(NSString *)requestPath withParamer:(NSMutableDictionary *)paramer completionHandler:(RequestCompletionHandler)completionHandler failureHandler:(FailureHandler)failureHandler{
    
    
    NSLog(@"获取表头的信息是:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);

  
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置响应数据的格式
    //AFHTTPResponseSerializer 返回的数据类型为二进制类型
    //AFJSONResponseSerializer 返回数据类型为json类型
    //AFXMLParserResponseSerializer xml类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //解决https证书问题
    //把服务端证书（需要转换成cer格式）放到app项目资源里，AFSecurityPolicy会自动寻找根目录下所有cer文件
//    AFSecurityPolicy * securityP = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityP.allowInvalidCertificates = YES;
//    manager.securityPolicy = securityP;
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"APPTYPE"];
    
    
    [manager GET:requestPath parameters:paramer progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *dataStr =[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *resData = [[NSData alloc] initWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
        //2.将NSData解析为NSDictionary
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:kNilOptions error:nil];
        DLog(@"%@",resultDic);
            completionHandler(resultDic[@"data"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError * e = [[NSError alloc] initWithDomain:error.userInfo[@"NSLocalizedDescription"] code:error.code userInfo:error.userInfo];
        error = e;
        failureHandler(error,0);
    }];
    
    return nil;
}
//拼接
+ (NSString *)requestURLGenetatedWithURL:(NSString *const) path
{
    return [HOST stringByAppendingString:path];
}

@end
