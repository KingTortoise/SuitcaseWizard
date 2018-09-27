//
//  PackageTableViewCell.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "PackageTableViewCell.h"

@implementation PackageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)initData:(PackagePlanListItem *)model num:(NSInteger)num{
    self.packageName.text = [NSString stringWithFormat:@"%@%@",@"套餐",@(num)];
    NSString *str = [model.price stringByAppendingFormat:@"   %@",model.time];
    self.packageContent.text = str;
}
@end
