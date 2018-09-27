//
//  CreateNewStrokeViewModel.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uploadStroke.h"
#import "PackageViewModel.h"
#import "StrokeViewModel.h"
#import "PlayMethodViewModel.h"

@interface CreateNewStrokeViewModel : NSObject
/* 存草稿 */
@property (nonatomic, strong, readonly)RACCommand *saveAsDraftOrPublishRACCommand;
/* 获取列表详情 */
@property (nonatomic, strong, readonly)RACCommand *requestStrokeDetailRACCommand;
/* 列表详情model */
@property (nonatomic, strong, readonly)StrokeDetailResponse *detailModel;
/* 增加查看数量 */
@property (nonatomic, strong, readonly)RACCommand *requestAddViewGuideRACCommand;
/* 判断用户是否更改信息 */
@property (nonatomic, assign)BOOL isChanged;
/* priceVM */
@property (nonatomic, strong)PackageViewModel *priceViewModel;
/* strokeVM */
@property (nonatomic, strong)StrokeViewModel *strokeViewModel;
/* playMethod */
@property (nonatomic, strong)PlayMethodViewModel *playMethodViewModel;
@end
