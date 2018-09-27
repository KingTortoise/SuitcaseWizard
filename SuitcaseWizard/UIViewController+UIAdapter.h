//
//  UIViewController+UIAdapter.h
//  PhotoAlbum
//
//  Created by 金文武 on 17/2/19.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIAdapter)
- (void)setNavigationBarBackButtonWithColor:(UIColor *)color;
- (void)setNavigationBarBackButtonWithTitle:(NSString *)title Color:(UIColor *)color;
- (void)setNavigationBarBackButtonWithImage:(UIImage *)image;

- (void)setNavigationBarTitle:(NSString *)title Color:(UIColor *)color;
- (void)setBackGroundColor;
@end
