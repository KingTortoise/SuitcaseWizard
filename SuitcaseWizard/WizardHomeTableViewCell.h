//
//  WizardHomeTableViewCell.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizardModel.h"

@interface WizardHomeTableViewCell : UITableViewCell
//封面背景图片
@property (weak, nonatomic) IBOutlet UIImageView *topicImage;
//标题
@property (weak, nonatomic) IBOutlet UILabel *title;
//价格
@property (weak, nonatomic) IBOutlet UILabel *price;
//状态
@property (weak, nonatomic) IBOutlet UILabel *states;
//查看次数
@property (weak, nonatomic) IBOutlet UILabel *viewCount;
//数据模型
@property (strong, nonatomic)WizardModel *model;

@end
