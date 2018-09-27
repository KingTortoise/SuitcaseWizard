//
//  PackageTableViewCell.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Package.h"

@interface PackageTableViewCell : UITableViewCell
/* 套餐编号 */
@property (weak, nonatomic) IBOutlet UILabel *packageName;
/* 套餐内容 */
@property (weak, nonatomic) IBOutlet UILabel *packageContent;

- (void)initData:(PackagePlanListItem *)model num:(NSInteger)num;
@end;
