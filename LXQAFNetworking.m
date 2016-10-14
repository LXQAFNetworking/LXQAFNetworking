//
//  LXQAFNetworking.m
//  百思不得姐
//
//  Created by 刘鑫奇 on 16/10/10.
//  Copyright © 2016年 刘鑫奇. All rights reserved.
//

#import "LXQAFNetworking.h"
#import <AFNetworking.h>
#import "LXQAFNforSoapParameter.h"

@implementation LXQAFNetworking

+ (instancetype)manager {
    return [[[self class] alloc] init];
}

- (void)getNetWithURL:(NSString *)url
                 body:(id)body
           resultKind:(LXQResult)result
           headerFile:(NSDictionary *)headerFile
              success:(BlockOfSuccess)success
              failure:(BlockOfFailure)failure{
    
    
    //1.  设置网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.  设置请求头
    if (headerFile) {
        for (NSString *key in headerFile.allKeys) {
            [manager.requestSerializer setValue:headerFile[key] forHTTPHeaderField:key];
        }
    }
    
    //3.  设置返回数据类型
    switch (result) {
        case LXQJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case LXQXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case LXQData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    //4. 设置响应数据类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", nil]];
    
    // 5. UTF-8转码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // 6. 请求数据
    [manager GET:url parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            // 成功回调
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);

        
    }];
    
}

- (void)PostNetWithURL:(NSString *)url
                  body:(id)body
            resultKind:(LXQResult)result
          requsetStyle:(LXQRequestStyle)requestStyle
            headerFile:(NSDictionary *)headerFile
               success:(BlockOfSuccess)success
               failure:(BlockOfFailure)failure{
    //1.  设置网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.  设置请求头
    if (headerFile) {
        for (NSString *key in headerFile.allKeys) {
            [manager.requestSerializer setValue:headerFile[key] forHTTPHeaderField:key];
        }
    }
    
    //3.  设置返回数据类型
    switch (result) {
        case LXQJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case LXQXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case LXQData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    //4. 设置响应数据类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", nil]];
    
    // 5. UTF-8转码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // 6. 请求数据
    [manager POST:url parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            // 成功回调
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}


- (void)SOAPData:(NSString *)url method:(NSString *)method soapBody:(NSDictionary *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    
    
    NSString * parame = [self soapRequestOfParameter:soapBody];

    //    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://impl.service.iloan.yingCanTechnology.com">
    
    NSString *soapStr = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"http://impl.service.iloan.yingCanTechnology.com\">\
                         <soap:Header>\
                         </soap:Header>\
                         <soap:Body><%@>%@</%@></soap:Body>\
                         </soap:Envelope>",method,[parame stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"],method];
    
//    NSLog(@"%@",soapStr);

    //
//    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];

    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 返回数据
//    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置响应数据类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml",@"application/xml",@"application/soap+xml",@"text/xml", nil]];

    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapStr.length] forHTTPHeaderField:@"Content-Length"];
 
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapStr;
    }];
    
    //过滤特殊符号
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    
    [manager POST:url parameters:soapStr progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//
//        // 利用正则表达式取出<return></return>之间的字符串，妈的返回数据的格式还跟别人不一样，奶奶的
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"(?<=ns:return>).*(?=</ns:return)" options:NSRegularExpressionCaseInsensitive error:nil];
//
        NSDictionary *dict = [NSDictionary dictionary];
        for (NSTextCheckingResult *checkingResult in [regular matchesInString:result options:0 range:NSMakeRange(0, result.length)]) {
//            // 得到字典
            dict = [NSJSONSerialization JSONObjectWithData:[[result substringWithRange:checkingResult.range] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        }
        // 请求成功并且结果有值把结果传出去
        if (success ) {
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSLog(@"%@",error);
        }
    }];
}


- (NSMutableString *)soapRequestOfParameter:(NSDictionary *)Parameter
{
    NSMutableArray* params = [NSMutableArray array];
//    [Parameter enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"key = %@ and obj = %@", key, obj);
//       [params addObject:[[LXQAFNforSoapParameter alloc] initWithValue: obj forName: @"key"]];
//    }];
    NSMutableArray* keys = [NSMutableArray array];
    NSMutableArray* values = [NSMutableArray array];

    for (NSString *s in [Parameter allValues]) {
        [values addObject:s];
    }
    
    for (NSString *s in [Parameter allKeys]) {
        [keys addObject:s];
    }
    if (keys.count != values.count) {
        LXQALERT_SHOW(@"参数有问题");
    }else{
        for (int i = 0; i < keys.count; i++) {
            [params addObject:[[LXQAFNforSoapParameter alloc] initWithValue: values[i]  forName: [NSString stringWithFormat:@"%@",keys[i]]]];
        }
    }
    NSMutableString* s = [NSMutableString string];
    
    for(LXQAFNforSoapParameter* p in params) {
        [s appendString: p.xml];
    }
    
    
    return s;
}

@end

