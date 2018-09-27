//
//  CityNameCollectionViewCell.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "CityNameCollectionViewCell.h"


@implementation CityNameCollectionViewCell
- (void)initData:(CityListNameModel *)item{
    self.cityName.text = item.cityName;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

@end
