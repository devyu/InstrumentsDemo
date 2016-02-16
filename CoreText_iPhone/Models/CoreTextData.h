//
//  CoreTextData.h
//  CoreText_iPhone
//
//  Created by mac on 11/13/15.
//  Copyright © 2015 JY. All rights reserved.
//

// 用来保存由 CTFrameParser 类生成的 CTFrameRef 实例，以及 CTFrameRef 实际绘制需要的高度
// 用于承载显示所需要的所有数据
#import <Foundation/Foundation.h>

@interface CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;

/**
 * 用于保存图片绘制是所需要的信息
 */
@property (nonatomic, strong) NSArray *imageArray;

/**
 * 用于保存 链接 数组
 */
@property (nonatomic, strong) NSArray *linkArray;


@end
