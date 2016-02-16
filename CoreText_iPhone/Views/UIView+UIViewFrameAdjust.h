//
//  UIView+UIViewFrameAdjust.h
//  CoreText_iPhone
//
//  Created by mac on 11/13/15.
//  Copyright © 2015 JY. All rights reserved.
//


// 给 UIView 增加一个分类，方便调整 UIView 的 x、y、width、height 等值

#import <UIKit/UIKit.h>

@interface UIView (UIViewFrameAdjust)

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)point;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)tail;
- (void)setTail:(CGFloat)tail;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

@end
