//
//  Utils.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "Utils.h"
#import "Package.h"

@implementation Utils
+ (UIButton *)createNewBarButtonWithTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 17*title.length, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?-40:-20)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?-20:0)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:SW_NAVIGATIONITEMTITLE_COLOR forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    return button;
}

+ (UIButton *)getNavigationBarBackButtonWithImage:(UIImage *)image{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}

+ (NSArray *)getArrayFromModel:(NSArray *)model{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (id item in model) {
        if ([NSStringFromClass([item class])isEqualToString:@"PackagePlanListItem"]) {
            PackagePlanListItem *planListItem = (PackagePlanListItem *)item;
            NSString *str = [planListItem.price stringByAppendingFormat:@"   %@",planListItem.time];
            [mutableArray addObject:str];
        }else{
            PackageCarListItem *carListItem = (PackageCarListItem *)item;
            NSString *str = [carListItem.carName stringByAppendingFormat:@"   %@",carListItem.carType];
            [mutableArray addObject:str];
        }
    }
    return mutableArray;
}

///**
// 动态计算Collection所在的那一cell需要的高度
// */
+ (NSInteger)changeCollectionViewHeight:(StrokeArrangement *)model{
    NSInteger cellNum = 1;
    NSInteger width = [[UIScreen mainScreen] bounds].size.width - 143;
    NSInteger strTotalWidth = 0;
    for (CityListNameModel *item in model.route) {
        NSString *str = item.cityName;
        strTotalWidth = strTotalWidth + str.length *15 + 37;
        if (strTotalWidth > width) {
            cellNum ++;
            strTotalWidth = str.length *15 + 37;
        }
    }
    return cellNum * 36 + 8;
}

/**
 判断是否为StrokeOfDay那个cell
 */
+ (BOOL)judgeIsDayOrAttractionsCell:(NSInteger)index row:(NSInteger)row model:(CreateNewStrokeViewModel *)viewModel{
    NSInteger num = 0;
    for (int i = 0; i < viewModel.detailModel.travelRoute.allKeys.count; i ++) {
        NSDictionary *dic = viewModel.detailModel.travelRoute;
        StrokeArrangement *item = dic[[NSString stringWithFormat:@"%ld",(long)i]];
        if (num < row && row < num + item.viewspots.count+1) {
            return NO;
        }
        num += item.viewspots.count+1;
    }
    return YES;
}

/**
 获取点击的StrokeOfDay是第几个
 */
+ (NSInteger)getIndexFromRows:(NSInteger)index model:(CreateNewStrokeViewModel *)viewModel{
    NSInteger num = 0;
    for (int i = 0; i < viewModel.detailModel.travelRoute.allKeys.count; i++) {
        NSDictionary *dic = viewModel.detailModel.travelRoute;
        StrokeArrangement *item = dic[[NSString stringWithFormat:@"%ld",(long)i]];
        num = num + item.viewspots.count + 1;
        if (index < num) {
            return i;
        }
    }
    return 0;
}

/**
 获取点击的addAttractions是第几个
 */
+ (NSInteger)getItemIndex:(NSInteger)rows FromIndex:(NSInteger)index model:(CreateNewStrokeViewModel *)viewModel{
    NSInteger num = 0;
    for (int i = 0; i < index; i++) {
        NSDictionary *dic = viewModel.detailModel.travelRoute;
        StrokeArrangement *item = dic[[NSString stringWithFormat:@"%ld",(long)i]];
        num = num + item.viewspots.count + 1;
    }
    return rows - num - 1;
}

@end
