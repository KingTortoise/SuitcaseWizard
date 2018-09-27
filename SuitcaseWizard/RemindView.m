//
//  RemindView.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "RemindView.h"

@implementation RemindView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame forAction:nil];
}

- (id)initWithFrame:(CGRect)frame forAction:(buttonCallBackBlock)block
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _callBlock = [block copy];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-120, self.frame.size.height/2-150, 240, 249)];
        [self addSubview:_imageView];
        _imageView.image = [UIImage imageNamed:@"noData"];
        
        
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2-73, self.imageView.frame.origin.y+self.imageView.frame.size.width+30, 145, 45)];
        
        [_btn setBackgroundImage:[UIImage imageNamed:@"addStroke"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
    }
    return self;
}

- (void)setCallBlock:(buttonCallBackBlock)callBlock
{
    _callBlock = [callBlock copy];
}

- (void)buttonAction:(UIButton *)btn
{
    self.callBlock();
}
@end
