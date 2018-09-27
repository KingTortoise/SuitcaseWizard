//
//  XNServerConfiguraion.h
//  XNetworking
//
//  Created by 张文心 on 2017/1/23.
//  Copyright © 2017年 金建新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNServerProtocol.h"

@interface XNServerConfiguraion : NSObject

@property (nonatomic, strong) id<XNServerProtocol> defaultServer;
+ (instancetype) shareInstance;

@end
