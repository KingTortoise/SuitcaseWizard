//
//  StrokeofDayTableViewCell.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrokeArrangement.h"

@interface StrokeofDayTableViewCell : UITableViewCell
/* DAY  Label */
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
/* 显示城市列表的collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/* 数据模型 */
@property (strong, nonatomic)StrokeArrangement *model;

@end
