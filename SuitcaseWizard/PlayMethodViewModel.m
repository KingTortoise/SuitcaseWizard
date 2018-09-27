//
//  PlayMethodViewModel.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/21.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "PlayMethodViewModel.h"

@interface PlayMethodViewModel ()
@property (nonatomic, strong, readwrite)RACCommand *savePlayMethodRACCommand;
@end

@implementation PlayMethodViewModel
#pragma mark – Init methods
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
        [self bindData];
    }
    return self;
}

- (void)initView{
    @weakify(self);
    //保存玩法名称、亮点、介绍
    self.savePlayMethodRACCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        @strongify(self);
        NSString *text = tuple[0];
        NSNumber *type = tuple[1];
        return [self savePlayMethodAction:text type:type];
    }];
}

- (void)bindData{
    //保存玩法名称、亮点、介绍事件
    [self.savePlayMethodRACCommand.executionSignals.switchToLatest subscribeNext:^(RACTuple *tuple) {
        NSNumber *type = tuple[1];
        NSString *text = tuple[0];
        if ([type integerValue] == 1) {
            self.title = text;
        }else if ([type integerValue] == 2){
            self.strength = text;
        }else{
            self.introduction = text;
        }
    }];
}

#pragma mark - Action
//保存玩法名称、亮点、介绍
- (RACSignal *)savePlayMethodAction:(NSString *)name type:(NSNumber *)type{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACTuple *tuple = RACTuplePack(name,type);
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        return nil;
    }];
}
@end
