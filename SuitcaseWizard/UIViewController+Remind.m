//
//  UIViewController+Remind.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "UIViewController+Remind.h"
#import "RemindView.h"

@implementation UIViewController (Remind)
- (void)showRemindViewForAction:(buttonCallBackBlock)block{
    RemindView *remindView = [self getRemindView];
    if (!remindView) {
        remindView = [[RemindView alloc]initWithFrame:self.view.frame forAction:block];
        [self.view addSubview:remindView];
    }else{
        remindView.callBlock = block;
        remindView.hidden = NO;
    }
}

- (void)hideRemindView{
    RemindView *remindView = [self getRemindView];
    if (remindView) {
        remindView.hidden = YES;
    }
}

#pragma mark PrivateMethod
- (RemindView *)getRemindView
{
    NSArray *subViews = [self.view subviews];
    RemindView *remindView = nil;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[RemindView class]]) {
            remindView = (RemindView *)view;
            return remindView;
        }
    }
    return nil;
}
@end
