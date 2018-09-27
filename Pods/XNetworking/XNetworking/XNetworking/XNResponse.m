//
//  XNResponse.m
//  XNetworking
//
//  Created by 金建新 on 16/8/8.
//  Copyright © 2016年 金建新. All rights reserved.
//

#import "XNResponse.h"
#import "XNRequest.h"

@implementation XNResponse

- (instancetype)initWithContent:(id)content requestTask:(NSURLSessionDataTask*)requestTask error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.content = content;
        self.error = error;
        if (requestTask && [requestTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)requestTask.response;
            self.contentType = [httpResp.allHeaderFields objectForKey:@"Content-Type"];
            self.httpStatusCode = httpResp.statusCode;
        }
        
    }
    return self;
}


+ (instancetype)responseWithError:(NSError*)error {
    XNResponse *response = [[XNResponse alloc] init];
    response.error = error;
    return response;
}

- (void)dealloc
{
    NSLog(@"XNResponse dealloc");
}


@end
