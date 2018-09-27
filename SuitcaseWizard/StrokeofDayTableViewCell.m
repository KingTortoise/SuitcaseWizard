//
//  StrokeofDayTableViewCell.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/7.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "StrokeofDayTableViewCell.h"
#import "CityNameCollectionViewCell.h"
#import "EqualSpaceFlowLayout.h"
#import "CityListModel.h"

@interface StrokeofDayTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,EqualSpaceFlowLayoutDelegate>

@end

@implementation StrokeofDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[[RACObserve(self, model)distinctUntilChanged]deliverOnMainThread]subscribeNext:^(id x) {
        [self.collectionView reloadData];
    }];
    EqualSpaceFlowLayout *flowLayout = [[EqualSpaceFlowLayout alloc] init];
    flowLayout.delegate = self;
    self.collectionView.collectionViewLayout = flowLayout;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.route.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityNameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityNameCell" forIndexPath:indexPath];
    [cell initData:self.model.route[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    CityListNameModel *item = self.model.route[indexPath.row];
    NSString *str = item.cityName;
    CGFloat width = str.length * 15 + 32;
    size  = CGSizeMake(width, 28);
    return size;
}

@end
