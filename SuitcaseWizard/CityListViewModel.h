//
//  CityListViewModel.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/9.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityListModel.h"
#import "StrokeArrangement.h"
@interface CityListViewModel : NSObject
/* 获取城市列表网络请求 */
@property (nonatomic, strong, readonly)RACCommand *requestCityListRACCommand;
/* 城市列表数据源 */
@property (nonatomic, strong, readonly)NSArray<CityListNameModel*> *list;
/* 模糊搜索 */
@property (nonatomic, strong, readonly)RACCommand *searchRequestRACCommand;
/* 设置cell被选中 */
@property (nonatomic, strong, readonly)RACCommand *cellIsSelectedRACCommand;
/* 用于返回上一界面的数据源 */
@property (nonatomic, strong, readonly)NSArray<CityListNameModel> *backList;
/* 返回上一界面事 数据源转化 */
@property (nonatomic, strong, readonly)RACCommand *getStringArrayRACCommand;
/* 已经选择的城市列表 */
@property (nonatomic, strong)NSArray<CityListNameModel> *choiceArray;
@end
