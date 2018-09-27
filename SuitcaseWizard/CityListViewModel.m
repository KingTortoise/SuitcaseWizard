//
//  CityListViewModel.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/9.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "CityListViewModel.h"
#import "CityListAPI.h"

@interface CityListViewModel ()
@property (nonatomic, strong, readwrite)RACCommand *requestCityListRACCommand;
@property (nonatomic, strong, readwrite)NSMutableArray<CityListNameModel*> *cityList;
@property (nonatomic, strong, readwrite)NSMutableArray<CityListNameModel*> *cityListCopy; //用于模糊查询保存原始的数据
@property (nonatomic, strong, readwrite)RACCommand *searchRequestRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *cellIsSelectedRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *getStringArrayRACCommand;
@property (nonatomic, strong, readwrite)NSArray<CityListNameModel*> *cityNameArray;
@end

#pragma mark – Init methods
@implementation CityListViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
        [self bindData];
    }
    return self;
}

#pragma mark - initView
- (void)initView{
    @weakify(self);
    //获取城市列表网络请求
    self.requestCityListRACCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return  [self requestCityList];
    }];
    //模糊搜索事件
    self.searchRequestRACCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
        @strongify(self);
        return [self searchRequestAction:input];
    }];
    //cell选择事件
    self.cellIsSelectedRACCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        return [self cellIsSelectedAction:[input integerValue]];
    }];
    //保存返回上一界面的时候获取被选择的cell数组
    self.getStringArrayRACCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self getStringArrayAction];
    }];
}

- (void)bindData{
    @weakify(self);
    RAC(self,list) = [RACObserve(self, cityList) distinctUntilChanged];
    RACSignal *mergeStroke = [RACSignal merge:@[self.requestCityListRACCommand.executionSignals.switchToLatest,self.searchRequestRACCommand.executionSignals.switchToLatest,self.cellIsSelectedRACCommand.executionSignals.switchToLatest]];
    /* 1:获取城市列表   2:选择cell事件  3:模糊搜索事件 */
    [mergeStroke subscribeNext:^(id x) {
        @strongify(self);
        NSInteger num = [x[0] integerValue];
        if (num == 1) {
            NSDictionary *dic = x[1];
            CityListModel *model = [[CityListModel alloc]initWithDictionary:dic error:nil];
            self.cityNameArray = model.response;
            NSMutableArray *itemArray = [[NSMutableArray alloc]init];
            for (CityListNameModel *nameModel in self.cityNameArray) {
                if (self.choiceArray.count != 0) {
                    for (CityListNameModel *choiceModel in self.choiceArray) {
                        if ([nameModel.cityName isEqualToString:choiceModel.cityName]) {
                            nameModel.isSelected = @(1);
                        }
                    }
                }
                [itemArray addObject:nameModel];
            }
            self.cityList = itemArray;
            self.cityListCopy = itemArray;
        }else if(num == 2){
            CityListNameModel *model = x[1];
            NSInteger index = [x[2] integerValue];
            NSMutableArray *array = self.cityList.mutableCopy;
            [array replaceObjectAtIndex:index withObject:model];
            [self changeCopyList:model];
            self.cityList = array;
        }else if(num == 3){
            NSArray *array = x[1];
            self.cityList = array.mutableCopy;
        }
    }];
    RAC(self,backList) = [self.getStringArrayRACCommand.executionSignals.switchToLatest map:^id(NSArray *value) {
        return value;
    }];
    
}

#pragma mark - NetWorking
- (RACSignal *)requestCityList{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CityListAPI *cityList = [[CityListAPI alloc]init];
        [cityList request:^(XNRequest *request, XNResponse *response) {
            if (!response.error) {
                NSDictionary *dic = response.content;
                RACTuple *tuple = RACTuplePack(@(1),dic);
                [subscriber sendNext:tuple];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:nil];
            }
        }];
        return nil;
    }];
}

#pragma mark - Action
- (RACSignal *)cellIsSelectedAction:(NSInteger)index{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CityListNameModel *item = self.cityList[index].copy;
        if ([item.isSelected integerValue] == 1) {
            item.isSelected = @(0);
        }else{
            item.isSelected = @(1);
        }
        RACTuple *tuple = RACTuplePack(@(2),item,@(index));
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)searchRequestAction:(NSString *)text{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSArray *array = [[NSArray alloc]init];
        if ([text isEqualToString:@""]) {
            array = self.cityListCopy;
        }else{
           array = [self searchByChineseOrEnglish:text];
        }
        RACTuple *tuple = RACTuplePack(@(3),array);
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)getStringArrayAction{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i =0; i<self.cityListCopy.count; i++) {
            CityListNameModel *item = self.cityListCopy[i];
            if ([item.isSelected integerValue] == 1) {
                [array addObject:self.cityNameArray[i]];
            }
        }
        [subscriber sendNext:array];
        [subscriber sendCompleted];
        return nil;
    }];
}

#pragma mark - privateMethod

/**
 用于模糊搜索，找出包含搜索框中text的城市

 @param text 搜索Text
 @return 包含搜索Text的城市数组
 */
- (NSArray *)searchByChineseOrEnglish:(NSString *)text{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (CityListNameModel *item in self.cityListCopy) {
        if(([item.cityName rangeOfString:text].location !=NSNotFound)||([item.engName rangeOfString:text].location !=NSNotFound)){
            [array addObject:item];
        }
    }
    return array;
}

/**
 更新一下copy的城市列表
 主要是考虑到模糊搜索后点击一个cell，在退出搜索后，能够显示刚刚选择的cell

 @param item 城市Model
 */
- (void)changeCopyList:(CityListNameModel *)item{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *cityName = item.cityName;
    for (CityListNameModel *model in self.cityListCopy) {
        if ([model.cityName rangeOfString:cityName].location != NSNotFound) {
            [array addObject:item];
        }else{
            [array addObject:model];
        }
    }
    self.cityListCopy = array;
}
@end
