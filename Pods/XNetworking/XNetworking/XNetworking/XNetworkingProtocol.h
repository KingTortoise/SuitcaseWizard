//
//  XNetworkingProtocol.h
//  XNetworking
//
//  Created by 金建新 on 16/8/8.
//  Copyright © 2016年 金建新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNServerProtocol.h"

@protocol XNHTTPExecutorProtocol;
@class XNRequest;
@class XNResponse;

typedef void (^XNCallback)(XNRequest *request, XNResponse* response);

typedef NS_ENUM (NSUInteger, XNRequestErrorType){
    XNRequestErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    XNRequestErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    XNRequestErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    XNRequestErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    XNRequestErrorTypeTimeout,       //请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    XNRequestErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, XNRequestMethod){
    XNRequestMethodGet = 0,
    XNRequestMethodPost
};


@protocol XNRequestProtocol <NSObject>

@optional

/** 默认为 GET方法 */
- (XNRequestMethod)method;
/** 默认为 不使用缓存 */
- (BOOL)shouldCache;
/** 默认为 不使用https */
- (BOOL)shouldHttps;
/** 默认为 XNHTTPExecutorAF */
- (id<XNHTTPExecutorProtocol>)httpExecutor;
/** 该请求使用的服务器对象 */
- (id<XNServerProtocol>)server;

/** 上传文件 */
- (NSData *)uploadFile;
- (NSString *)uploadFileName;
- (NSString *)uploadMimeType;

@required

- (NSString *)apiPath;
- (NSDictionary *)assembleParams;

@end

@protocol XNRequestCallbackDelegate <NSObject>

@required
- (void)requestDidSucceed:(XNRequest *)request;
- (void)requestDidFailed:(XNRequest *)request;

@end


typedef NSInteger XNRequestID;

@protocol XNHTTPExecutorProtocol <NSObject>

@property (nonatomic, assign) NSInteger timeout;
@property (nonatomic, strong) NSArray *responseAcceptContentTypes;

+ (instancetype)sharedInstance;


/**
 GET请求

 @param URLString  url
 @param parameters 参数
 @param finished   完成回调

 @return 请求任务
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     finished:(void (^)(NSURLSessionDataTask *task, XNResponse *responseObject))finished;


/**
 POST请求

 @param URLString  url
 @param parameters 参数
 @param finished   完成回调

 @return 请求任务
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      finished:(void (^)(NSURLSessionDataTask *task, XNResponse *responseObject))finished;

- (void)FORM:(NSData *)fileData
         url:(NSString *)URLString
  parameters:(id)parameters
    mimeType:(NSString *)mimeType
    fileName:(NSString *)fileName
    finished:(void (^)(NSURLSessionDataTask *task, XNResponse *responseObject))finished;

- (NSURLSessionDataTask *)AFFORM:(NSData *)fileData
                             url:(NSString *)URLString
                      parameters:(id)parameters
                        mimeType:(NSString *)mimeType
                        fileName:(NSString *)fileName
                        finished:(void (^)(NSURLSessionDataTask *, XNResponse *))finished;

@end
