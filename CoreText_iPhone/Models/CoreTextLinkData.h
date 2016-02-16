//
//  CoreTextLinkData.h
//  CoreText_iPhone
//
//  Created by mac on 11/19/15.
//  Copyright © 2015 JY. All rights reserved.
//

// 解析 JSON 文件中的链接信息

#import <Foundation/Foundation.h>

@interface CoreTextLinkData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSRange range;

@end
