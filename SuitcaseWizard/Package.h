//
//  Package.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol PackagePlanListItem <NSObject> @end
@protocol PackageCarListItem <NSObject> @end
@protocol PackageChoiceModel <NSObject> @end

//套餐计划model（用于网络请求）
@interface PackagePlanListItem : JSONModel
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *time;
@end

@interface PackagePlanList : JSONModel
@property (nonatomic, strong)NSArray<PackagePlanListItem> *response;
@property (nonatomic, strong)NSNumber *result;
@end

//车辆model（用于网络请求）
@interface PackageCarListItem : JSONModel
@property (nonatomic, strong)NSString *carName;
@property (nonatomic, strong)NSString *carType;
@end

@interface PackageCarList : JSONModel
@property (nonatomic, strong)NSArray<PackageCarListItem> *response;
@property (nonatomic, strong)NSNumber *result;
@end

//用户点击选择后的选择Model
@interface PackageChoiceModel : JSONModel
@property (nonatomic, strong)PackagePlanListItem *plan;
@property (nonatomic, strong)PackageCarListItem *car;
@end

@interface PackageModel : JSONModel
@property (nonatomic, strong)NSArray<PackageChoiceModel> *prices;
@end
