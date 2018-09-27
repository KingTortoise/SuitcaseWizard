//
//  PlayMethodViewController.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/10.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SWPlayMethod){
    SWPlayMethodBrightSpotWrite = 0,
    SWPlayMethodBrightSpotRead = 1,
    SWPlayMethodIntroductionWrite = 2,
    SWPlayMethodIntroductionRead = 3
};

@protocol SW_GetTextContentDelegate

- (void)getTextContent:(NSString *)text playMethod:(SWPlayMethod)playMethod;

@end

@interface PlayMethodViewController : UIViewController
//进入这个界面的方式
@property (nonatomic, assign)SWPlayMethod playMethod;
//返回textView内容
@property (nonatomic, weak)id<SW_GetTextContentDelegate> delegate;
//文本内容
@property (nonatomic, strong)NSString *contentString;
@end
