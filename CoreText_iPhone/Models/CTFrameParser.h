//
//  CTFrameParser.h
//  CoreText_iPhone
//
//  Created by mac on 11/13/15.
//  Copyright © 2015 JY. All rights reserved.
//

// 用于生成最后绘制界面需要的 CTFrameRef 实例，用来实现文字内容的排版

#import <Foundation/Foundation.h>
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"

@interface CTFrameParser : NSObject

/**
 *  配置排版基本的信息
 */
+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;

/**
 *  根据 NSString 生成 CoreTextData
 */
+ (CoreTextData *)parseContent:(NSString *)content
                        config:(CTFrameParserConfig *)config;

/**
 *  根据 NSAttributedString 生成 CoreTextData
 */
+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content
                                  config:(CTFrameParserConfig *)config;

/**
 *  对外部提供接口，根据 UBB 模板实现能够从 JSON 文件中读取内容，转换为 CoreTextData
 */
+ (CoreTextData *)parseTemplateFile:(NSString *)path
                             config:(CTFrameParserConfig *)config;

@end
