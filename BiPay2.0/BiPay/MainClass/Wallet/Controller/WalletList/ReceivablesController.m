//
//  ReceivablesController.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ReceivablesController.h"
#import "YSActionSheetView.h"
#import "shareManger.h"
#import <Photos/PHPhotoLibrary.h>
#import "shareView.h"
@interface ReceivablesController ()<PlatformButtonClickDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ercodeImageV;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *saveImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *acopyAddress;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property(nonatomic,strong)shareView*shareview;
@end

@implementation ReceivablesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightBarButtonItem];
    self.view.backgroundColor=ViewBackColor;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.coinNameLabel.text=self.coin.brand;
    self.amountLabel.text=LocalizationKey(@"TransferAmount");
    CIImage *codeCIImage = [self createQRForString:[NSString stringWithFormat:@"%@:%@:%@",self.coin.brand,self.coin.address,@"0"]];
    self.ercodeImageV.image = [self createNonInterpolatedUIImageFormCIImage:codeCIImage withSize:200];
    [self.inputTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.inputTF.delegate=self;
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.0];
    [SVProgressHUD dismiss];
}
-(void)delayMethod{
    CIImage *codeCIImage = [self createQRForString:[NSString stringWithFormat:@"%@:%@:%@",self.coin.brand,self.coin.address,@"0"]];
    self.shareview=[shareView instancesViewWithFrame:CGRectMake(self.backView.x+10, self.backView.y, self.backView.width-20, self.backView.height-50)];
    self.shareview.ercodeImageV.image=[self createNonInterpolatedUIImageFormCIImage:codeCIImage withSize:200];
    self.shareview.addressLabel.text=[NSString stringWithFormat:@"%@\n\n%@",LocalizationKey(@"inAddress"),self.coin.address];
    [self.view insertSubview:self.shareview atIndex:0];
}
/**
 实时监听文字内容变化

 */
- (void)textFieldChanged:(UITextField*)textField{
    
    CIImage *codeCIImage = [self createQRForString:[NSString stringWithFormat:@"%@:%@:%@",self.coin.brand,self.coin.address,self.inputTF.text]];
    self.ercodeImageV.image = [self createNonInterpolatedUIImageFormCIImage:codeCIImage withSize:200];
    self.shareview.ercodeImageV.image=[self createNonInterpolatedUIImageFormCIImage:codeCIImage withSize:200];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = NavColor;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = ViewBackColor;
    self.navigationItem.title=LocalizationKey(@"collectCode");
    self.addressLabel.text=[NSString stringWithFormat:@"%@\n\n%@",LocalizationKey(@"inAddress"),self.coin.address];
    [self.saveImgBtn setTitle:LocalizationKey(@"saveImg") forState:UIControlStateNormal];
    [self.acopyAddress setTitle:LocalizationKey(@"copyAddress") forState:UIControlStateNormal];
}
- (void)setRightBarButtonItem
{
    UIButton * rightItem = [[UIButton alloc]init];
    [rightItem.titleLabel setFont:systemFont(15)];
    [rightItem setTitle:LocalizationKey(@"share") forState:UIControlStateNormal];
    [rightItem setTitleColor:barTitle forState:UIControlStateNormal];
    __weak ReceivablesController *weakself=self;
    [rightItem dn_addActionHandler:^{
//        YSActionSheetView * ysSheet=[[YSActionSheetView alloc]initNYSView];
//        ysSheet.delegate=weakself;
//        [APPLICATION.window addSubview:ysSheet];
        [weakself shareForSystem];
        
    }];
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = right;
}


/**
 系统自带的分享
 */
-(void)shareForSystem{
    
        UIImage *shareImage = [self convertViewToImage:self.shareview];
        NSArray *activityItems = [[NSArray alloc] initWithObjects:shareImage, nil];
        
        UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            NSLog(@"%@",activityType);
            if (completed) {
                NSLog(@"分享成功");
            } else {
                NSLog(@"分享失败");
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
        
        vc.completionWithItemsHandler = myBlock;
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    
    
- (void) customActionSheetButtonClick:(YSActionSheetButton *) btn
{
    switch (btn.tag)
    {
        case 0:
        {
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[self convertViewToImage:self.backView],@"Screenshot", nil];
            [[shareManger defaultShareManger] shareWithWxiFriend:dic ];
            
        }
            break;
        case 1:
        {
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[self convertViewToImage:self.backView],@"Screenshot", nil];
            [[shareManger defaultShareManger] shareWithWxiFriendQuan:dic ];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
        {
            
        }
            break;
            
    }
}
- (UIImage*)convertViewToImage:(UIView *)_tempView {
    CGSize s = _tempView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [_tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //水印图
    UIImage *waterimage = [UIImage imageNamed:@"no"];
    [waterimage drawInRect:CGRectMake((size-waterimage.size.width)/2.0, (size-waterimage.size.height)/2.0, waterimage.size.width, waterimage.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
//MARK:--字符串生成二维码
- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}
//复制地址or保存图片
- (IBAction)touchEvent:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:self.coin.address];
            if (pab == nil) {
                [self.view makeToast:LocalizationKey(@"copyFail") duration:1.5 position:CSToastPositionCenter];
            }else
            {
                [self.view makeToast:LocalizationKey(@"copySuccess") duration:1.5 position:CSToastPositionCenter];
            }
        }
            break;
        case 1:{
             [self saveImage:self.ercodeImageV.image];
            
        }
            
            break;
        default:
            break;
    }
}
//image是要保存的图片
- (void)saveImage:(UIImage *)image{
    if (image) {
         UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        
        
    };
}
- (BOOL)isAvailablePhoto
{
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusAuthorized) {
        
        return YES;
    }
    return NO;
}
//保存完成后调用的方法
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        if (![self isAvailablePhoto])
        {
            NSString *tipMessage = LocalizationKey(@"photoRightTips");
            [self showError:tipMessage andTitle:LocalizationKey(@"photoNoRight")];
        }
            
            
        [self.view makeToast:LocalizationKey(@"saveFail") duration:1.5 position:CSToastPositionCenter];
    }
    else {
        
        [self.view makeToast:LocalizationKey(@"saveSuccess") duration:1.5 position:CSToastPositionCenter];
    }
}

/*
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}


/**
 控制textField输入位数
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 8;//小数点后需要限制的个数
    for (int i = (int)futureString.length-1; i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
