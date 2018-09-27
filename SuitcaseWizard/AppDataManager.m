//
//  AppDataManager.m
//  RACMVVM
//
//  Created by jinwenwu on 17/3/1.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "AppDataManager.h"

static AppDataManager *instance;

@implementation AppDataManager

+ (AppDataManager *)sharedInstance{
    @synchronized(self){
        if (!instance) {
            instance = [[AppDataManager alloc] init];
        }
        return  instance;
    }
}

- (void)setTimeOffsetWithServerTime:(NSTimeInterval)serverTime
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    _timeOffset = time - serverTime/1000;
    _timeOffset = (_timeOffset < 8*60*60 && _timeOffset > -8*60*60) ? _timeOffset : 0;
}


@end
