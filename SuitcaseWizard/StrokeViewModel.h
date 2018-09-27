//
//  StrokeViewModel.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/21.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StrokeArrangement.h"
@interface StrokeViewModel : NSObject
/* 自动增加 添加景点cell */
@property (nonatomic, strong, readonly)RACCommand *addAttractionsCellRACCommand;
/* 点击添加路线安排Section 请求 */
@property (nonatomic, strong, readonly)RACCommand *addStrokeSectionRACCommand;
/* 保存或者删除用户填入的景点名称 */
@property (nonatomic, strong, readonly)RACCommand *saveOrDeleteAttractionsRACCommand;
/* 删除路线安排section */
@property (nonatomic, strong, readonly)RACCommand *deleteStrokeSectionRACCommand;
/* 将选择的城市列表存入model */
@property (nonatomic, strong, readonly)RACCommand *saveSelectedCityRACCommand;
/* 路线安排数据源 */
@property (nonatomic, strong)NSDictionary<NSString,StrokeArrangement> *travelRoute;
@end
