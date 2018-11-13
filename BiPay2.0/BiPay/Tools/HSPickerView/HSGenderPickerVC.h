//
//  HSGenderPickerVC.h
//  HSPickerViewDemo
//
//  Created by husong on 2017/10/27.
//  Copyright © 2017年 husong. All rights reserved.
//

#import "HSBasePickerVC.h"
@class HSGenderPickerVC;

@protocol HSGenderPickerVCDelegate <NSObject>
-(void)genderPicker:(HSGenderPickerVC*)genderPicker
    selectedGernder:(NSString*)gender;
@end

@interface HSGenderPickerVC : HSBasePickerVC
@property (nonatomic, weak) id<HSGenderPickerVCDelegate> delegate;
@end
