//
//  CityListViewController.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/9.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "CityListViewController.h"
#import "CityListViewModel.h"
#import "Utils.h"

@interface CityListViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic)UIButton *backButton;
@property (strong, nonatomic)CityListViewModel *viewModel;
@property (strong, nonatomic)UIGestureRecognizer *gesture;
@property (nonatomic, strong)IQKeyboardManager *manager;
@property (nonatomic, strong)NSString *searchText;
@end

@implementation CityListViewController
#pragma mark - lifeCricle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self bindData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - init
- (void)initView{
    [self setNavigationBarTitle:@"城市列表" Color:SW_NAVIGATIONTITLE_COLOR];
    [self setNavigationBarBackButtonWithImage:[UIImage imageNamed:@"backImage"]];
    self.backButton = [Utils createNewBarButtonWithTitle:@"保存"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_backButton];
    self.navigationItem.rightBarButtonItem = item;
    self.viewModel = [[CityListViewModel alloc] init];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"searchBarBG"]];
    [self.searchBar setPlaceholder:@"搜索"];
    self.searchBar.delegate = self;
    self.manager = [IQKeyboardManager sharedManager];
    self.searchText = @"";
    if (self.choiceArray.count != 0) {
        self.viewModel.choiceArray = self.choiceArray;
    }
}

- (void)bindData{
    @weakify(self);
    [self.viewModel.requestCityListRACCommand execute:nil];
    /* 加载动画 */
    [[[RACSignal combineLatest:@[self.viewModel.requestCityListRACCommand.executing,RACObserve(self.viewModel,list)] reduce:^id(NSNumber *executing,NSArray *cellModel){
        return @(executing.boolValue && cellModel.count == 0);
    }]deliverOnMainThread]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            [self hideRemindView];
            [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
        }else{
            [MBProgressHUD hideHUDForView:self.view];
        }
    }];
    /*  刷新UI */
    [[[RACObserve(self, viewModel.list) distinctUntilChanged]deliverOnMainThread]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    /* 下拉刷新 */
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        RACSignal *signal = [self.viewModel.requestCityListRACCommand execute:nil];
        [signal subscribeError:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
        [signal subscribeCompleted:^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    } ];
    /* 获取到搜索框中的值 */
    [[self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)]subscribeNext:^(RACTuple *x) {
        self.searchText = x[1];
    }];
    /* 
       如何搜索框中的值在0.1秒内没有再次发生改变，那么就进行模糊搜索
       原本设置的是0.3秒，但是会导致看起来有点卡顿
     */
    [[[RACObserve(self, searchText)throttle:0.1]distinctUntilChanged]subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.searchRequestRACCommand execute:x];
    }];
    /* 点击搜索时退出搜索键盘 */
    [[self rac_signalForSelector:@selector(searchBarSearchButtonClicked:) fromProtocol:@protocol(UISearchBarDelegate)]subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    /* 点击保存 要返回数据 */
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        RACSignal *signal = [self.viewModel.getStringArrayRACCommand execute:nil];
        [signal subscribeCompleted:^{
            @strongify(self);
            [_delegate returnWithArray:self.viewModel.backList];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityListCell" forIndexPath:indexPath];
    CityListNameModel *model = self.viewModel.list[indexPath.row];
    cell.textLabel.text = model.cityName;
    cell.detailTextLabel.text = model.engName;
    if ([model.isSelected integerValue] == 0) {
        cell.accessoryType =  UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!_manager.keyboardShowing) {
        [self.viewModel.cellIsSelectedRACCommand execute:@(indexPath.row)];
    }
}

@end
