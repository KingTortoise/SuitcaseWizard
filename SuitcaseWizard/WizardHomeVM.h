//
//  WizardHomeVM.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WizardModel.h"

@interface WizardHomeVM : NSObject
/* 网络请求 */
@property (nonatomic, strong, readonly)RACCommand *requestDataRACCommand;
/* model数据 */
@property (nonatomic, strong, readonly)NSArray<WizardModel *> *response;
/* 判断是否显示无数据 */
@property (nonatomic, strong) NSNumber *showNoDataView;
@end
