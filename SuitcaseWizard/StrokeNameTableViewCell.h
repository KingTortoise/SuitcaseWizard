//
//  StrokeNameTableViewCell.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StrokeNameTableViewCell : UITableViewCell
/* 上传封面 */
@property (weak, nonatomic) IBOutlet UIImageView *topicImage;
/* 填写玩法名称文本输入框 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextFeild;

@end
