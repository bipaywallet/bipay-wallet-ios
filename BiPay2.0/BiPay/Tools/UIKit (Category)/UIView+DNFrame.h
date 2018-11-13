//
//  UIView+DNFrame.h
//  DNProject
//
//  Created by zjs on 2018/5/21.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DNFrame)

/** Shortcut for frame.origin.x */
@property (nonatomic) CGFloat dn_x;

/** Shortcut for frame.origin.y */
@property (nonatomic) CGFloat dn_y;

/** Shortcut for frame.origin.x */
@property (nonatomic) CGFloat dn_right;

/** Shortcut for frame.origin.x + frame.size.width */
@property (nonatomic) CGFloat dn_bottom;

/** Shortcut for frame.size.width */
@property (nonatomic) CGFloat dn_width;

/** Shortcut for frame.size.height */
@property (nonatomic) CGFloat dn_height;

/** Shortcut for center.x */
@property (nonatomic) CGFloat dn_centerX;

/** Shortcut for center.y */
@property (nonatomic) CGFloat dn_centerY;

/** Shortcut for frame.origin */
@property (nonatomic) CGPoint dn_origin;

/** Shortcut for frame.size */
@property (nonatomic) CGSize  dn_size;

@end
