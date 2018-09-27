//
//  AppDataManager.h
//  RACMVVM
//
//  Created by jinwenwu on 17/3/1.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDataManager : NSObject

/** 与服务器的时间偏移值 */
@property (nonatomic, assign) NSTimeInterval timeOffset;

+ (AppDataManager *)sharedInstance;
- (void)setTimeOffsetWithServerTime:(NSTimeInterval)serverTime;
@end
