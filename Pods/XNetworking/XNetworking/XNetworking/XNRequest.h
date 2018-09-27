//
//  XNBaseRequest.h
//  XNetworking
//
//  Created by 金建新 on 16/8/8.
//  Copyright © 2016年 金建新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNetworkingProtocol.h"

@class XNResponse;
@class XNRequest;


@interface XNRequest : NSObject

@property (nonatomic, weak) id<XNRequestCallbackDelegate> delegate;
@property (nonatomic, strong) XNResponse *response;
@property (nonatomic, weak) NSURLSessionTask *urlSessionTask;

@property (nonatomic, assign) BOOL cached;

- (void)request:(XNCallback)finished;
- (void)uploadFileRequest:(XNCallback)finished;
- (void)cancel;
- (BOOL)isFinished;

@end


