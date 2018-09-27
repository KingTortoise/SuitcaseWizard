//
//  XNHTTPExecutorAF.h
//  XNetworking
//
//  Created by 金建新 on 16/8/12.
//  Copyright © 2016年 金建新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNetworkingProtocol.h"

@interface XNHTTPExecutorAF : NSObject<XNHTTPExecutorProtocol>

@property (nonatomic, readwrite) NSInteger timeout;
@property (nonatomic, strong, readwrite) NSArray *responseAcceptContentTypes;

@end
