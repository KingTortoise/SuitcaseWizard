//
//  AddAttractionsTableViewCell.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrokeArrangement.h"

@interface AddAttractionsTableViewCell : UITableViewCell
/* 数字的父视图  用于设置圆角 */
@property (weak, nonatomic) IBOutlet UIView *numOfView;
/* 对应的数字Label */
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
/* 添加景点TextField */
@property (weak, nonatomic) IBOutlet UITextField *addAttractionsTextField;

- (void)initData:(NSString *)text num:(NSInteger)num;
@end
