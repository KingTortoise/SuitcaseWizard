//
//  CityListModel.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/9.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CityListNameModel <NSObject> @end

@interface CityListModel : JSONModel
@property (nonatomic, strong)NSNumber *result;
@property (nonatomic, strong)NSArray<CityListNameModel> *response;
@end

@interface CityListNameModel : JSONModel
@property (nonatomic, strong)NSString *cityName;
@property (nonatomic, strong)NSString *engName;
@property (nonatomic, strong)NSNumber<Optional> *isSelected;
@end
