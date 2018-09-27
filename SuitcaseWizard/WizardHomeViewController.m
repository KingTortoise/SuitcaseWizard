//
//  WizardHomeViewController.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "WizardHomeViewController.h"
#import "WizardHomeTableViewCell.h"
#import "CreateNewStrokeViewController.h"
#import "WizardHomeVM.h"

@interface WizardHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SW_PullRefreshDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)WizardHomeVM *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *addStrokeButton;
@property (assign, nonatomic)BOOL needShowLoading;

@end

@implementation WizardHomeViewController
#pragma mark - lifeCricle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self bindData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - init
- (void)initView{
    [self setNavigationBarTitle:@"旅行箱向导版" Color:SW_NAVIGATIONTITLE_COLOR];
    self.addStrokeButton.layer.cornerRadius = self.addStrokeButton.frame.size.width / 2;
    self.addStrokeButton.clipsToBounds = YES;
    self.needShowLoading = YES;
    self.viewModel = [[WizardHomeVM alloc] init];
    [self.viewModel.requestDataRACCommand execute:@(USERID)];
}

- (void)bindData{

    @weakify(self);
    /* 加载动画 */
    [[[RACSignal combineLatest:@[self.viewModel.requestDataRACCommand.executing,RACObserve(self,viewModel.response)] reduce:^(NSNumber *executing,NSArray *cellModel){
        return @(executing.boolValue && cellModel.count == 0 && self.needShowLoading);
    }]deliverOnMainThread]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            [self hideRemindView];
            [MBProgressHUD showMessage:@"正在加载..."];
        }else{
            [MBProgressHUD hideHUD];
        }
    }];
    /* 显示无数据界面 */
    [[RACObserve(self, viewModel.showNoDataView) deliverOnMainThread]subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            [MBProgressHUD hideHUD];
            [self showRemindViewForAction:^{
                CreateNewStrokeViewController *viewController = [[UIStoryboard storyboardWithName:@"CreateNewStroke" bundle:nil]instantiateInitialViewController];
                viewController.strokeType = SWIntoStrokeTypeNew;
                viewController.delegate = self;
                [self.rt_navigationController pushViewController:viewController animated:YES];
            }];
        }else{
            [self hideRemindView];
        }
    }];
    /* 下拉刷新 */
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        RACSignal *signal = [self.viewModel.requestDataRACCommand execute:@(USERID)];
        [signal subscribeError:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
        [signal subscribeCompleted:^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    } ];
    //数据模型发生改变  更新界面
    [[[RACObserve(self, viewModel.response)distinctUntilChanged]deliverOnMainThread]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
   
    //新建路径按钮点击事件
    [[self.addStrokeButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self)
        CreateNewStrokeViewController *viewController = [[UIStoryboard storyboardWithName:@"CreateNewStroke" bundle:nil]instantiateInitialViewController];
        viewController.strokeType = SWIntoStrokeTypeNew;
        viewController.delegate = self;
        [self.rt_navigationController pushViewController:viewController animated:YES];
    }];
}

#pragma mark - SW_PullRefreshDelegate
- (void)pullRefresh{
    self.needShowLoading = NO;
    [self.viewModel.requestDataRACCommand execute:@(USERID)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.response.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WizardHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WizardHomeCell" forIndexPath:indexPath];
    cell.model = self.viewModel.response[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CreateNewStrokeViewController *viewController = [[UIStoryboard storyboardWithName:@"CreateNewStroke" bundle:nil]instantiateInitialViewController];
    if ([self.viewModel.response[indexPath.row].userId integerValue] == USERID) {
        viewController.strokeType = SWIntoStrokeTypeDraft;
    }else{
        viewController.strokeType = SWIntoStrokeTypeLook;
    }
    viewController.guideId = self.viewModel.response[indexPath.row].guideId;
    viewController.delegate = self;
    [self.rt_navigationController pushViewController:viewController animated:YES];
}

@end
