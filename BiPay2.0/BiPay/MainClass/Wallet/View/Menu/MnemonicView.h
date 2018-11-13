//
//  MnemonicView.h
//  BiPay
//
//  Created by 褚青骎 on 2018/8/3.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MnemonicDelegate <NSObject>

- (void)selectWord:(NSString *)word;

@end

@interface MnemonicView : UICollectionView

+ (instancetype) init:(CGRect)frame;

@property (nonatomic, strong) NSArray *mnemonicWord;

@property (nonatomic, assign) id <MnemonicDelegate> mnemonicDelegate;

@end
