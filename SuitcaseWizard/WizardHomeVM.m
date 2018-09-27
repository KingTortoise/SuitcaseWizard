//
//  WizardHomeVM.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "WizardHomeVM.h"
#import "WizardHomeAPI.h"

@interface WizardHomeVM ()
@property (nonatomic, strong, readwrite)RACCommand *requestDataRACCommand;
@end

@implementation WizardHomeVM
#pragma mark – Init methods
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
        [self bindData];
    }
    return  self;
}

#pragma mark - initView
- (void)initView{
    @weakify(self);
    self.requestDataRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *userId) {
        @strongify(self);
        return [self requestData:userId];
    }];
}

- (void)bindData{
    RAC(self,response) = [self.requestDataRACCommand.executionSignals.switchToLatest map:^id(NSDictionary *value) {
        WizardResultModel *resultModel = [[WizardResultModel alloc]initWithDictionary:value error:nil];
        return resultModel.response;
    }];
    RAC(self,showNoDataView) = [self.requestDataRACCommand.executionSignals.switchToLatest map:^id(NSDictionary *value) {
        WizardResultModel *resultModel = [[WizardResultModel alloc]initWithDictionary:value error:nil];
        return @(resultModel.response.count == 0);
    }];
}

#pragma mark - NetWorking
- (RACSignal *)requestData:(NSNumber *)userId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        WizardHomeAPI *wizardHome = [[WizardHomeAPI alloc]init];
        wizardHome.userId = userId;
        [wizardHome request:^(XNRequest *request, XNResponse *response) {
            if (!response.error) {
                NSDictionary *dic = response.content;
                [subscriber sendNext:dic];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:nil];
            }
        }];
        return nil;
    }];
}

@end
