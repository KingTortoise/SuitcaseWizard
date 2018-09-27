//
//  WizardHomeAPI.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "WizardHomeAPI.h"

@implementation WizardHomeAPI
- (NSString *)apiPath
{
    return @"/guide/list";
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
