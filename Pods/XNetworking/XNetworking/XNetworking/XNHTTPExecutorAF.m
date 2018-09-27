//
//  XNHTTPExecutorAF.m
//  XNetworking
//
//  Created by 金建新 on 16/8/12.
//  Copyright © 2016年 金建新. All rights reserved.
//

#import "XNHTTPExecutorAF.h"
#import <AFNetworking/AFNetworking.h>
#import "XNResponse.h"
#import "XNResponse.h"

#define HTTP_TIMEOUT                    40

@interface XNHTTPExecutorAF ()
{
    AFHTTPSessionManager *sessionManager;
}
@end

@implementation XNHTTPExecutorAF

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XNHTTPExecutorAF *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XNHTTPExecutorAF alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        sessionManager = [AFHTTPSessionManager manager];
        sessionManager.requestSerializer.timeoutInterval = HTTP_TIMEOUT;
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        sessionManager.securityPolicy = securityPolicy;
    }
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      finished:(void (^)(NSURLSessionDataTask *task, XNResponse *responseObject))finished
{
    NSURLSessionDataTask *task = [sessionManager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        XNResponse *response = [[XNResponse alloc] initWithContent:responseObject requestTask:task error:nil];
        finished(task, response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XNResponse *response = [[XNResponse alloc] initWithContent:nil requestTask:task error:error];
        finished(task, response);
    }];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       finished:(void (^)(NSURLSessionDataTask *task, XNResponse *responseObject))finished
{
    NSURLSessionDataTask *task = [sessionManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        XNResponse *response = [[XNResponse alloc] initWithContent:responseObject requestTask:task error:nil];
        finished(task, response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XNResponse *response = [[XNResponse alloc] initWithContent:nil requestTask:task error:error];
        finished(task, response);
    }];
    return task;
}

#pragma clang diagnostic ignored "-Wuninitialized"
- (void)FORM:(NSData *)fileData
         url:(NSString *)URLString
  parameters:(id)parameters
    mimeType:(NSString *)mimeType
    fileName:(NSString *)fileName
    finished:(void (^)(NSURLSessionDataTask *task, XNResponse *responseObject))finished
{
    NSString *tmpFilename = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
    NSURL *tmpFileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:tmpFilename]];
    NSMutableURLRequest *mutilRequest = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
    } error:nil];
    [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:mutilRequest writingStreamContentsToFile:tmpFileURL completionHandler:^(NSError * _Nullable error) {
        AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:mutilRequest fromFile:tmpFileURL progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [[NSFileManager defaultManager]removeItemAtURL:tmpFileURL error:nil];
            if (finished) {
                XNResponse *response = [[XNResponse alloc] initWithContent:responseObject requestTask:uploadTask error:error];
                finished(uploadTask, response);
            }
        }];
        [uploadTask resume];
    }];
}

- (NSURLSessionDataTask *)AFFORM:(NSData *)fileData
           url:(NSString *)URLString
    parameters:(id)parameters
      mimeType:(NSString *)mimeType
      fileName:(NSString *)fileName
      finished:(void (^)(NSURLSessionDataTask *, XNResponse *))finished
{
    NSURLSessionDataTask *task = [sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        XNResponse *response = [[XNResponse alloc] initWithContent:responseObject requestTask:task error:nil];
        finished(task, response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XNResponse *response = [[XNResponse alloc] initWithContent:nil requestTask:task error:error];
        finished(task, response);
    }];
    return task;
}

@end
