//
//  CreateNewStrokeViewController.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "CreateNewStrokeViewController.h"
#import "Utils.h"
#import "StatesTableViewCell.h"
#import "StrokeNameTableViewCell.h"
#import "StrokeofDayTableViewCell.h"
#import "AddAttractionsTableViewCell.h"
#import "PackageTableViewCell.h"
#import "AddCarTableViewCell.h"
#import "NormalTableViewCell.h"
#import "CityListViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PlayMethodViewController.h"
#import "CityListModel.h"

#define DELAY 500000000

@interface CreateNewStrokeViewController ()<UITableViewDelegate,UITableViewDataSource,returnWithArrayDelegate,SW_GetTextContentDelegate,UITextFieldDelegate>
/* tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 路线安排headerView */
@property (strong, nonatomic) IBOutlet UIView *StrokeHeaderView;
/* 继续添加footerView */
@property (strong, nonatomic) IBOutlet UIView *continueAddFooterView;
/* 价格定义headerView */
@property (strong, nonatomic) IBOutlet UIView *customPriceHeaderView;
/* 路线安排的footerView */
@property (strong, nonatomic) IBOutlet UIView *StrokeContinueAddFooterView;
/* 添加package(套餐)数量 */
@property (weak, nonatomic) IBOutlet UIButton *addPackage;
/* 价格定义 编辑按钮 */
@property (weak, nonatomic) IBOutlet UIButton *editCustomPriceButton;
/* 添加路线安排section按钮 */
@property (weak, nonatomic) IBOutlet UIButton *addStrokeSection;
/* 路线安排 编辑按钮 */
@property (weak, nonatomic) IBOutlet UIButton *editStrokeButton;
@end

@implementation CreateNewStrokeViewController
#pragma mark - lifeCricle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self bindData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - initView
- (void)initView {
    [self setNavigationBarBackButton];
    [self setNavigationBarTitle:@"新建路线" Color:SW_NAVIGATIONTITLE_COLOR];
    self.viewModel = [[CreateNewStrokeViewModel alloc] init];
    self.uploadBarButton = [Utils createNewBarButtonWithTitle:@"发布"];
    self.saveAsDraft = [Utils createNewBarButtonWithTitle:@"存草稿"];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.uploadBarButton],[[UIBarButtonItem alloc] initWithCustomView:self.saveAsDraft]];
    self.customPriceIsEdit = NO;
    self.strokeIsEdit = NO;
    self.tableView.fd_debugLogEnabled = YES;
    if (self.strokeType != SWIntoStrokeTypeNew) {
        RACTuple *tuple;
        if (self.strokeType == SWIntoStrokeTypeLook) {
            tuple = RACTuplePack(@(1),_guideId);
        }else{
            tuple = RACTuplePack(@(2),_guideId);
        }
        [self.viewModel.requestStrokeDetailRACCommand execute:tuple];
        [self.viewModel.requestAddViewGuideRACCommand execute:_guideId];
    }
}

- (void)setNavigationBarBackButton{
    self.backButton = [Utils getNavigationBarBackButtonWithImage:[UIImage imageNamed:@"backImage"]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - bindData
- (void)bindData{
    @weakify(self);
    //显示正在加载...
    [[[RACSignal combineLatest:@[self.viewModel.requestStrokeDetailRACCommand.executing,self.viewModel.requestAddViewGuideRACCommand.executing] reduce:^id(NSNumber *executing,NSNumber *executing2){
        return @(executing.boolValue && executing2.boolValue);
    }]deliverOnMainThread]subscribeNext:^(id x) {
        if ([x boolValue]) {
            [MBProgressHUD showMessage:@"正在加载"];
        }else{
            [MBProgressHUD hideHUD];
        }
    }];
    //路线安排中数据源发生变化的时候更新UI
    [[[RACObserve(self.viewModel, detailModel.travelRoute)distinctUntilChanged]deliverOnMainThread]subscribeNext:^(NSDictionary *x) {
        @strongify(self);
        self.strokeSectionNum = x.allKeys.count;
        [self.tableView reloadData];
    }];
    //价格定义中数据源发生变化的时候更新UI
    [[[RACObserve(self.viewModel, detailModel.prices)distinctUntilChanged]deliverOnMainThread]subscribeNext:^(NSArray *x) {
        @strongify(self);
        self.pricesSectionNum = x.count;
        [self.tableView reloadData];
    }];
    //点击路线安排编辑按钮
    [[self.editStrokeButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        self.strokeIsEdit = !self.strokeIsEdit;
        if (_strokeIsEdit) {
            [_editStrokeButton setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [_editStrokeButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
        self.tableView.editing = self.strokeIsEdit;
    }];
    //添加路线安排Section
    [[self.addStrokeSection rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.strokeViewModel.addStrokeSectionRACCommand execute:nil];
    }];
    //判断是否隐藏路线安排头部编辑按钮
    RAC(self,editStrokeButton.hidden) = [[RACObserve(self,viewModel.detailModel.travelRoute)distinctUntilChanged] map:^id(NSDictionary *value) {
        @strongify(self);
        if (value.allKeys.count == 1) {
            if (self.strokeSectionNum != value.count) {
                [self.editStrokeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            return @(1);
        }
        return @(0);
    }];
    //点击价格定义编辑按钮
    [[self.editCustomPriceButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        self.customPriceIsEdit = !self.customPriceIsEdit;
        if (_customPriceIsEdit) {
            [_editCustomPriceButton setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [_editCustomPriceButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
        self.tableView.editing = self.customPriceIsEdit;
    }];
    //添加价格定义
    [[self.addPackage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        RACTuple *tuple = RACTuplePack(@(1));
        [self.viewModel.priceViewModel.addCustomPriceSectionRACCommand execute:tuple];
    }];
    //判断价格定义头部中的编辑按钮是否隐藏
    RAC(self,editCustomPriceButton.hidden) = [[RACObserve(self, viewModel.detailModel.prices)distinctUntilChanged] map:^id(NSArray *value) {
        @strongify(self);
        if (value.count == 1) {
            if (self.pricesSectionNum != value.count) {
                [self.editCustomPriceButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            return @(1);
        }
        return @(0);
    }];
    //存草稿按钮
    [[self.saveAsDraft rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        RACSignal *signal = [self.viewModel.saveAsDraftOrPublishRACCommand execute:@(1)];
        [signal subscribeCompleted:^{
            [MBProgressHUD showSuccess:@"保存成功！"];
        }];
    }];
    //发布按钮
    [[self.uploadBarButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        RACSignal *signal = [self.viewModel.saveAsDraftOrPublishRACCommand execute:@(2)];
        [signal subscribeCompleted:^{
            [MBProgressHUD showSuccess:@"发布成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, DELAY), dispatch_get_main_queue(), ^{
                [_delegate pullRefresh];
                [self.rt_navigationController popViewControllerAnimated:YES];
            });
        }];
    }];
    //返回按钮
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.isChanged) {
            [self createAlertControllerStyleIsAlert];
        }else{
            [_delegate pullRefresh];
            [self.rt_navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark- UITextfieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    id cellContent = [[textField superview] superview];
    id cell = [cellContent superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cellContent];
    NSInteger index = [Utils getIndexFromRows:indexPath.row model:_viewModel];
    NSInteger itemIndex = [Utils getItemIndex:indexPath.row FromIndex:index model:_viewModel];
    if ([cell isKindOfClass:[StrokeNameTableViewCell class]]) {
        RACTuple *tuple = RACTuplePack(textField.text,@(1));
        [self.viewModel.playMethodViewModel.savePlayMethodRACCommand execute:tuple];
    }else{
        if (![textField.text isEqualToString:@""]) {
            RACTuple *tuple = RACTuplePack(textField.text,@(index),@(itemIndex));
            [self.viewModel.strokeViewModel.saveOrDeleteAttractionsRACCommand execute:tuple];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section != 2 && section != 3) {
        return 1;
    }else if(section == 2){
        NSInteger num = 0;
        for (int i = 0; i < self.viewModel.detailModel.travelRoute.allKeys.count; i++) {
            StrokeArrangement *item = self.viewModel.detailModel.travelRoute[[NSString stringWithFormat:@"%d",i]];
            num += item.viewspots.count;
        }
        return self.viewModel.detailModel.travelRoute.allKeys.count+ num;
    }else{
        return self.viewModel.detailModel.prices.count * 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        StatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatesCell" forIndexPath:indexPath];
        [cell initData:self.viewModel.detailModel.guideStatus isDraft:self.viewModel.detailModel.isDraft];
        return cell;
    }else if (indexPath.section == 1){
        StrokeNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StrokeNameCell" forIndexPath:indexPath];
        cell.userInteractionEnabled = !(self.strokeType == SWIntoStrokeTypeLook);
        cell.nameTextFeild.text = self.viewModel.detailModel.title != nil? self.viewModel.detailModel.title:nil;
        return cell;
    }else if (indexPath.section == 2){
        NSInteger index = [Utils getIndexFromRows:indexPath.row model:_viewModel];
        NSInteger itemIndex = [Utils getItemIndex:indexPath.row FromIndex:index model:_viewModel];
        if ([Utils judgeIsDayOrAttractionsCell:index row:indexPath.row model:_viewModel]) {
            StrokeofDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StrokeofDayCell" forIndexPath:indexPath];
            cell.userInteractionEnabled = !(self.strokeType == SWIntoStrokeTypeLook);
            StrokeArrangement *model = self.viewModel.detailModel.travelRoute[[NSString stringWithFormat:@"%ld",(long)index]];
            cell.dayLabel.text = [NSString stringWithFormat:@"DAY%ld",index+1];
            cell.model = model;
            return cell;
        }else{
            @weakify(self);
            AddAttractionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAttractionsCell" forIndexPath:indexPath];
            cell.userInteractionEnabled = !(self.strokeType == SWIntoStrokeTypeLook);
            StrokeArrangement *model = self.viewModel.detailModel.travelRoute[[NSString stringWithFormat:@"%ld",(long)index]];
            NSMutableArray *array = model.viewspots.mutableCopy;
            [cell initData:array[itemIndex] num:itemIndex];
            StrokeArrangement *stroke = self.viewModel.detailModel.travelRoute[[NSString stringWithFormat:@"%ld",(long)index]];
            if (itemIndex != stroke.viewspots.count - 1) {
                [[[[[cell.addAttractionsTextField rac_textSignal]takeUntil:cell.rac_prepareForReuseSignal] map:^id(NSString *value) {
                    return @(value.length);
                }]filter:^BOOL(NSNumber *value) {
                    return value.integerValue == 0;
                }]subscribeNext:^(NSNumber *x) {
                    if ([x integerValue] == 0) {
                        @strongify(self);
                        [cell.addAttractionsTextField resignFirstResponder];
                        RACTuple *tuple = RACTuplePack(@"",@(index),@(itemIndex));
                        [self.viewModel.strokeViewModel.saveOrDeleteAttractionsRACCommand execute:tuple];
                    }
                }];
            }
            return cell;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row % 2 == 0) {
            PackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageCell" forIndexPath:indexPath];
            cell.userInteractionEnabled = !(self.strokeType == SWIntoStrokeTypeLook);
            PackageChoiceModel *model = self.viewModel.detailModel.prices[indexPath.row / 2];
            NSInteger rows = indexPath.row / 2 + 1;
            [cell initData:model.plan num:rows];
            return cell;
        }else{
            AddCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCarCell" forIndexPath:indexPath];
            cell.userInteractionEnabled = !(self.strokeType == SWIntoStrokeTypeLook);
            PackageChoiceModel *model = self.viewModel.detailModel.prices[indexPath.row / 2];
            if (indexPath.row == self.viewModel.detailModel.prices.count * 2 - 1) {
                cell.lineView.hidden = YES;
            }else{
                cell.lineView.hidden = NO;
            }
            cell.carModel = model.car;
            return cell;
        }
    }else{
        NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell" forIndexPath:indexPath];
        if(indexPath.section == 4){
            cell.nameLabel.text = @"玩法亮点";
        }else{
            cell.nameLabel.text = @"玩法介绍";
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return _StrokeHeaderView;
    }else if(section == 3){
        return _customPriceHeaderView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return _StrokeContinueAddFooterView;
    }else if (section == 3){
        return _continueAddFooterView;
    }else if(section == 5){
        return nil;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,25)];
        view.backgroundColor = SW_VIEWBACKGROUND_COLOR;
        return view;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.customPriceIsEdit && indexPath.section == 3) || (self.strokeIsEdit && indexPath.section == 2)) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3 && indexPath.row % 2 == 1){
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView :(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.strokeIsEdit && indexPath.section == 2) {
            NSInteger index = [Utils getIndexFromRows:indexPath.row model:_viewModel];
            NSInteger itemIndex = [Utils getItemIndex:indexPath.row FromIndex:index model:self.viewModel];
            if ([Utils judgeIsDayOrAttractionsCell:index row:indexPath.row model:self.viewModel]){
                if (self.viewModel.detailModel.travelRoute.count != 1) {
                    [self.viewModel.strokeViewModel.deleteStrokeSectionRACCommand execute:@(index)];
                }else{
                    [MBProgressHUD showSuccess:@"默认至少有一组，不允许删除！"];
                }
            }else{
                RACTuple *tuple = RACTuplePack(@"",@(index),@(itemIndex));
                [self.viewModel.strokeViewModel.saveOrDeleteAttractionsRACCommand execute:tuple];
            }
        }else if (self.customPriceIsEdit && indexPath.section == 3){
            RACTuple *tuple = RACTuplePack(@(0),@(indexPath.row / 2));
            if (self.viewModel.detailModel.prices.count != 1) {
                [self.viewModel.priceViewModel.addCustomPriceSectionRACCommand execute:tuple];
            }else{
                 [MBProgressHUD showSuccess:@"默认至少有一组，不允许删除！"];
            }
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2 || section == 3) {
        return 44;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2){
        return 44;
    }else if(section == 3){
        return 59;
    }else if(section == 5){
        return 0;
    }else{
        return  25;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        return 181;
    }else if (indexPath.section == 2){
        NSInteger index = [Utils getIndexFromRows:indexPath.row model:self.viewModel];
        if ([Utils judgeIsDayOrAttractionsCell:index row:indexPath.row model:self.viewModel]) {
            NSDictionary *dic = self.viewModel.detailModel.travelRoute;
            StrokeArrangement *model = dic[[NSString stringWithFormat:@"%ld",(long)index]];
            return [Utils changeCollectionViewHeight:model];
        }
        return 45;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 2){
        NSInteger index = [Utils getIndexFromRows:indexPath.row model:_viewModel];
        if ([Utils judgeIsDayOrAttractionsCell:index row:indexPath.row model:self.viewModel]){
            self.hitCell = [Utils getIndexFromRows:indexPath.row model:_viewModel];
            CityListViewController *cityList = [[UIStoryboard storyboardWithName:@"CityList" bundle:nil]instantiateInitialViewController];
            cityList.delegate = self;
            NSDictionary *dic = self.viewModel.detailModel.travelRoute;
            StrokeArrangement *stroke = dic[[NSString stringWithFormat:@"%ld",(long)index]];
            if (stroke.route.count != 0) {
                cityList.choiceArray = stroke.route;
            }
            [self.rt_navigationController pushViewController:cityList animated:YES complete:nil];
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row % 2 == 0) {
            @weakify(self);
            RACSignal *signal = [self.viewModel.priceViewModel.requestPlanListRACCommand execute:nil];
            [signal subscribeCompleted:^{
                @strongify(self);
                self.planListArray = [Utils getArrayFromModel:self.viewModel.priceViewModel.list];
                self.chooseAlert = [self createAlertControllerWithArray:_planListArray RowAtIndexPath:indexPath choiceType:0];
                [self presentViewController:self.chooseAlert animated:YES completion:nil];
            }];
        }else{
            @weakify(self);
            RACSignal *signal = [self.viewModel.priceViewModel.requestCarListRACCommand execute:nil];
            [signal subscribeCompleted:^{
                @strongify(self);
                self.planListArray = [Utils getArrayFromModel:self.viewModel.priceViewModel.carList];
                self.chooseAlert = [self createAlertControllerWithArray:_planListArray RowAtIndexPath:indexPath choiceType:1];
                [self presentViewController:self.chooseAlert animated:YES completion:nil];
            }];
        }
    }
    if (indexPath.section == 4) {
        PlayMethodViewController *playMethod = [[UIStoryboard storyboardWithName:@"PlayMethod" bundle:nil]instantiateInitialViewController];
        if (self.strokeType == SWIntoStrokeTypeLook) {
            playMethod.playMethod = SWPlayMethodBrightSpotRead;
        }else{
            playMethod.playMethod = SWPlayMethodBrightSpotWrite;
        }
        playMethod.delegate = self;
        playMethod.contentString = self.viewModel.detailModel.strength != nil?self.viewModel.detailModel.strength : nil;
        [self.rt_navigationController pushViewController:playMethod animated:YES];
    }else if (indexPath.section == 5){
        PlayMethodViewController *playMethod = [[UIStoryboard storyboardWithName:@"PlayMethod" bundle:nil]instantiateInitialViewController];
        if (self.strokeType == SWIntoStrokeTypeLook) {
            playMethod.playMethod = SWPlayMethodIntroductionRead;
        }else{
            playMethod.playMethod = SWPlayMethodIntroductionWrite;
        }
        playMethod.delegate  = self;
        playMethod.contentString = self.viewModel.detailModel.introduction != nil?self.viewModel.detailModel.introduction : nil;
        [self.rt_navigationController pushViewController:playMethod animated:YES];
    }
}

#pragma mark - PrivateMethod
/**
 套餐与车辆选择器
 */
- (UIAlertController *)createAlertControllerWithArray:(NSArray *)array RowAtIndexPath:(NSIndexPath *)indexPath choiceType:(NSInteger)num{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"价格定义" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0;i < array.count; i++) {
        @weakify(self);
        NSString *str = array[i];
        UIAlertAction *otherButton = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            NSInteger index = indexPath.row / 2;
            RACTuple *tuple = RACTuplePack(@(num),@(index),@(i));
            [self.viewModel.priceViewModel.choicePackageOrCarRACCommand execute:tuple];
        }];
        [alertController addAction:otherButton];
    }
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelButton];
    return alertController;
}

/**
 退出时actionSheet
 */
- (void)createAlertControllerStyleIsAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"文本已发生改变，是否保存？" preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *saveButton = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        RACSignal *signal;
        if (self.viewModel.detailModel.guideStatus != nil) {
            signal = [self.viewModel.saveAsDraftOrPublishRACCommand execute:@(2)];
        }else{
           signal = [self.viewModel.saveAsDraftOrPublishRACCommand execute:@(1)];
        }
        [signal subscribeCompleted:^{
            [MBProgressHUD showSuccess:@"保存成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, DELAY), dispatch_get_main_queue(), ^{
                [_delegate pullRefresh];
                [self.rt_navigationController popViewControllerAnimated:YES];
            });
        }];
    }];
    UIAlertAction *backButton = [UIAlertAction actionWithTitle:@"返回上一界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [_delegate pullRefresh];
        [self.rt_navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:saveButton];
    [alertController addAction:backButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 选择城市代理
 */
- (void)returnWithArray:(NSArray *)array{
    RACTuple *tuple = RACTuplePack(@(_hitCell),array);
    [self.viewModel.strokeViewModel.saveSelectedCityRACCommand execute:tuple];
}

/**
 玩法代理
 */
- (void)getTextContent:(NSString *)text playMethod:(SWPlayMethod)playMethod{
    if (playMethod == SWPlayMethodBrightSpotWrite) {
        RACTuple *tuple = RACTuplePack(text,@(2));
        [self.viewModel.playMethodViewModel.savePlayMethodRACCommand execute:tuple];
    }else{
        RACTuple *tuple = RACTuplePack(text,@(3));
        [self.viewModel.playMethodViewModel.savePlayMethodRACCommand execute:tuple];
    }
}
@end
