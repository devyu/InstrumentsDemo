//
//  CTFrameParserConfig.h
//  CoreText_iPhone
//
//  Created by mac on 11/13/15.
//  Copyright © 2015 JY. All rights reserved.
//

// 用来配置绘制参数，例如文字颜色、大小、行间距，用于实现一些排版时的可配置项

#import <Foundation/Foundation.h>

@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;

@end
