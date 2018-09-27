//
//  CreateNewStrokeViewModel.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "CreateNewStrokeViewModel.h"
#import "CreateNewStrokeAPI.h"
#import "Utils.h"

@interface CreateNewStrokeViewModel ()
@property (nonatomic, strong, readwrite)RACCommand *saveAsDraftOrPublishRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *requestStrokeDetailRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *requestAddViewGuideRACCommand;
@property (nonatomic, strong, readwrite)StrokeDetailResponse *detailModelWrite;
@end

@implementation CreateNewStrokeViewModel
#pragma mark – Init methods
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
        [self bindData];
        [self initProperty];
    }
    return self;
}

#pragma mark - initView
- (void)initProperty{
    self.detailModelWrite = [[StrokeDetailResponse alloc]init];
    self.strokeViewModel = [[StrokeViewModel alloc]init];
    self.priceViewModel = [[PackageViewModel alloc]init];
    self.playMethodViewModel = [[PlayMethodViewModel alloc] init];
    self.isChanged = NO;
}

- (void)initView{
    @weakify(self);
    //获取列表详情
    self.requestStrokeDetailRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        @strongify(self);
        NSNumber *type = tuple[0];
        NSNumber *guidId = tuple[1];
        return [self requestStrokeDetail:guidId type:type];
    }];
    //增加查看次数
    self.requestAddViewGuideRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        return [self requestAddViewGuide:input];
    }];
    //存草稿或者上传
    self.saveAsDraftOrPublishRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *x) {
        @strongify(self);
        return [self requestSaveAsDraftOrPublish:x];
    }];
}

- (void)bindData{
    @weakify(self);
    //数据绑定
    RAC(self,detailModel) = [RACObserve(self, detailModelWrite)distinctUntilChanged];
    RAC(self,detailModelWrite.prices) = [[RACObserve(self, priceViewModel.prices)distinctUntilChanged] map:^id(id value) {
        self.isChanged = YES;
        return _priceViewModel.prices;
    }];
    RAC(self,detailModelWrite.travelRoute) = [[RACObserve(self, strokeViewModel.travelRoute)distinctUntilChanged] map:^id(id value) {
        self.isChanged = YES;
        return _strokeViewModel.travelRoute;
    }];
    RAC(self,detailModelWrite.title) = [[RACObserve(self, playMethodViewModel.title)distinctUntilChanged] map:^id(id value) {
        self.isChanged = YES;
        return _playMethodViewModel.title;
    }];
    RAC(self,detailModelWrite.strength) = [[RACObserve(self, playMethodViewModel.strength)distinctUntilChanged]map:^id(id value) {
        self.isChanged = YES;
        return _playMethodViewModel.strength;
    }];
    RAC(self,detailModelWrite.introduction) = [[RACObserve(self, playMethodViewModel.introduction)distinctUntilChanged]map:^id(id value) {
        self.isChanged = YES;
        return _playMethodViewModel.introduction;
    }];
    //获取数据网络请求
    [self.requestStrokeDetailRACCommand.executionSignals.switchToLatest subscribeNext:^(RACTuple *tuple) {
        NSNumber *type = tuple[0];
        NSDictionary *dic = tuple[1];
        StrokeDetail *model = [[StrokeDetail alloc]initWithDictionary:dic error:nil];
        StrokeDetailResponse *response = model.response;
        if ([type integerValue] == 2) {
            for (int i = 0; i < response.travelRoute.allKeys.count; i++) {
                StrokeArrangement *stroke = response.travelRoute[[NSString stringWithFormat:@"%@",@(i)]];
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:stroke.viewspots];
                NSString *str = [[NSString alloc]init];
                [array addObject:str];
                stroke.viewspots = array.copy;
            }
        }
        self.detailModelWrite = response;
        self.priceViewModel.prices = self.detailModelWrite.prices;
        self.strokeViewModel.travelRoute = self.detailModelWrite.travelRoute;
        self.playMethodViewModel.title = self.detailModelWrite.title;
        self.playMethodViewModel.strength = self.detailModelWrite.strength;
        self.playMethodViewModel.introduction = self.detailModelWrite.introduction;
        self.isChanged = NO;
    }];
    
    //存草稿和发布网络请求
    [self.saveAsDraftOrPublishRACCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *x) {
        @strongify(self);
        self.isChanged = NO;
        if ([x[@"response"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *response = x[@"response"];
            NSNumber *guideId = response[@"guideId"];
            self.detailModelWrite.guideId = guideId;
        }
    }];
    
}

#pragma mark - NetWorking
//存草稿或者发布网络请求
- (RACSignal *)requestSaveAsDraftOrPublish:(NSNumber *)type{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableDictionary<NSString, StrokeArrangement> *dic = [[NSMutableDictionary<NSString, StrokeArrangement> alloc]init];
        for (int i = 0; i < self.detailModel.travelRoute.allKeys.count; i++) {
            StrokeArrangement *item = self.detailModel.travelRoute[[NSString stringWithFormat:@"%d",i]];
            StrokeArrangement *model = [[StrokeArrangement alloc] init];
            model.viewspots = item.viewspots;
            model.route = item.route;
            NSMutableArray<NSString> *viewsArray = model.viewspots.mutableCopy;
            NSString *lastStr = viewsArray.lastObject;
            if (lastStr == nil || [lastStr isEqualToString:@""]) {
                [viewsArray removeLastObject];
            }
            model.viewspots = viewsArray;
            [dic setObject:model forKey:[NSString stringWithFormat:@"%d",i]];
        }
        StrokeArrangementDic *strokeDic = [[StrokeArrangementDic alloc] init];
        strokeDic.travelRoute = dic;
        PackageModel *packageModel = [[PackageModel alloc] init];
        packageModel.prices = self.detailModelWrite.prices;
        CreateNewStrokeRequestModel<ExpandProperty> *requestModel = [[CreateNewStrokeRequestModel<ExpandProperty> alloc]init];
        requestModel.title = self.detailModel.title;
        requestModel.userId = @(USERID);
        requestModel.travelRoute = [strokeDic toJSONString];
        requestModel.prices = [packageModel toJSONString];
        requestModel.strength = self.detailModel.strength;
        requestModel.introduction = self.detailModel.introduction;
        requestModel.guideId = self.detailModel.guideId;
        if ([type integerValue] == 1) {
            CreateNewStrokeSaveAsDraft *saveAsDraft = [[CreateNewStrokeSaveAsDraft alloc]init];
            saveAsDraft.requestModel = requestModel;
            [saveAsDraft request:^(XNRequest *request, XNResponse *response) {
                if (!response.error) {
                    NSDictionary *dic = response.content;
                    [subscriber sendNext:dic];
                    [subscriber sendCompleted];
                }else{
                    [subscriber sendError:nil];
                }
            }];
        }else{
            CreateNewStrokePublishAPI *publish = [[CreateNewStrokePublishAPI alloc] init];
            publish.requestModel = requestModel;
            [publish request:^(XNRequest *request, XNResponse *response) {
                if (!response.error) {
                    NSDictionary *dic = response.content;
                    [subscriber sendNext:dic];
                    [subscriber sendCompleted];
                }else{
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }];
}
//获取路线详情网络请求
- (RACSignal *)requestStrokeDetail:(NSNumber *)guideId type:(NSNumber *)type{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CreateNewStrokeGetDetailAPI *getDetail = [[CreateNewStrokeGetDetailAPI alloc] init];
        getDetail.guideId = guideId;
        [getDetail request:^(XNRequest *request, XNResponse *response) {
            if (!response.error) {
                NSDictionary *dic = response.content;
                RACTuple *tuple = RACTuplePack(type,dic);
                [subscriber sendNext:tuple];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:nil];
            }
        }];
        return nil;
    }];
}
//增加查看次数网络请求
- (RACSignal *)requestAddViewGuide:(NSNumber *)guideId{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CreateNewStrokeViewGuideAPI *viewGuide = [[CreateNewStrokeViewGuideAPI alloc] init];
        viewGuide.guideId = guideId;
        [viewGuide request:^(XNRequest *request, XNResponse *response) {
            if (!response.error) {
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:nil];
            }
        }];
        return nil;
    }];
}


@end
