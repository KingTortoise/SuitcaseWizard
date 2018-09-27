//
//  WizardModel.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol WizardModel <NSObject> @end

@interface WizardModel : JSONModel
//行程名
@property (nonatomic, strong)NSString *title;
//行程ID
@property (nonatomic, strong)NSNumber *guideId;
//用户ID
@property (nonatomic, strong)NSNumber *userId;
//行程状态（2、已审核，3、审核不通过）
@property (nonatomic, strong)NSNumber *guideStatus;
//是否是草稿（0不是、1是）
@property (nonatomic, strong)NSNumber *isDraft;
//封面URL
@property (nonatomic, strong)NSURL *picUrl;
//价格
@property (nonatomic, assign)float price;
//查看次数
@property (nonatomic, strong)NSNumber *viewCount;
@end


@interface WizardResultModel : JSONModel
/* 请求返回result */
@property (nonatomic, strong)NSNumber *result;
/* 请求返回数据response */
@property (nonatomic, strong)NSArray<WizardModel> *response;
@end
