//
//  PackageViewModel.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/21.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "PackageViewModel.h"
#import "CreateNewStrokeAPI.h"

@interface PackageViewModel ()
@property (nonatomic, strong, readwrite)RACCommand *requestPlanListRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *requestCarListRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *choicePackageOrCarRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *addCustomPriceSectionRACCommand;
@end

@implementation PackageViewModel
#pragma mark – Init methods
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initProperty];
        [self initView];
        [self bindData];
    }
    return self;
}

- (void)initProperty{
    PackageChoiceModel *model = [[PackageChoiceModel alloc]init];
    NSMutableArray<PackageChoiceModel> *packArray = [[NSMutableArray<PackageChoiceModel> alloc]init];
    [packArray addObject:model];
    self.prices = packArray;
}

- (void)initView{
    @weakify(self);
    //请求出行计划列表网络请求
    self.requestPlanListRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self requestPlanList];
    }];
    //请求出行方案列表网络请求
    self.requestCarListRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self requestCarList];
    }];
    //选择出行计划和出行方法
    self.choicePackageOrCarRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        NSInteger item = [input[0] integerValue];
        NSInteger index = [input[1] integerValue];
        NSInteger row = [input[2] integerValue];
        return [self choicePackageAndCarAction:item atIndex:index row:row];
    }];
    //增加或者删除价格定义section
    self.addCustomPriceSectionRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        @strongify(self);
        NSInteger index;
        if (tuple.count == 2) {
            index = [tuple[1] integerValue];
        }else{
            index = 0;
        }
        BOOL addOrDelete = [tuple[0] boolValue];
        return [self addOrDeletePackageAction:addOrDelete Atindex:index];
    }];
}

- (void)bindData{
    @weakify(self);
    RAC(self,list) = [self.requestPlanListRACCommand.executionSignals.switchToLatest map:^id(NSDictionary *value) {
        PackagePlanList *planList = [[PackagePlanList alloc]initWithDictionary:value error:nil];
        return planList.response;
    }];
    RAC(self,carList) = [self.requestCarListRACCommand.executionSignals.switchToLatest map:^id(NSDictionary *value) {
        PackageCarList *cList = [[PackageCarList alloc]initWithDictionary:value error:nil];
        return cList.response;
    }];
    RACSignal *mergeSignal = [RACSignal merge:@[self.choicePackageOrCarRACCommand.executionSignals.switchToLatest,self.addCustomPriceSectionRACCommand.executionSignals.switchToLatest]];
    /* 选择套餐或者车辆返回的是NSDictionary    如果增加section返回的是一个PackageChoiceModel  如果是删除section 返回的是要删除的index(NSNumber)*/
    [mergeSignal subscribeNext:^(id x) {
        @strongify(self);
        if ([x isKindOfClass:[NSDictionary class]]) {
            PackageChoiceModel *model = x[@"model"];
            NSInteger index = [x[@"index"] integerValue];
            NSMutableArray<PackageChoiceModel> *array = [[NSMutableArray<PackageChoiceModel> alloc]initWithArray:self.prices];
            [array replaceObjectAtIndex:index withObject:model];
            self.prices = array;
        }else if([x isKindOfClass:[PackageChoiceModel class]]){
            NSMutableArray<PackageChoiceModel> *array = [[NSMutableArray<PackageChoiceModel> alloc]initWithArray:self.prices];
            [array addObject:x];
            self.prices = array;
        }else{
            NSMutableArray<PackageChoiceModel> *array = [[NSMutableArray<PackageChoiceModel> alloc]initWithArray:self.prices];
            [array removeObjectAtIndex:[x integerValue]];
            self.prices = array;
        }
    }];
}

#pragma mark - NetWorking
//出行计划网络请求
- (RACSignal *)requestPlanList{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CreateNewStrokePlanListAPI *planList = [[CreateNewStrokePlanListAPI alloc]init];
        [planList request:^(XNRequest *request, XNResponse *response) {
            if (!response.error) {
                NSDictionary *dic = response.content;
                [subscriber sendNext:dic];
                [subscriber sendCompleted];
            }else{
                [subscriber sendNext:nil];
            }
        }];
        return nil;
    }];
}

//出行车辆网络请求
- (RACSignal *)requestCarList{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CreateNewStrokeCarListAPI *carList = [[CreateNewStrokeCarListAPI alloc] init];
        [carList request:^(XNRequest *request, XNResponse *response) {
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

#pragma mark - Action
//选择出行方式(套餐)和出行车辆
- (RACSignal *)choicePackageAndCarAction:(NSInteger)item atIndex:(NSInteger)index row:(NSInteger)row{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        PackageChoiceModel *model = self.prices[index];
        PackageChoiceModel *choiceModel = [[PackageChoiceModel alloc]init];
        if (item == 0) {
            choiceModel.plan = self.list[row];
            choiceModel.car = model.car;
        }else{
            choiceModel.car = self.carList[row];
            choiceModel.plan = model.plan;
        }
        NSDictionary *dic = @{@"model":choiceModel,@"index":@(index)};
        [subscriber sendNext:dic];
        [subscriber sendCompleted];
        return  nil;
    }];
}

//增加或者删除价格定义section
- (RACSignal *)addOrDeletePackageAction:(BOOL)judge Atindex:(NSInteger)index{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (judge) {
            PackageChoiceModel *model = [[PackageChoiceModel alloc]init];
            [subscriber sendNext:model];
        }else{
            [subscriber sendNext:@(index)];
        }
        [subscriber sendCompleted];
        return nil;
    }];
}
@end
