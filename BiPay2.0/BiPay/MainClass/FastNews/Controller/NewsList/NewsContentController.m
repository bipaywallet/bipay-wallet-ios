//
//  NewsContentController.m
//  BiPay
//
//  Created by 褚青骎 on 2018/7/3.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "NewsContentController.h"
#import "WYWebProgressLayer.h"
#import "UIView+Frame.h"
#import "WLWebProgressLayer.h"
#import "YSActionSheetView.h"
#import "shareManger.h"
#import "MMScanViewController.h"


@interface NewsContentController () <PlatformButtonClickDelegate>
{
    UIImage*_currentImage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRcodeViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *QRCodeDescripLb;
@property (weak, nonatomic) IBOutlet UIView *QRCodeView;


@property (strong, nonatomic) WYWebProgressLayer *progressLayer;

@end

@implementation NewsContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarBuutonItem];
   
    
    self.QRcodeViewHeight.constant = SCREEN_HEIGHT*0.25;
    CGFloat Height=[self getLabelHeightWithText:self.model.content width:kWindowW-60 font:15];
    self.newsContent.frame=CGRectMake(0, 0, kWindowW, Height+252*kWindowW/750+70+50+20+SCREEN_HEIGHT*0.25);
    self.scrollView.contentSize=CGSizeMake(kWindowW,self.newsContent.height);
    [self.scrollView addSubview:self.newsContent];
    self.timeLabel.text=[self timeTransferFromLasttime:self.model.create_time];
    self.titleLab.text = self.model.title;
    self.contentLabel.text=self.model.content;
    self.timeLabel.textColor = OrangeColor;
    
//    UIImage * image = [MMScanViewController createQRImageWithString:@"我是一个二维码" QRSize:CGSizeMake(SCREEN_HEIGHT*0.18, SCREEN_HEIGHT*0.18)];
    self.QRCodeImageView.image = [UIImage imageNamed:@"QRCode"];
    self.QRCodeImageView.contentMode = UIViewContentModeScaleToFill;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title =LocalizationKey(@"detail");
    self.QRCodeDescripLb.text =LocalizationKey(@"scanQRCode");
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    [self rightItemClick];
}

- (void)setRightBarBuutonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"share")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(rightItemClick)];
}
- (void)rightItemClick
{
    
//    UIImage * contentImage = [self imageWithScreenshot];
//    UIImage * QRCodeImage  = [self convertViewToImage:self.QRCodeView];
    
    _currentImage = [self convertViewToImage:self.newsContent];
    
    //_currentImage = [self imageWithScreenshot];
    
    YSActionSheetView * ysSheet=[[YSActionSheetView alloc]initNYSView];
    ysSheet.delegate=self;
    [APPLICATION.window addSubview:ysSheet];
    
}
- (void)customActionSheetButtonClick:(YSActionSheetButton *) btn
{
    switch (btn.tag) {
        case 0: {
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:_currentImage,@"Screenshot", nil];
            [[shareManger defaultShareManger] shareWithWxiFriend:dic ];
            
        }
            break;
        case 1: {
            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:_currentImage,@"Screenshot", nil];
            [[shareManger defaultShareManger] shareWithWxiFriendQuan:dic ];
        }
            break;
        case 2: {
            
        }
            break;
        case 3: {
            
        }
            break;
            
        default: {
            
        }
            break;
    }
}
- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}

// 将 View 转成图片
- (UIImage*)convertViewToImage:(UIView*)QRCodeView {
    
    CGSize size = QRCodeView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [QRCodeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*
*  返回截取到的图片
*
*  @return UIImage *
*/
- (UIImage *)imageWithScreenshot {
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
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*0.75);
    }
    else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
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

#pragma mark 合并图片（竖着合并，以第一张图片的宽度为主）
- (UIImage *)combine:(UIImage *)contentImage QRCodeImage:(UIImage *)QRCodeImage {
    //计算画布大小
    CGFloat width = contentImage.size.width;
    CGFloat height = contentImage.size.height + QRCodeImage.size.height;
    CGSize resultSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(resultSize);
    
    //放第一个图片
    CGRect oneRect = CGRectMake(0, 0, resultSize.width, contentImage.size.height);
    [contentImage drawInRect:oneRect];
    
    //放第二个图片
    CGRect otherRect = CGRectMake(0, oneRect.size.height, resultSize.width, QRCodeImage.size.height);
    [QRCodeImage drawInRect:otherRect];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSString*)timeTransferFromLasttime:(NSString*)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy年MM月dd日
    NSString *dateString = time;
    //误区** 字符串长度必须与formatter长度对应一致 不然date就是nil
    dateString = [dateString substringToIndex:10];
    NSDate *date = [formatter dateFromString:dateString];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString*endtime = [formatter stringFromDate:date];
    NSString*week=[self getWeekDay:endtime];
    NSString*clock=[time substringFromIndex:time.length-8];
    return [NSString stringWithFormat:@"%@ %@ %@",endtime,week,clock];
}

- (NSString*)getWeekDay:(NSString*)currentStr {

    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy年MM月dd日"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate*date =[dateFormat dateFromString:currentStr];
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],LocalizationKey(@"Sunday"),LocalizationKey(@"Monday"),LocalizationKey(@"Tuesday"),LocalizationKey(@"Wednesday"),LocalizationKey(@"Thursday"),LocalizationKey(@"Friday"),LocalizationKey(@"Saturday"),nil];
    
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}


- (void)dealloc {
    NSLog(@"i am dealloc");
}

@end
