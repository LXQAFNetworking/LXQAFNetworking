//
//  LXQAFNetworking.h
//  百思不得姐
//
//  Created by 刘鑫奇 on 16/10/10.
//  Copyright © 2016年 刘鑫奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXQAFNetworking : NSObject
typedef void (^BlockOfSuccess)(id result);
typedef void (^BlockOfFailure)(NSError *error);

typedef NS_ENUM(NSUInteger, LXQResult) {
    LXQData,
    LXQJSON,
    LXQXML,
};

typedef NS_ENUM(NSUInteger, LXQRequestStyle) {
    LXQRequestJSON,
    LXQRequestString,
};

+ (instancetype)manager;
/**
 *  面向对象也叫 面向接口编程
 */

/**
 *  Get 请求
 *
 *  @param url        网络数据请求地址
 *  @param body       请求体
 *  @param result     返回数据的类型
 *  @param headerFile 请求头
 *  @param success    网络请求成功回调
 *  @param failure    网络请求失败回调
 */
- (void)getNetWithURL:(NSString *)url
                 body:(id)body
           resultKind:(LXQResult)result
           headerFile:(NSDictionary *)headerFile
              success:(BlockOfSuccess)success
              failure:(BlockOfFailure)failure;


/**
 *  POST请求
 *
 *  @param url          网络请求地址
 *  @param body         请求体
 *  @param result       返回的数据类型
 *  @param requestStyle 网络请求Body的类型
 *  @param headerFile   网络请求头
 *  @param success      成功回调
 *  @param failure      失败回调
 */

- (void)PostNetWithURL:(NSString *)url
                  body:(id)body
            resultKind:(LXQResult)result
          requsetStyle:(LXQRequestStyle)requestStyle
            headerFile:(NSDictionary *)headerFile
               success:(BlockOfSuccess)success
               failure:(BlockOfFailure)failure;

/**
 *  SOAPPOST请求
 *
 *  @param url          网络请求地址
 *  @param method       请求方法
 *  @param soapBody     请求体
 *  @param success      成功回调
 *  @param failure      失败回调
 */

- (void)SOAPData:(NSString *)url method:(NSString *)method soapBody:(NSDictionary *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end
