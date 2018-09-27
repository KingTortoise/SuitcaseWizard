//
//  CreateNewStrokeViewController.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateNewStrokeViewModel.h"
#import "PackageViewModel.h"

typedef NS_ENUM(NSInteger,SWIntoStrokeType){
    SWIntoStrokeTypeNew = 0, //新建
    SWIntoStrokeTypeDraft = 1, //草稿状态（这里包含自己创建的草稿和发布路线）
    SWIntoStrokeTypeLook = 2,  //查看
};

@protocol SW_PullRefreshDelegate

- (void)pullRefresh;

@end

@interface CreateNewStrokeViewController : UIViewController
@property (nonatomic, weak)id<SW_PullRefreshDelegate> delegate;
//进入该界面的方式
@property (nonatomic, assign)SWIntoStrokeType strokeType;
//ID
@property (nonatomic, strong)NSNumber *guideId;
/* VM */
@property (nonatomic, strong)CreateNewStrokeViewModel *viewModel;
/* 发布按钮 */
@property (nonatomic, strong)UIButton *uploadBarButton;
/* 存草稿按钮 */
@property (nonatomic, strong)UIButton *saveAsDraft;
/* 返回按钮 */
@property (nonatomic, strong)UIButton *backButton;
/* 用于判断价格定义进入编辑模式 */
@property (assign, nonatomic)BOOL customPriceIsEdit;
/* 用于判断路线安排是否进入编辑模式 */
@property (assign, nonatomic)BOOL strokeIsEdit;
/* 选择器 */
@property (strong, nonatomic)UIAlertController *chooseAlert;
/* planList转换后的NSString数组 */
@property (strong, nonatomic)NSArray *planListArray;
/* 当前点击的是哪一个StrokeOfDay */
@property (assign, nonatomic)NSInteger hitCell;
/* collection的数据源 */
@property (strong, nonatomic)NSArray *collectionArray;
/* cell中collectionViewHeight的高度 */
@property (assign, nonatomic)NSInteger collectionViewHeight;
/* 保存之前价格定义section的数量 */
@property (assign, nonatomic)NSInteger pricesSectionNum;
/* 保存之前路线安排section的数量 */
@property (assign, nonatomic)NSInteger strokeSectionNum;
@end
