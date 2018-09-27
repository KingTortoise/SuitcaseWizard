//
//  PackageViewModel.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/21.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Package.h"

@interface PackageViewModel : NSObject
/* 出行方案（套餐）数组 */
@property (nonatomic, strong, readonly)NSArray<PackagePlanListItem *> *list;
/* 出行方案（套餐）网络请求 */
@property (nonatomic, strong, readonly)RACCommand *requestPlanListRACCommand;
/* 出行方式（车辆）数组 */
@property (nonatomic, strong, readonly)NSArray<PackageCarListItem *> *carList;
/* 出行方式（车辆）网络请求 */
@property (nonatomic, strong, readonly)RACCommand *requestCarListRACCommand;
/* 点击选择套餐和车辆 请求*/
@property (nonatomic, strong, readonly)RACCommand *choicePackageOrCarRACCommand;
/* 价格定义数据源 */
@property (nonatomic, strong)NSArray<PackageChoiceModel> *prices;
/* 点击添加价格定义Section 请求 */
@property (nonatomic, strong, readonly)RACCommand *addCustomPriceSectionRACCommand;
@end
