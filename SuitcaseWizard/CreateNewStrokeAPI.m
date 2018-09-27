//
//  CreateNewStrokeAPI.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "CreateNewStrokeAPI.h"

@implementation CreateNewStrokePlanListAPI
- (NSString *)apiPath
{
    return @"/guide/planlist";
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

@implementation CreateNewStrokeCarListAPI
- (NSString *)apiPath
{
    return @"/guide/carlist";
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

@implementation CreateNewStrokeRequestModel
@end

@implementation CreateNewStrokeSaveAsDraft
- (NSString *)apiPath
{
    return @"/guide/draft";
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

@implementation CreateNewStrokeGetDetailAPI
- (NSString *)apiPath
{
    return @"/guide/detail";
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

@implementation CreateNewStrokeViewGuideAPI
- (NSString *)apiPath
{
    return @"/guide/viewGuide";
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

@implementation CreateNewStrokePublishAPI
- (NSString *)apiPath
{
    return @"/guide/publish";
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
