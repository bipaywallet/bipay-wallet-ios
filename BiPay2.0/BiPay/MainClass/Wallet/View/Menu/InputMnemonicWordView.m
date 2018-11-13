//
//  InputMnemonicWordView.m
//  BiPay
//
//  Created by 褚青骎 on 2018/8/2.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "InputMnemonicWordView.h"

@implementation InputMnemonicWordView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
//    self.placeholder.enabled = NO;
    self.placeholder.text = LocalizationKey(@"pleaseInputMemoryWord");
}

- (void)textViewDidChange:(UITextView *)textView {
    if([textView.text length] == 0){
        [self.placeholder setHidden:NO];
    } else {
        [self.placeholder setHidden:YES];
    }
}

@end
