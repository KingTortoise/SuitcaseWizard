//
//  AddCarTableViewCell.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "AddCarTableViewCell.h"

@implementation AddCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    RAC(self,carNumber.text) = [RACObserve(self, carModel) map:^id(PackageCarListItem *item) {
        return [item.carName stringByAppendingFormat:@"   %@",item.carType];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
