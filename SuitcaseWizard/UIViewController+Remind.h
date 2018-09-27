//
//  UIViewController+Remind.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindView.h"

@interface UIViewController (Remind)
/**
 *  显示没有数据页面
 */
- (void)showRemindViewForAction:(buttonCallBackBlock)block;

/**
 *  隐藏提示页面
 */
- (void)hideRemindView;
@end
