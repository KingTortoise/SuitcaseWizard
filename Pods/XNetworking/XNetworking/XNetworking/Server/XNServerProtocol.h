//
//  XNServerProtocol.h
//  XNetworking
//
//  Created by 金建新 on 16/8/8.
//  Copyright © 2016年 金建新. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol XNServerProtocol <NSObject>

@optional
- (BOOL)needSyncTime;
- (BOOL)isTimeOffsetErrorWithResponse:(NSDictionary*)response;
- (BOOL)needResendRequest;
- (void)refreshTimeOffsetWithComplete:(void(^)(BOOL success))complete;

@required
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *imageHost;

+ (instancetype)sharedInstance;
- (NSDictionary*)appendSignature:(NSDictionary *)params;
- (NSString *)buildQueryString:(NSDictionary*)params;

+ (NSArray *)serverList;

@end
