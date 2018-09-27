//
//  CreateNewStrokeAPI.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <XNetworking/XNetworking.h>
#import "Package.h"
#import "StrokeArrangement.h"

@interface CreateNewStrokePlanListAPI : XNRequest<XNRequestProtocol>

@end

@interface CreateNewStrokeCarListAPI  : XNRequest<XNRequestProtocol>

@end

@interface CreateNewStrokeRequestModel : NSObject
/* 行程名 */
@property (nonatomic, strong)NSString *title;
/* 行程ID */
@property (nonatomic, strong)NSNumber *guideId;
/* 用户ID */
@property (nonatomic, strong)NSNumber *userId;
/* 行程 */
@property (nonatomic, strong)NSString *travelRoute;
/* 费用方案 */
@property (nonatomic, strong)NSString *prices;
/* 玩法亮点 */
@property (nonatomic, strong)NSString *strength;
/* 玩法介绍 */
@property (nonatomic, strong)NSString *introduction;
@end

@interface CreateNewStrokeSaveAsDraft : XNRequest<XNRequestProtocol>
@property (nonatomic, strong)CreateNewStrokeRequestModel<ExpandProperty> *requestModel;
@end

@interface CreateNewStrokeGetDetailAPI : XNRequest<XNRequestProtocol>
/* guideId */
@property (nonatomic, strong)NSNumber *guideId;
@end

@interface CreateNewStrokeViewGuideAPI : XNRequest<XNRequestProtocol>
@property (nonatomic, strong)NSNumber *guideId;
@end

@interface CreateNewStrokePublishAPI : XNRequest<XNRequestProtocol>
@property (nonatomic, strong)CreateNewStrokeRequestModel<ExpandProperty> *requestModel;
@end
