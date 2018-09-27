//
//  WizardModel.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "WizardModel.h"

@implementation WizardModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation WizardResultModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
