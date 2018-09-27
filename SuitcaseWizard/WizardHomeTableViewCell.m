//
//  WizardHomeTableViewCell.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "WizardHomeTableViewCell.h"

@implementation WizardHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    RAC(self,title.text) = RACObserve(self, model.title);
    RAC(self,price.text) = [RACObserve(self, model.price) map:^id(id value) {
        return [NSString stringWithFormat:@"%0.2fCNA/天",[value floatValue]];
    }];
    RAC(self,states.text) = [RACObserve(self, model.guideStatus) map:^id(NSNumber *value) {
        if(value == nil){
            return @"草稿";
        }else if ([value integerValue] == 2){
            return @"审核通过";
        }else if([value integerValue] == 3){
            return @"审核不通过";
        }else{
            return @"审核通过";
        }
    }];
    RAC(self,viewCount.text) = [RACObserve(self, model.viewCount) map:^id(id value) {
        return [NSString stringWithFormat:@"%ld",(long)[value integerValue]];
    }];
    [RACObserve(self, model.picUrl) subscribeNext:^(NSURL *x) {
        [self.topicImage sd_setImageWithURL:x];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
