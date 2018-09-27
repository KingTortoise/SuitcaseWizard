//
//  AddCarTableViewCell.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Package.h"

@interface AddCarTableViewCell : UITableViewCell
/* 车牌号Label */
@property (weak, nonatomic) IBOutlet UILabel *carNumber;
/* 分割线 */
@property (weak, nonatomic) IBOutlet UIView *lineView;
/* 数据模型 */
@property (strong, nonatomic)PackageCarListItem *carModel;

@end
