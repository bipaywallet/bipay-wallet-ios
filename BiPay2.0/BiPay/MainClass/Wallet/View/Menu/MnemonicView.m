//
//  MnemonicView.m
//  BiPay
//
//  Created by 褚青骎 on 2018/8/3.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "MnemonicView.h"
#import "MnemonicViewCell.h"

@interface MnemonicView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end

@implementation MnemonicView


+ (instancetype)init:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return [[self alloc] initWithFrame:frame collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self) {
        [self registerNib:[UINib nibWithNibName:@"MnemonicViewCell" bundle:nil] forCellWithReuseIdentifier:@"MnemonicViewCell"];
        self.backgroundColor = CellBackColor;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}


#pragma mark --UICollectionView DataSource
/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/** 每组中cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mnemonicWord.count;
}

/** 初始化cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MnemonicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MnemonicViewCell" forIndexPath:indexPath];
    cell.wordCell.text = _mnemonicWord[indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout Delagate
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 20)/4, 50);
}

/** 分区内cell之间的最小行间距*/
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
/** 分区内cell之间的最小列间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark --UICollectionView Delegate
/** cell的点击事件*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_mnemonicDelegate selectWord:_mnemonicWord[indexPath.row]];
}


@end
