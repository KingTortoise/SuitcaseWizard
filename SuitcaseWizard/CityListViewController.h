//
//  CityListViewController.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/9.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityListModel.h"

@protocol returnWithArrayDelegate

- (void)returnWithArray:(NSArray *)array;

@end

@interface CityListViewController : UIViewController
@property (nonatomic, weak)id<returnWithArrayDelegate> delegate;
@property (nonatomic, strong)NSArray<CityListNameModel> *choiceArray;
@end
