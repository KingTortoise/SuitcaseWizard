//
//  StrokeArrangement.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/8.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CityListModel.h"

@protocol StrokeArrangement <NSObject> @end
@protocol NSString <NSObject> @end

//路径安排Model
@interface StrokeArrangement : JSONModel
@property (nonatomic, strong)NSArray<NSString> *viewspots;
@property (nonatomic, strong)NSArray<CityListNameModel> *route;
@end

@interface StrokeArrangementDic : JSONModel
@property (nonatomic, strong) NSDictionary<NSString,StrokeArrangement> *travelRoute;
@end
