//
//  TextFieldView.m
//  yy
//
//  Created by sunliang on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "TextFieldView.h"

@implementation TextFieldView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.TF1.yn_delegate=self;
    self.TF2.yn_delegate=self;
    self.TF3.yn_delegate=self;
    self.TF4.yn_delegate=self;
    self.TF5.yn_delegate=self;
    self.TF6.yn_delegate=self;
    self.TF7.yn_delegate=self;
    self.TF8.yn_delegate=self;
    self.TF9.yn_delegate=self;
    self.TF10.yn_delegate=self;
    self.TF11.yn_delegate=self;
    self.TF12.yn_delegate=self;
    [self.TF1 setAutocorrectionType:UITextAutocorrectionTypeNo];//关闭自动联想
    [self.TF2 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF3 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF4 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF5 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF6 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF7 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF8 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF9 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF10 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF11 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.TF12 setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.alertlabel.text=LocalizationKey(@"Notespace");
   
    
}

- (IBAction)value:(UITextField *)sender {
    
   
    if ([self isHaveEmptyString:sender.text]) {
      
        [sender resignFirstResponder];
        //去掉字符串中所有空格
        sender.text = [sender.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        UITextField *textField = (UITextField *)[self viewWithTag:(sender.tag+1)];
        [textField becomeFirstResponder];
        
    }
    
    
    
}

-(NSString*)checkstring:(UIView*)view{
    if ([NSString stringIsNull:self.TF1.text]||[NSString stringIsNull:self.TF2.text]||[NSString stringIsNull:self.TF3.text]||[NSString stringIsNull:self.TF4.text]||[NSString stringIsNull:self.TF5.text]||[NSString stringIsNull:self.TF6.text]||[NSString stringIsNull:self.TF7.text]||[NSString stringIsNull:self.TF8.text]||[NSString stringIsNull:self.TF9.text]||[NSString stringIsNull:self.TF10.text]||[NSString stringIsNull:self.TF11.text]||[NSString stringIsNull:self.TF12.text]) {
        [view makeToast:LocalizationKey(@"mnemonicwordsnotformatted") duration:1.5 position:CSToastPositionCenter];
        return @"";
    }
    NSString*allStr=[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@",self.TF1.text,self.TF2.text,self.TF3.text,self.TF4.text,self.TF5.text,self.TF6.text,self.TF7.text,self.TF8.text,self.TF9.text,self.TF10.text,self.TF11.text,self.TF12.text];
    
    return allStr;
    
//    if (self.getBackBlock)
//    {
//        self.getBackBlock(self.TF1.text);
//    }
}



//判断字符串是否有空格
-(BOOL)isHaveEmptyString:(NSString *)string {
    NSRange range = [string rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }
    else {
        return NO;
    }
}


//监听键盘点击删除键
#pragma mark-YNTextFieldDelegate
- (void)ynTextFieldDeleteBackward:(YNTextField *)textField{
    
    if (textField.text.length<1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (textField.tag!=1) {
                    [textField resignFirstResponder];//延迟执行
                }
                YNTextField *findTF = (YNTextField *)[self viewWithTag:textField.tag-1];
                
                if (findTF) {
                    [findTF becomeFirstResponder];
                    
                }
            });
        });
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
//    if (![string isEqualToString:tem]) {
//
//        return NO;
//
//    }
//    return YES;
//}


@end
