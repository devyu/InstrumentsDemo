//
//  CTFrameParser.m
//  CoreText_iPhone
//
//  Created by mac on 11/13/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import "CTFrameParser.h"
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"

@implementation CTFrameParser

/**
 * 配置 Attributed 属性
 */
+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    UIColor *textColot = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColot.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    
    return dict;
}

#pragma mark - 根据 UBB 模板文件来生成 CoreTextData
+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config {
    // 增加 imageArray 的参数来保存解析时的图片信息
    NSMutableArray *imageArray = [NSMutableArray array];
    // 增加 linkArray 的参数保存解析链接信息
    NSMutableArray *linkArray = [NSMutableArray array];
    // 获取文本信息
    NSAttributedString *content = [self loadTemplateFile:path
                                                  config:config
                                              imageArray:imageArray
                                               linkArray:linkArray];
    CoreTextData *data = [self parseAttributedContent:content
                                               config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
 
    return data;
}

/**
 * 读取 JSON 内容，调用 parseAttributedContentFromDictionary: config:
 */
+ (NSAttributedString *)loadTemplateFile:(NSString *)path
                                  config:(CTFrameParserConfig *)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray{
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    
                    NSAttributedString *attributedString = [self parseAttributedContentFromDictionary:dict
                                                                                               config:config];
                    [result appendAttributedString:attributedString];
                }
                else if ([type isEqualToString:@"img"]) {
                    // 创建 CoreTextImageData
                    CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = (int)[result length];
                    [imageArray addObject:imageData];
                    
                    // 创建空白字符串，并设置它的 CTRunDelegate 信息
                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict
                                                                           config:config];
                    [result appendAttributedString:as];
                }
                else if ([type isEqualToString:@"link"]) {
                    NSUInteger startPos = result.length; // 当前 link 的起始位置
                    NSAttributedString *as = [self parseAttributedContentFromDictionary:dict
                                                                                 config:config];
                    [result appendAttributedString:as]; // 将当前的 attributedString 拼接到 result 上
                    
                    // 创建 CoreTextLinkData
                    NSUInteger lentth = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, lentth);
                    CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url = dict[@"url"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                    
                    
                }
            }
        }
    }
    
    return result;
}

#pragma mark -
static CGFloat ascentCallBack(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat decentCallback(void *ref) {
    return 0;
}

static CGFloat widthCallBack(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}

/**
 * 生成图片空白的占位符，并设置其 CTRunDelegate 信息
 */
+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                config:(CTFrameParserConfig *)config {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks)); // 使用 byte 值填充一个 byte string
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallBack;
    callbacks.getDescent = decentCallback;
    callbacks.getWidth = widthCallBack;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)dict);
    
    // 使用 0XFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar
                                                length:1];
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content
                                                                              attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    
    CFRelease(delegate);
    return space;
}

#pragma mark -
/**
 * 实现从 NSDictonary 转换为 NSAttributedString
 */
+ (NSAttributedString *)parseAttributedContentFromDictionary:(NSDictionary *)dict
                                                      config:(CTFrameParserConfig *)config {
    NSMutableDictionary *attributesDict = [self attributesWithConfig:config];
    // set color
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributesDict[(id)kCTForegroundColorAttributeName] = (id)(color.CGColor);
    }
    
    // set font size
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributesDict[(id)kCTFontAttributeName] = (__bridge id)(fontRef);
        CFRelease(fontRef);
    }
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content
                                           attributes:attributesDict];
}

/**
 * 提取颜色
 */
+ (UIColor *)colorFromTemplate:(NSString *)name {
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else if ([name isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else {
        return nil;
    }
}

/**
 * 接收一个 NSAttributedString 和 config 参数，将 NSAttributedString 转换为 CoreText
 */
+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config {
    // 创建 CTFramesetterRef 实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要缓存区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成 CTFrameRef 实例
    CTFrameRef frame = [self creatFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的 CTFrameRef 实例和计算好的缓存高度保存到 CoreTextData 实例中，最后返回 CoreTextRef 实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    // 释放内存
//    CFRelease(frame);
//    CFRelease(framesetter);
    return data;
}


/**
 * 生成 CTFrameRef 实例
 */
+ (CTFrameRef)creatFrameWithFramesetter:(CTFramesetterRef)framesetter
                                 config:(CTFrameParserConfig *)config
                                 height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    CFRelease(path);
    
    return frame;
    
}


#pragma mark -
/**
 * 创建 CTFramesetterRef、CTFrameRef，用于实现文件的排版
 */
+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config {
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content
                                                                        attributes:attributes];
    
    return [self parseAttributedContent:contentString config:config];
}


@end
