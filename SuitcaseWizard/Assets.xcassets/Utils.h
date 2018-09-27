//
//  Utils.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StrokeArrangement.h"
#import "CreateNewStrokeViewModel.h"


@interface Utils : NSObject
//创建一个带有标题的UIButton
+ (UIButton *)createNewBarButtonWithTitle:(NSString *)title;
//获取一个带图片的返回按钮
+ (UIButton *)getNavigationBarBackButtonWithImage:(UIImage *)image;
//将出行计划和出行车辆数组中的String连接起来
+ (NSArray *)getArrayFromModel:(id)model;
// 动态计算Collection所在的那一cell需要的高度
+ (NSInteger)changeCollectionViewHeight:(StrokeArrangement *)model;
// 判断是否为StrokeOfDay那个cell
+ (BOOL)judgeIsDayOrAttractionsCell:(NSInteger)index row:(NSInteger)row model:(CreateNewStrokeViewModel *)viewModel;
// 获取点击的addAttractions是第几个
+ (NSInteger)getItemIndex:(NSInteger)rows FromIndex:(NSInteger)index model:(CreateNewStrokeViewModel *)viewModel;
// 获取点击的StrokeOfDay是第几个
+ (NSInteger)getIndexFromRows:(NSInteger)index model:(CreateNewStrokeViewModel *)viewModel;
@end
