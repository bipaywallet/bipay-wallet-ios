//
//  ZoomView.m
//  BiPay
//
//  Created by sunliang on 2018/6/22.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "ZoomView.h"
@interface ZoomView () <UIScrollViewDelegate>
//设置Viewcontroller为代理
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) UIImageView *imageView;

@end



@implementation ZoomView
+(ZoomView *)instancesectionHeaderViewWithFrame:(CGRect)Rect withimage:(UIImage*)image{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZoomView" owner:nil options:nil];
    ZoomView*headerView=[nibView objectAtIndex:0];
    headerView.frame=Rect;
    [headerView configZooming:image];
   
    return headerView;
}
-(void)SingleTap{
    [self removeFromSuperview];
}
-(void)configZooming:(UIImage*)image{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center=CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-50)/2.0);
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    self.scrollView.contentSize = imageView.frame.size;
    //设置缩放比例
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.delegate = self;
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleRecognizer];
}
#pragma mark -<UIScrollViewDelegate>
/**
 *返回一个需要进行缩放的子控件（scrollView的子控件）
 */

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
//保存到相册
- (IBAction)saveTophotos:(UIButton *)sender {
    [self saveImage:self.imageView.image];
}
- (void) saveImage:(UIImage *)image{
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    };
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
}

//保存完成后调用的方法
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
 
        [self makeToast:LocalizationKey(@"saveFail") duration:1.5 position:CSToastPositionCenter];
    }
    else {
        NSLog(@"保存图片成功");
        [self makeToast:LocalizationKey(@"saveSuccess") duration:1.5 position:CSToastPositionCenter];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
