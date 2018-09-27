//
//  StatesTableViewCell.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatesTableViewCell : UITableViewCell
/* 状态标签 */
@property (weak, nonatomic) IBOutlet UILabel *statesLabel;

- (void)initData:(NSNumber *)guideStatus  isDraft:(NSNumber *)isDraft;
@end
