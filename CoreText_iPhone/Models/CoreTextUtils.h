//
//  CoreTextUtils.h
//  CoreText_iPhone
//
//  Created by mac on 11/19/15.
//  Copyright © 2015 JY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CoreTextLinkData.h"

@interface CoreTextUtils : NSObject

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

@end
