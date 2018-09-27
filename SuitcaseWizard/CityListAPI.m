//
//  CityListAPI.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/9.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "CityListAPI.h"

@implementation CityListAPI
- (NSString *)apiPath
{
    return @"/guide/cities";
}

- (NSDictionary *)assembleParams
{
    return [ObjectToDic generateHTTPParams:self];
}

- (XNRequestMethod)method
{
    return XNRequestMethodGet;
}

- (BOOL)shouldHttps
{
    return NO;
}
@end
