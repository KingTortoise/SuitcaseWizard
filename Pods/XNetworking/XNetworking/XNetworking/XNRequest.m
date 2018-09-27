//
//  XNBaseRequest.m
//  XNetworking
//
//  Created by 金建新 on 16/8/8.
//  Copyright © 2016年 金建新. All rights reserved.
//

#import "XNRequest.h"
#import "XNServerProtocol.h"
#import "XNHTTPExecutorAF.h"
#import "XNResponse.h"
#import "XDefine.h"
#import "XNServerConfiguraion.h"

#define kXNCacheDefaultFlag         NO

@interface XNRequest ()

@property (nonatomic, weak) id<XNRequestProtocol> derivative;
@property (nonatomic, weak) id<XNServerProtocol> defaultServer;

@property (nonatomic, copy) XNCallback completionHandler;


@property (nonatomic, assign) BOOL cancelled;

@end

@implementation XNRequest


#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupDefaultConfig];
        
        if ([self conformsToProtocol:@protocol(XNRequestProtocol)]) {
            self.derivative = (id <XNRequestProtocol>)self;
        } else {
            @throw [NSException exceptionWithName:@"XNRequest init failed!" reason:@"Request instance should implements XNRequestProtocol!" userInfo:nil];
        }
    }
    return self;
}

- (void)setupDefaultConfig {
    _cached = kXNCacheDefaultFlag;
    self.defaultServer = [XNServerConfiguraion shareInstance].defaultServer;
}

- (BOOL)isFinished {
    return self.urlSessionTask.state == NSURLSessionTaskStateCompleted;
}

- (id<XNServerProtocol>)getTheServer
{
    id<XNServerProtocol> server = nil;
    if (self.defaultServer) {
        server = self.defaultServer;
    }
    if ([self.derivative respondsToSelector:@selector(server)]) {
        server = [self.derivative server];
    }
    if (server == nil) {
        @throw [NSException exceptionWithName:@"XNRequest have no server configuration!" reason:@"XNRequest should have a server configuration!" userInfo:nil];
    }
    return server;
}

- (void)dealloc
{
    if (self.urlSessionTask.state == NSURLSessionTaskStateRunning) {
        [self cancel];
    }
    NSLog(@"XNRequest dealloc");
}

#pragma mark - action methods

- (NSString *)urlPrefix {
    
    NSString *host = [self getTheServer].host;
    if ([host hasPrefix:@"http"]) {
        return host;
    }
    BOOL useHttps = [_derivative respondsToSelector:@selector(shouldHttps)] ? [_derivative shouldHttps] : NO;
    if (useHttps) {
        return [@"https://" stringByAppendingString:host];
    }else {
        return [@"http://" stringByAppendingString:host];
    }
}

- (id<XNHTTPExecutorProtocol>)currentHttpExecutor {
    if ([self.derivative respondsToSelector:@selector(httpExecutor)]) {
        return [self.derivative httpExecutor];
    }else {
        return [XNHTTPExecutorAF sharedInstance];
    }
}

- (void)request:(XNCallback)finished {
    if (self.urlSessionTask && self.urlSessionTask.state == NSURLSessionTaskStateRunning) {
        return;
    }
    self.completionHandler = finished;
    id<XNRequestProtocol> derivative = self.derivative;
    NSDictionary *params = [derivative assembleParams];
    id<XNServerProtocol> server = [self getTheServer];
    params = [server appendSignature:params];
    NSString *url = [[self urlPrefix] stringByAppendingFormat:@"%@", [derivative apiPath]];
    XNRequestMethod method = [derivative respondsToSelector:@selector(method)] ? [derivative method] : XNRequestMethodGet;
    if (method == XNRequestMethodGet) {
        self.urlSessionTask = [self get:url parameters:params];
    }else if(method == XNRequestMethodPost) {
        self.urlSessionTask = [self post:url parameters:params];
    }else {
        XLog(@"不支持的请求方法！");
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: @"不支持的请求方法！"};
        [self processResponse:[XNResponse responseWithError:[[NSError alloc] initWithDomain:@"cn.xyz.app" code:-1 userInfo:userInfo]]];
    }
}

- (void)uploadFileRequest:(XNCallback)finished {
    if (self.urlSessionTask && self.urlSessionTask.state == NSURLSessionTaskStateRunning) {
        return;
    }
    self.completionHandler = finished;
    id<XNRequestProtocol> derivative = self.derivative;
    NSDictionary *params = [derivative assembleParams];
    id<XNServerProtocol> server = [self getTheServer];
    params = [server appendSignature:params];
    NSString *url = [[self urlPrefix] stringByAppendingFormat:@"%@",[derivative apiPath]];
    NSData *data = [derivative uploadFile];
    NSString *fileName = [derivative uploadFileName];
    NSString *mimeType = [derivative uploadMimeType];
    id<XNHTTPExecutorProtocol> httpExecutor = [self currentHttpExecutor];
    __block XNRequest *strongSelf = self;
    [httpExecutor FORM:data url:url parameters:params mimeType:mimeType fileName:fileName finished:^(NSURLSessionDataTask *task, XNResponse *responseObject) {
        responseObject.request = strongSelf.derivative;
        [strongSelf processResponse:responseObject];
        strongSelf = nil;
    }];
}


- (NSURLSessionTask*)get:(NSString *)url parameters:(NSDictionary*)params {
    id<XNHTTPExecutorProtocol> httpExecutor = [self currentHttpExecutor];
    id<XNServerProtocol> server = [self getTheServer];
    NSString *paramsString = [server buildQueryString:params];
    url = [url stringByAppendingFormat:@"%@%@", paramsString.length == 0 ? @"" : @"?", paramsString];
    XLog(@"url:%@",url);
    __block XNRequest *strongSelf = self;
    return [httpExecutor GET:url parameters:nil finished:^(NSURLSessionDataTask *task, XNResponse *responseObject) {
        responseObject.request = strongSelf.derivative;
        [strongSelf processResponse:responseObject];
        strongSelf = nil;
    }];
}

- (NSURLSessionTask*)post:(NSString *)url parameters:(NSDictionary*)params{
    XLog(@"url:%@ params:%@",url, params);
    id<XNHTTPExecutorProtocol> httpExecutor = [self currentHttpExecutor];    
    __block XNRequest *strongSelf = self;
    return [httpExecutor POST:url parameters:params finished:^(NSURLSessionDataTask *task, XNResponse *responseObject) {
        responseObject.request = strongSelf.derivative;
        [strongSelf processResponse:responseObject];
        strongSelf = nil;
    }];
}

- (void)processResponse:(XNResponse *)responseObject{
    if (responseObject.error.code == NSURLErrorCancelled) {
        return;
    }
    if (responseObject.error) {
        [self callCompletionHandlerWithReponse:responseObject];
        return;
    }
    if (![self isTimeOffsetWithReponse:responseObject]) {
        [self callCompletionHandlerWithReponse:responseObject];
        return;
    }
    id<XNServerProtocol> server = [self getTheServer];
    if (![server needResendRequest]) {
        [self callCompletionHandlerWithReponse:responseObject];
        return;
    }
    XLog(@"time error:%@,will refresh time offset",responseObject.content);
    __weak __typeof(self)weakSelf = self;
    [server refreshTimeOffsetWithComplete:^(BOOL success) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.cancelled) {
            return ;
        }
        if (success) {
            [strongSelf request:strongSelf.completionHandler];
        }else {
            [strongSelf callCompletionHandlerWithReponse:responseObject];
        }
    }];
}

- (void)callCompletionHandlerWithReponse:(XNResponse*)response {
    if (self.completionHandler) {
        self.completionHandler(self, response);
    }
}

- (BOOL)isTimeOffsetWithReponse:(XNResponse *)response {
    if (response.error) {
        return NO;
    }
    id<XNServerProtocol> server = [self getTheServer];
    if (![server respondsToSelector:@selector(needSyncTime)] || ![server needSyncTime]) {
        return NO;
    }
    if (![server respondsToSelector:@selector(isTimeOffsetErrorWithResponse:)] || ![server isTimeOffsetErrorWithResponse:response.content]) {
        return NO;
    }
    if (![server respondsToSelector:@selector(refreshTimeOffsetWithComplete:)]) {
        return NO;
    }
    return YES;
}


- (void)cancel {
    self.cancelled = YES;
    [self.urlSessionTask cancel];
}

@end
