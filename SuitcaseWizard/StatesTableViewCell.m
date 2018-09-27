//
//  StatesTableViewCell.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "StatesTableViewCell.h"

@implementation StatesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initData:(NSNumber *)guideStatus  isDraft:(NSNumber *)isDraft{
    if (guideStatus != nil) {
        if ([guideStatus integerValue] == 2) {
            self.statesLabel.text = @"审核已经通过";
        }else{
            self.statesLabel.text = @"审核不通过";
        }
    }else if ([isDraft integerValue] == 1) {
        self.statesLabel.text = @"当前处于草稿状态";
    }else{
        self.statesLabel.text = @"请编辑";
    }
}
@end
