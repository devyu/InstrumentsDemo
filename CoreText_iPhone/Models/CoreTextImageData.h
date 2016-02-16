//
//  CoreTextImageData.h
//  CoreText_iPhone
//
//  Created by mac on 11/18/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextImageData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int position;


// 注意：这里的坐标是 CoreText 的坐标，而不是 UIKit 中的坐标
@property (nonatomic) CGRect imagePosition;

@end
