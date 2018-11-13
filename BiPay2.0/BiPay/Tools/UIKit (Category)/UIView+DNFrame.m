//
//  UIView+DNFrame.m
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "UIView+DNFrame.h"

@implementation UIView (DNFrame)

- (CGFloat)dn_x{
    
    return self.frame.origin.x;
}
- (void)setDn_x:(CGFloat)dn_x{
    
    CGRect frame = self.frame;
    frame.origin.x = dn_x;
    self.frame = frame;
}

- (CGFloat)dn_y{
    
    return self.frame.origin.y;
}

- (void)setDn_y:(CGFloat)dn_y{
    
    CGRect frame = self.frame;
    frame.origin.y = dn_y;
    self.frame = frame;
}

- (CGFloat)dn_right{
    
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setDn_right:(CGFloat)dn_right{
    
    CGRect frame = self.frame;
    frame.origin.x = dn_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)dn_bottom{
    
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setDn_bottom:(CGFloat)dn_bottom{
    
    CGRect frame = self.frame;
    
    frame.origin.y = dn_bottom - frame.size.height;
    
    self.frame = frame;
}

- (CGFloat)dn_width{
    
    return self.frame.size.width;
}
- (void)setDn_width:(CGFloat)dn_width{
    
    CGRect frame = self.frame;
    frame.size.width = dn_width;
    self.frame = frame;
}

- (CGFloat)dn_height{
    
    return self.frame.size.height;
}
- (void)setDn_height:(CGFloat)dn_height{
    
    CGRect frame = self.frame;
    frame.size.height = dn_height;
    self.frame = frame;
}


- (CGFloat)dn_centerX{
    
    return self.center.x;
}
- (void)setDn_centerX:(CGFloat)dn_centerX{
    
    self.center = CGPointMake(dn_centerX, self.center.y);
}

- (CGFloat)dn_centerY{
    
    return self.center.y;
}
- (void)setDn_centerY:(CGFloat)dn_centerY{
    
    self.center = CGPointMake(self.center.x, dn_centerY);
}

- (CGPoint)dn_origin{
    
    return self.frame.origin;
}
- (void)setDn_origin:(CGPoint)dn_origin{
    
    CGRect frame = self.frame;
    frame.origin = dn_origin;
    self.frame = frame;
}

- (CGSize)dn_size{
    
    return self.frame.size;
}
- (void)setDn_size:(CGSize)dn_size{
    
    CGRect frame = self.frame;
    frame.size = dn_size;
    self.frame = frame;
}

@end
