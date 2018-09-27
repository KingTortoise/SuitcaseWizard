//
//  StrokeViewModel.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/21.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "StrokeViewModel.h"

@interface StrokeViewModel ()
@property (nonatomic, strong, readwrite)RACCommand *addAttractionsCellRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *addStrokeSectionRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *saveOrDeleteAttractionsRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *deleteStrokeSectionRACCommand;
@property (nonatomic, strong, readwrite)RACCommand *saveSelectedCityRACCommand;
@end

@implementation StrokeViewModel
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
    StrokeArrangement *arrangement = [[StrokeArrangement alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *str = [[NSString alloc]init];
    [array addObject:str];
    arrangement.viewspots = array.copy;
    NSMutableDictionary<NSString,StrokeArrangement> *dic = [[NSMutableDictionary<NSString,StrokeArrangement> alloc] init];
    [dic setObject:arrangement forKey:[NSString stringWithFormat:@"%d",0]];
    self.travelRoute = dic;
}

- (void)initView{
    @weakify(self);
    //增加 添加景点cell
    self.addAttractionsCellRACCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        return [self addAttractionsAction:input];
    }];
    //增加路线安排section
    self.addStrokeSectionRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self addStrokeSectionAction];
    }];
    //删除路线安排section
    self.deleteStrokeSectionRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        return [self deleteStrokeAction:[input integerValue]];
    }];
    //保存选择的城市
    self.saveSelectedCityRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        NSArray<CityListNameModel> *array = input[1];
        NSInteger index = [input[0] integerValue];
        return [self saveSelectedCityAction:array AtIndex:index];
    }];
    //保存景点名称
    self.saveOrDeleteAttractionsRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *input) {
        @strongify(self);
        NSString *content = input[0];
        NSInteger index = [input[1] integerValue];
        NSInteger itemIndex = [input[2] integerValue];
        return [self saveAttractionNameAction:content Atindex:index itemIndex:itemIndex];
    }];
}

- (void)bindData{
    @weakify(self);
    RACSignal *mergeStroke = [RACSignal merge:@[self.addStrokeSectionRACCommand.executionSignals.switchToLatest,self.addAttractionsCellRACCommand.executionSignals.switchToLatest,self.saveOrDeleteAttractionsRACCommand.executionSignals.switchToLatest,self.deleteStrokeSectionRACCommand.executionSignals.switchToLatest,self.saveSelectedCityRACCommand.executionSignals.switchToLatest]];
    /* 1:增加景点cell   2:增加路线安排section  3:保存景点名称  4:删除路线安排section 5:保存选择的城市数组 */
    [mergeStroke subscribeNext:^(RACTuple *x) {
        @strongify(self);
        NSInteger i = [x[0] integerValue];
        if (i == 1) {
            StrokeArrangement *item = x[1];
            NSInteger index = [x[2] integerValue];
            NSMutableDictionary<NSString,StrokeArrangement> *muDic = [[NSMutableDictionary<NSString,StrokeArrangement> alloc]initWithDictionary:self.travelRoute];
            [muDic setObject:item forKey:[NSString stringWithFormat:@"%ld",(long)index]];
            self.travelRoute = muDic;
        }else if(i == 2){
            StrokeArrangement *model = x[1];
            NSMutableDictionary<NSString,StrokeArrangement> *dic = [[NSMutableDictionary<NSString,StrokeArrangement> alloc]initWithDictionary:self.travelRoute];
            [dic setObject:model forKey:[NSString stringWithFormat:@"%ld",(long)dic.allKeys.count]];
            self.travelRoute = dic;
        }else if(i == 3){
            StrokeArrangement *item = x[1];
            NSInteger index = [x[2] integerValue];
            NSMutableDictionary<NSString,StrokeArrangement> *dic = [[NSMutableDictionary<NSString,StrokeArrangement> alloc]initWithDictionary:self.travelRoute];
            [dic setObject:item forKey:[NSString stringWithFormat:@"%ld",(long)index]];
            if (item.viewspots.lastObject != nil && ![item.viewspots.lastObject  isEqualToString: @""]) {
                [self.addAttractionsCellRACCommand execute:@(index)];
            }
            self.travelRoute = dic;
        }else if (i == 4){
            NSDictionary<NSString,StrokeArrangement> *dic = x[1];
            self.travelRoute = dic;
        }else if (i == 5){
            StrokeArrangement *model = x[1];
            NSInteger index = [x[2] integerValue];
            NSMutableDictionary<NSString,StrokeArrangement> *dic = [[NSMutableDictionary<NSString,StrokeArrangement> alloc]initWithDictionary:self.travelRoute];
            [dic setObject:model forKey:[NSString stringWithFormat:@"%ld",(long)index]];
            self.travelRoute = dic;
        }
    }];
}

#pragma mark - Action
//增加景点cell
- (RACSignal *)addAttractionsAction:(NSNumber *)index{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        StrokeArrangement *arrangement = self.travelRoute[[NSString stringWithFormat:@"%ld",(long)[index integerValue]]];
        StrokeArrangement *item = [[StrokeArrangement alloc]init];
        NSMutableArray<NSString> *itemArray = [[NSMutableArray<NSString> alloc]initWithArray:arrangement.viewspots];
        NSString *str = [[NSString alloc]init];
        [itemArray addObject:str];
        item.viewspots = itemArray;
        item.route = arrangement.route;
        RACTuple *tuple = RACTuplePack(@(1),item,index);
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        return nil;
    }];
}

//增加路线安排section
- (RACSignal *)addStrokeSectionAction{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        StrokeArrangement *arrangement = [[StrokeArrangement alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSString *str = [[NSString alloc]init];
        [array addObject:str];
        arrangement.viewspots = array.copy;
        RACTuple *tuple = RACTuplePack(@(2),arrangement);
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        return nil;
    }];
}

//删除路线安排section
- (RACSignal *)deleteStrokeAction:(NSInteger)index{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:self.travelRoute];
        [dic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < dic.allKeys.count; i++) {
            StrokeArrangement *item = [[StrokeArrangement alloc]init];
            if (i < index) {
                item = dic[[NSString stringWithFormat:@"%d",i]];
            }else{
                item = dic[[NSString stringWithFormat:@"%d",i+1]];
            }
            [muDic setObject:item forKey:[NSString stringWithFormat:@"%d",i]];
        }
        RACTuple *tuple = RACTuplePack(@(4),muDic);
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        return nil;
    }];
}

//保存景点名称
- (RACSignal *)saveAttractionNameAction:(NSString *)content Atindex:(NSInteger)index itemIndex:(NSInteger)itemIndex{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *dic = self.travelRoute.copy;
        StrokeArrangement *arrangement = dic[[NSString stringWithFormat:@"%ld",(long)index]];
        NSMutableArray *array = arrangement.viewspots.mutableCopy;
        if ([content isEqualToString:@""] && (itemIndex != array.count - 1)) {
            StrokeArrangement *model = [[StrokeArrangement alloc]init];
            [array removeObjectAtIndex:itemIndex];
            model.viewspots = array.copy;
            model.route = arrangement.route;
            RACTuple *tuple = RACTuplePack(@(3),model,@(index),@(itemIndex));
            [subscriber sendNext:tuple];
        }else{
            array[itemIndex] = content;
            arrangement.viewspots = array.copy;
            RACTuple *tuple = RACTuplePack(@(3),arrangement,@(index),@(itemIndex));
            [subscriber sendNext:tuple];
        }
        [subscriber sendCompleted];
        return nil;
    }];
}
//保存选择的城市数据
- (RACSignal *)saveSelectedCityAction:(NSArray<CityListNameModel> *)cityArray AtIndex:(NSInteger)index{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *dic = self.travelRoute.copy;
        StrokeArrangement *model = dic[[NSString stringWithFormat:@"%ld",(long)index]];
        StrokeArrangement *item = [[StrokeArrangement alloc]init];
        item.viewspots = model.viewspots;
        item.route = cityArray;
        RACTuple *tuple = RACTuplePack(@(5),item,@(index));
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        return nil;
    }];
}

@end
