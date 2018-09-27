//
//  RemindView.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonCallBackBlock)();

@interface RemindView : UIView

@property (nonatomic, copy) buttonCallBackBlock callBlock;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton  *btn;


- (id)initWithFrame:(CGRect)frame forAction:(buttonCallBackBlock)block;


@end
