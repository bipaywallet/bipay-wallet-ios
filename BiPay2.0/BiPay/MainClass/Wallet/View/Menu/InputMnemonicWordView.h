//
//  InputMnemonicWordView.h
//  BiPay
//
//  Created by 褚青骎 on 2018/8/2.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputMnemonicWordView : UIView <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end
