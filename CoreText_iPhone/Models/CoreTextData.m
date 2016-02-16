//
//  CoreTextData.m
//  CoreText_iPhone
//
//  Created by mac on 11/13/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import "CoreTextData.h"
#import "CoreTextImageData.h"

@implementation CoreTextData

- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)dealloc {
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

// ------- 保存图片绘制时候需要的信息 --------
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    
    
    [self fillImagePosition]; // 查找美张图片在绘制时候的位置
}

- (void)fillImagePosition {
    
    if (self.imageArray.count == 0) {
        return;
    }
    
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame); // 返回当前 CTFrame 存储的 CTLine 数组
    int lineCount = (int)[lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    CoreTextImageData *imageData = self.imageArray[0];
    
    for (int i = 0; i < lineCount; i++) {
        if (imageData == nil) {
            break;
        }
        
        CTLineRef lineRef = (__bridge CTLineRef)(lines[i]);
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(lineRef); // 获取当前 CTLine 中有多少个 CTRun
        
        for (id runObj in runObjArray) {
            
            // 获取 CTRunDelegate
            CTRunRef runRef = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(runRef);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)
                                                                     kCTRunDelegateAttributeName];
            
            if (delegate == nil) {
                continue;
            }
            
            // Returns a run delegate’s “refCon” value.
            NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            
            // 计算当前 CTRun 所需要的 width
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            
            // 设置当前 CTLine 的偏移量
            CGFloat xOffset = CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef); // 计算 graphics 的边框
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imageData.imagePosition = delegateBounds;
            imgIndex++;
            if (imgIndex == self.imageArray.count) {
                imageData = nil;
                break;
            } else {
                imageData = self.imageArray[imgIndex];
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
}

@end
