//
//  AddAttractionsTableViewCell.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "AddAttractionsTableViewCell.h"

@implementation AddAttractionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initData:(NSString *)text num:(NSInteger)num{
    self.numOfView.layer.cornerRadius = self.numOfView.frame.size.width / 2;
    self.numOfView.clipsToBounds = YES;
    self.addAttractionsTextField.text = text;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",num];
}

@end
