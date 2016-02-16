//
//  CTFrameParserConfig.m
//  CoreText_iPhone
//
//  Created by mac on 11/13/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}

@end
