//
//  UIViewController+UIAdapter.m
//  PhotoAlbum
//
//  Created by 金文武 on 17/2/19.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "UIViewController+UIAdapter.h"

@implementation UIViewController (UIAdapter)
- (void)setNavigationBarBackButtonWithColor:(UIColor *)color
{
    self.navigationItem.leftBarButtonItem = [self backbuttonItemWithTarget:self action:@selector(back) normal:color];
}

- (void)setNavigationBarBackButtonWithTitle:(NSString *)title Color:(UIColor *)color
{
    self.navigationItem.leftBarButtonItem = [self backbuttonItemWithTarget:self action:@selector(back) title:title normal:color];
}

- (void)setNavigationBarBackButtonWithImage:(UIImage *)image{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setNavigationBarTitle:(NSString *)title Color:(UIColor *)color
{
    self.navigationItem.titleView = [self titleLabelWithTitle:title Color:color];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBackGroundColor
{
    self.view.backgroundColor = SW_VIEWBACKGROUND_COLOR;
}

- (UIBarButtonItem *)backbuttonItemWithTarget:(id)target action:(SEL)action normal:(UIColor *)normalColor
{
    return [self backbuttonItemWithTarget:target action:action title:@"返回" normal:normalColor];
}

- (UIBarButtonItem *)backbuttonItemWithTarget:(id)target action:(SEL)action title:(NSString *)title normal:(UIColor *)normalColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?-40:-20, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?-30:-10, 0, 0)];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//设置标题栏标题
- (UILabel *)titleLabelWithTitle:(NSString *)title Color:(UIColor *)color
{
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:17.]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 31)];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:17.];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    return label;
}


@end
