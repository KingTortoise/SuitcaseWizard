//
//  XNResponse.h
//  XNetworking
//
//  Created by 金建新 on 16/8/8.
//  Copyright © 2016年 金建新. All rights reserved./Users/jinjianxin/Documents/Work/Xcode/ios-modules/XNetworking/XNetworking
//

#import <Foundation/Foundation.h>
#import "XNetworkingProtocol.h"

@interface XNResponse : NSObject

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id content;
@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, weak) id<XNRequestProtocol> request;
@property (nonatomic, assign) NSString *contentType;
@property (nonatomic, assign) NSInteger httpStatusCode;

- (instancetype)initWithContent:(id)content requestTask:(NSURLSessionDataTask*)requestTask error:(NSError *)error;

+ (instancetype)responseWithError:(NSError*)error;

@end
