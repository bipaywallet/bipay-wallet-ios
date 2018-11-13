//
//  FastNewModel.h
//  BiPay
//
//  Created by sunliang on 2018/8/16.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FastNewModel : NSObject
@property(nonatomic,copy) NSString* newsID;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* content;
@property(nonatomic,copy) NSString* create_time;
@property(nonatomic,copy) NSString* grade;
@property(nonatomic,copy) NSString* up_counts;
@property(nonatomic,copy) NSString* down_counts;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) CGFloat height;
@end
