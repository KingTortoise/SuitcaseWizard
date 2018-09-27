//
//  XNServerConfiguraion.m
//  XNetworking
//
//  Created by 张文心 on 2017/1/23.
//  Copyright © 2017年 金建新. All rights reserved.
//

#import "XNServerConfiguraion.h"

@implementation XNServerConfiguraion

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken;
    static XNServerConfiguraion *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XNServerConfiguraion alloc] init];
    });
    return sharedInstance;
}

@end
