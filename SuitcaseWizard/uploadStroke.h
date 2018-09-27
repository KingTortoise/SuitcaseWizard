//
//  uploadStroke.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/13.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Package.h"
#import "StrokeArrangement.h"

@protocol StrokeDetailResponse <NSObject> @end

//路径详情Model
@interface StrokeDetailResponse : JSONModel
/* 行程名 */
@property (nonatomic, strong)NSString *title;
/* 行程ID */
@property (nonatomic, strong)NSNumber *guideId;
/* 用户ID */
@property (nonatomic, strong)NSNumber *userId;
/* 行程 */
@property (nonatomic, strong)NSDictionary<NSString,StrokeArrangement> *travelRoute;
/* 费用方案 */
@property (nonatomic, strong)NSArray<PackageChoiceModel> *prices;
/* 玩法亮点 */
@property (nonatomic, strong)NSString *strength;
/* 玩法介绍 */
@property (nonatomic, strong)NSString *introduction;
/* 行程状态 */
@property (nonatomic, strong)NSNumber *guideStatus;
/* 是否是草稿 */
@property (nonatomic, strong)NSNumber *isDraft;
@end

@interface StrokeDetail : JSONModel
@property (nonatomic, strong)StrokeDetailResponse *response;
@property (nonatomic, strong)NSNumber *result;
@end
