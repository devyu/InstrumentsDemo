//
//  CoreTextUtils.m
//  CoreText_iPhone
//
//  Created by mac on 11/19/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import "CoreTextUtils.h"

@implementation CoreTextUtils

// 检测点击是否在链接上
+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data {
    
    CTFrameRef textFrameRef = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrameRef);
    if (!lines) return nil;
    CFIndex count = CFArrayGetCount(lines);
    CoreTextLinkData *foundLink = nil;
    
    // 获取每一行的 origin 坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrameRef, CFRangeMake(0, 0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    for (int i = 0; i < count; i ++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        // 获取每一行的 CGRect 信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform); // 将坐标转换到当前 rect 所对应的点
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成为相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect),
                                                point.y = CGRectGetMinY(rect)); // 获取到点击 “链接文字” 区域的坐标
            // 获得当前点击坐标对应的字符串的偏移量
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            // 判断偏移量是否在我们的链接列表当中
            foundLink = [self linkAtIndex:index linkArray:data.linkArray];
            return foundLink;
        }
    }
    
    return nil;
}

+ (CGRect)getLineBounds:(CTLineRef)linRef point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(linRef, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}


+ (CoreTextLinkData *)linkAtIndex:(CFIndex)i linkArray:(NSArray *)linkArray {
    CoreTextLinkData *link = nil;
    for (CoreTextLinkData *data in linkArray) {
        if (NSLocationInRange(i, data.range)) { // 判断当前点击的位置是否在某个 range 内
            link = data;
            break;
        }
    }
    
    return link;
}

@end
