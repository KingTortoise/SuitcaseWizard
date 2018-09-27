//
//  CityNameCollectionViewCell.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityListModel.h"

@interface CityNameCollectionViewCell : UICollectionViewCell
/* 城市名 */
@property (weak, nonatomic) IBOutlet UILabel *cityName;
- (void)initData:(CityListNameModel *)item;
@end
